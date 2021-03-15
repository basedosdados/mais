from collections import Counter
import requests
from dotenv import load_dotenv

load_dotenv(dotenv_path=".env", override=True)

import os
username = os.environ.get("GHUSER")
token = os.environ.get("GHTOKEN")

levels = {
    0: {
        'submitted': 1,
        'reviewed': 0,
        'merged': 0
    },
    1: {
        'submitted': 5,
        'reviewed': 0,
        'merged': 0
    },
    2: {
        'submitted': 10,
        'reviewed': 5,
        'merged': 0
    },
    3: {
        'submitted': 20,
        'reviewed': 10,
        'merged': 1
    }
}

def get_pulls(username, token):
    print("Obtendo pulls...")
    i = 1
    pulls = list()
    while i > 0:
        response = requests.get(
            f"https://api.github.com/repos/basedosdados/mais/pulls?state=all;per_page=100;page={i}", 
            auth=(username,token)).json()
        if len(response) > 0:
            pulls += response
            i+=1
        else:
            break
    return pulls

def update_user_content(users, content, content_type, contribution_type):
    for user, value in content.items():
        if user in users.keys():
            users[user][contribution_type]["approved_pulls"][content_type] = value
    return users

def get_submitted(users, approved_pulls, contribution_type):
    content = dict(Counter([p["user"]["login"] for p in approved_pulls]))
    return update_user_content(users, content, "submitted", contribution_type)

def get_reviewed(users, approved_pulls, contribution_type):
    reviewed = list()
    for p in approved_pulls:
        url = f"https://api.github.com/repos/basedosdados/mais/pulls/{p['number']}/reviews"
        response = requests.get(url, auth=(username,token)).json()
        if len(response) > 0:
            reviewed += response
    content = dict(Counter([p["user"]["login"] for p in reviewed]))
    return update_user_content(users, content, "reviewed", contribution_type)

def get_merged(users, approved_pulls, contribution_type):
    merged = list()
    for p in approved_pulls:
        response = requests.get(p["url"], auth=(username,token)).json()
        merged += [response]
    content = dict(Counter([p["merged_by"]["login"] for p in merged]))
    return update_user_content(users, content, "merged", contribution_type)

def update_contributions(users, approved_pulls, contribution_type):
    approved_pulls = [p for p in approved_pulls if p["title"].startswith(contribution_type)]
    users = get_submitted(users, approved_pulls, contribution_type)
    users = get_reviewed(users, approved_pulls, contribution_type)
    users = get_merged(users, approved_pulls, contribution_type)
    
    return users

def get_level(scores, levels):
    max_level = None
    if all(score != None for score in scores.values()):
        for level, reference in levels.items():
            if all(scores[k] >= reference[k] for k in reference.keys()):
                max_level = level      
    return max_level
    
def get_contributors_levels(contribution_types = ["[infra]", "[dados]", "[docs]"]):
    
    url = "https://api.github.com/repos/basedosdados/mais/contributors"

    users = {
        user["login"]: 
            {c_type: 
             {"approved_pulls": {
                    "submitted": None, 
                    "reviewed": None, 
                    "merged": None
                }, 
                "level": None}
               for c_type in contribution_types}
        for user in requests.get(url, auth=(username,token)).json()}
            
    pulls = get_pulls(username, token)
    approved_pulls = [p for p in pulls if p["merged_at"] != None]
    
    for c_type in contribution_types:
        print(f"Atualizando contribuições de {c_type}...")
        users = update_contributions(users, approved_pulls, c_type)
        
        print(f"Calculando level de cada user...")
        for user, contributions in users.items():
            scores = contributions[c_type]['approved_pulls']
            users[user][c_type]["level"] = get_level(scores, levels)

    return users

if name == "__main__":
    users = get_contributors_levels()