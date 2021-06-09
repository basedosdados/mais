# -------------------------------------
# Execute at Collection Time
# -------------------------------------
# Gets jinja templates and fills them
# with data from table_config.yaml, then
# generate tests for different configs
# -------------------------------------


import json
from pathlib import Path

import pytest
import yaml
from jinja2 import Template

import bd_credential

# -------------------------------------
# Initialize fixtures and json report
# -------------------------------------
# TODO: Split this section
# and move data checks to the Python API
# -------------------------------------


def pytest_sessionstart(session):
    global _configs

    # set filepaths for checks and configs
    check_path = "./.github/workflows/data-check/checks.yaml"
    config_paths = bd_credential.setup()

    # load checks with jinja2 placeholders
    with Path(check_path).open("r", encoding="utf-8") as file:
        checks = Template(file.read())

    # load checks with configs from table_config.yaml
    _configs = []
    for cpath in config_paths:
        with Path(cpath).open("r") as file:
            config = yaml.safe_load(file)
            config = checks.render(**config)
            config = yaml.safe_load(config)
            _configs.append(config)

    # create empty json report
    with Path("./report.json").open("w") as file:
        file.write("[]")


# -------------------------------------
# Link fixtures to tests
# -------------------------------------


def pytest_generate_tests(metafunc):
    metafunc.parametrize("configs", _configs)


# -------------------------------------
# Write a json report
# -------------------------------------


@pytest.hookimpl(tryfirst=True, hookwrapper=True)
def pytest_runtest_makereport(item, call):
    outcome = yield
    res = outcome.get_result()

    if res.when == "call":
        with Path("./report.json").open("r+") as file:
            config = item.funcargs["configs"]
            config = config[item.originalname]
            config["passed"] = not res.failed

            data = json.load(file)
            data.append(config)
            file.seek(0)
            json.dump(data, file)


# -------------------------------------
# Write a markdown report
# -------------------------------------


def pytest_sessionfinish(session, exitstatus):
    with Path("./report.json").open("r") as file:
        data = json.load(file)
        data = sorted(data, key=lambda x: x["id"])
        n = [datum["id"].split("/")[-1] for datum in data]
        n = max(int(ni) for ni in n)

    with Path("./report.md").open("w") as file:
        file.write("Data Check Report\n---\n\n")

        for datum in data:
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
