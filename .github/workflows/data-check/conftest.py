# -------------------------------------
# Execute at Collection Time
# -------------------------------------
# Gets jinja templates and fills them
# with data from table_config.yaml, then
# generate tests with different configs
# -------------------------------------


import json
import os
from pathlib import Path

import pytest
import yaml
from jinja2 import Template

# -------------------------------------
# Execute once at session start
# -------------------------------------


def omit_hints(data):
    """Set values encapsulated with <> to None in a dict"""
    if isinstance(data, str):
        hidden = f"{data[0]}{data[-1]}" != "<>"
        return data if hidden else None
    elif isinstance(data, list):
        lst = list(filter(omit_hints, data))
        return lst if lst else None
    elif isinstance(data, dict):
        for key in data.keys():
            data[key] = omit_hints(data[key])
        return data
    return data


def get_table_configs():
    """Load table_config.yaml files"""
    files = open("files.json", "r").read()
    files = json.load(files)

    folders = [Path(file).parent for file in files]

    files = [folder / "table_config.yaml" for folder in folders]
    files = [file for file in files if file.exists()]

    return files


def pytest_sessionstart(session):
    """Initialize session, loading table configs"""
    global _configs

    # set filepaths for checks and configs
    check_path = "./.github/workflows/data-check/checks.yaml"  # change this line to "checks.yaml" for local debugging
    config_paths = (
        get_table_configs()
    )  # replace this line with a list of table_config.yaml paths for local debugging

    # load checks with jinja2 placeholders
    # and replace {{ project_id }} by the appropriate environment
    with Path(check_path).open("r", encoding="utf-8") as file:
        env = os.environ.get("BQ_ENVIRONMENT", "basedosdados-dev")
        text = file.read().replace("{{ project_id }}", env)
        checks = Template(text)

    # load checks with configs from table_config.yaml
    _configs = []
    for cpath in config_paths:
        with Path(cpath).open("r") as file:
            # load configs, a.k.a. table_config.yaml
            config = yaml.safe_load(file)
            config = omit_hints(config)

            # render jinja2 checks with config definitions
            config = checks.render(**config)
            config = yaml.safe_load(config)

            # save configs
            _configs.append(config)

    # create empty json report
    with Path("./report.json").open("w") as file:
        file.write("[]")


# -------------------------------------
# Execute once after session start
# -------------------------------------


def pytest_generate_tests(metafunc):
    """Link one fixture (table_config.yaml) to one test suite"""
    metafunc.parametrize("configs", _configs)


# -------------------------------------
# Execute once after each test
# -------------------------------------


@pytest.hookimpl(tryfirst=True, hookwrapper=True)
def pytest_runtest_makereport(item, call):
    """Add test status for each test in report.json"""
    outcome = yield
    res = outcome.get_result()

    if res.when == "call":
        with Path("./report.json").open("r+") as file:
            config = json.load(file)
            config[-1]["passed"] = not res.failed
            file.seek(0)
            json.dump(config, file)


# -------------------------------------
# Execute once at session finish
# -------------------------------------


def pytest_sessionfinish(session, exitstatus):
    """Report overall test status in markdown"""
    with Path("./report.json").open("r") as file:
        data = json.load(file)
        data = sorted(data, key=lambda x: x["id"])
        n = [datum["id"].split("/")[-1] for datum in data]
        n = max(int(ni) for ni in n)

    with Path("./report.md").open("w") as file:
        file.write("Data Check Report\n---\n\n")

        for datum in data:
            if int(datum["id"].split("/")[-1]) == 0:
                file.write(f" Table `{datum['id'][:-2]}`  \n\n")
            if datum["passed"]:
                file.write(f"✔️ {datum['name']}  \n\n")
            else:
                file.write(f"❌ {datum['name']}  \n\n")
                file.write(f"```sql  \n")
                file.write(f"{datum['query']}")
                file.write(f"```  \n\n")

            if int(datum["id"].split("/")[-1]) == n:
                file.write("---\n\n")


# -------------------------------------
# Reference
# https://docs.pytest.org/en/6.2.x/example/simple.html#post-process-test-reports-failures
# -------------------------------------
