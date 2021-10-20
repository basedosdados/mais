import json
from subprocess import run


def get_changes():
    with open("./files.json", "r") as file:
        files = json.loads(file.read())
        files = [f.split("/")[1] for f in files]
        files = list(set(files))
        return files


def validate_metadata():
    steps = []
    datasets = get_changes()

    for dataset in datasets:
        step = run(
            ["basedosdados", "metadata", "validate", dataset], capture_output=True
        )
        output = step.stdout.decode("utf-8")
        steps.append(dict(dataset=dataset, output=output))

    with open("report.json", "w") as file:
        json.dump(steps, file)


if __name__ == "__main__":
    validate_metadata()
