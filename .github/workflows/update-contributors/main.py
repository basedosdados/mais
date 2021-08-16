import os
from collections import Counter

import requests
from dotenv import load_dotenv
from generate_markdown import write_markdown

levels = {
    1: {
        "emoji": ":hatching_chick:",
        "permission": "Read",
        "conditions": {"submitted": 1, "reviewed": 0, "merged": 0},
    },
    2: {
        "emoji": ":baby_chick:",
        "permission": "Triage",
        "conditions": {"submitted": 5, "reviewed": 0, "merged": 0},
    },
    3: {
        "emoji": ":chicken:",
        "permission": "Write",
        "conditions": {"submitted": 10, "reviewed": 5, "merged": 0},
    },
    4: {
        "emoji": ":peacock:",
        "permission": "Maintain",
        "conditions": {"submitted": 20, "reviewed": 10, "merged": 1},
    },
}

# load_dotenv(dotenv_path=".env", override=True)
username = os.environ.get("GHUSER")
token = os.environ.get("GHTOKEN")


def get_pulls(username, token):
    print("Obtendo pulls...")
    i = 1
    pulls = list()
    while i > 0:
        response = requests.get(
            f"https://api.github.com/repos/basedosdados/mais/pulls?state=all;per_page=100;page={i}",
            auth=(username, token),
        ).json()
        if len(response) > 0:
            pulls += response
            i += 1
        else:
            break
    return pulls


def update_user_content(users, content, content_type, contribution_type):
    for user, value in content.items():
        if user in users.keys():
            users[user]["contributions"][contribution_type]["approved_pulls"][
                content_type
            ] = value
    return users


def get_submitted(users, approved_pulls, contribution_type):
    content = dict(Counter([p["user"]["login"] for p in approved_pulls]))
    return update_user_content(users, content, "submitted", contribution_type)


def get_reviewed(users, approved_pulls, contribution_type):
    reviewed = list()
    for p in approved_pulls:
        url = f"https://api.github.com/repos/basedosdados/mais/pulls/{p['number']}/reviews"
        response = requests.get(url, auth=(username, token)).json()
        if len(response) > 0:
            reviewed += response
    content = dict(Counter([p["user"]["login"] for p in reviewed]))
    return update_user_content(users, content, "reviewed", contribution_type)


def get_merged(users, approved_pulls, contribution_type):
    merged = list()
    for p in approved_pulls:
        response = requests.get(p["url"], auth=(username, token)).json()
        merged += [response]
    content = dict(Counter([p["merged_by"]["login"] for p in merged]))
    return update_user_content(users, content, "merged", contribution_type)


def update_contributions(users, approved_pulls, contribution_type):
    approved_pulls = [
        p for p in approved_pulls if p["title"].startswith(contribution_type)
    ]
    users = get_submitted(users, approved_pulls, contribution_type)
    users = get_reviewed(users, approved_pulls, contribution_type)
    users = get_merged(users, approved_pulls, contribution_type)

    return users


def get_level(scores, levels):
    max_level = None
    for level, values in levels.items():
        reference = values["conditions"]
        if all(scores[k] >= reference[k] for k in reference.keys()):
            max_level = level
    return max_level


def set_contributors(
    contribution_types,
    url="https://api.github.com/repos/basedosdados/mais/contributors",
):
    return {
        user["login"]: {
            "photo": user["avatar_url"],
            "contributions": {
                c_type: {
                    "approved_pulls": {"submitted": 0, "reviewed": 0, "merged": 0},
                    "level": None,
                }
                for c_type in contribution_types
            },
        }
        for user in requests.get(url, auth=(username, token)).json()
    }


def get_contributors_levels(contribution_types=["[infra]", "[dados]", "[docs]"]):
    users = set_contributors(contribution_types)
    pulls = get_pulls(username, token)
    approved_pulls = [p for p in pulls if p["merged_at"] != None]

    for c_type in contribution_types:
        print(f"Atualizando contribuições de {c_type}...")
        users = update_contributions(users, approved_pulls, c_type)

        print(f"Calculando level de cada user...")
        for user, content in users.items():
            scores = content["contributions"][c_type]["approved_pulls"]
            users[user]["contributions"][c_type]["level"] = get_level(scores, levels)

    return users


if __name__ == "__main__":
    users = get_contributors_levels()
    write_markdown(users, levels, username, token)
