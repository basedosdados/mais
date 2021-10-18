import json


def gen_report(jsonpath, mdpath):
    with open(jsonpath, "r") as file:
        traces = json.loads(jsonpath)

    if not traces:
        return None

    with open(mdpath, "w") as file:
        file.write(f"Stack Traces\n")
        file.write(f"---\n\n")

        for trace in traces:
            file.write(f"  {trace['dataset']}  \n\n")
            file.write(f"```  \n")
            file.write(f"{trace['output']}")
            file.write(f"```  \n\n")


if __name__ == "__main__":
    gen_report("./report.json", "./report.md")
