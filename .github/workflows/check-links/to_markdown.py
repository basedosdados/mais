import json

def to_markdown(jsonpath, mdpath):
    root = "https://github.com/basedosdados/mais/blob/master/"

    with open(jsonpath, "r") as file:
        data = json.load(file)

    with open(mdpath, "w") as file:
        file.write(f"Broken Links \[{data['failures']}E\]  \n")
        file.write("---  \n\n")
        for page, errors in data["fail_map"].items():
            file.write(f"**[{page}]({root}{page})**  \n")
            for error in errors:
                file.write(f"- {error['status']}  \n")
            file.write("\n")

if __name__ == "__main__":
    to_markdown("lychee/report.json", "lychee/report.md")

# Reference
# Lychee Action
# https://github.com/lycheeverse/lychee-action
