import re

import emoji
from github import Github


def write_contributions(user, users, contribution_types, levels):
    text = ""
    for c_type in contribution_types:
        contributions = users[user]["contributions"][c_type]
        details = contributions["approved_pulls"]

        if type(contributions["level"]) == int:
            text += f"""<br /><b>{c_type} {contributions["level"]} {levels[contributions["level"]]["emoji"]}</b>
            <small><br />submitted: {details["submitted"]} • reviewed: {details["reviewed"]} • merged: {details["merged"]}</small>"""

    return text


def write_table(users, contribution_types, levels):
    table = """<tr style="vertical-align:top">"""
    for i, user in enumerate(users.keys()):
        table += emoji.emojize(
            f"""
        <td align="center" style="vertical-align:top">
            <a href="https://api.github.com/users/{user}">
                <img src="{users[user]["photo"]}" width="100px;" alt=""/>
                <br /><b>{user}</b>
            </a>
            {write_contributions(user, users, contribution_types, levels)}
        </td>
        """.replace(
                "\n", ""
            ).replace(
                "None", ""
            )
        )

        # makes 3 items each row, it could be better
        i += 1
        if i % 3 == 0:
            if len(users) == i:
                table += "</tr>"
            else:
                table += """</tr><tr style="vertical-align:top">"""

    if table[:-6] != "</tr>":
        table += "</tr>"

    return table


def write_reference(levels):
    text = ""
    for level, content in levels.items():
        conditions = re.sub(
            "{|}|'", "", str(levels[level]["conditions"]).replace(",", " •")
        )

        text += f"""
        <tr><td>{level} {levels[level]["emoji"]}
        <td>{levels[level]["permission"]}
        <td>{conditions}</tr>
        """
    return text


def write_markdown(
    users, levels, username, token, contribution_types=["[infra]", "[dados]", "[docs]"]
):

    text = emoji.emojize(
        f"""<h1>Contribuições</h1>
    <h2>Como funciona</h2>
    Essa é a galera que faz a BD acontecer! Os níveis de contribuição determinam as permissões dos usuários:<br>
    <table>
    <b><tr><td>Level<td>Permissão<td>Condições</b></tr>
    {write_reference(levels)}
    </table>
    <h2>Contribuidores(as)</h2>
    <table>
    {write_table(users,contribution_types, levels)}
    </table>
    <br>
    """.replace(
            "\n", ""
        )
    )

    g = Github(username, token)

    repo = g.get_repo("basedosdados/mais")
    file = repo.get_contents("CONTRIBUTORS.md", ref="master")

    print(file.sha)
    print(text)

    repo.update_file(
        path="CONTRIBUTORS.md",
        message="update contributors content",
        content=text,
        sha=file.sha,
        branch="master",
    )
