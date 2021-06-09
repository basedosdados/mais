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
# Initialize fixtures
# -------------------------------------
# TODO: Split this section
# and move data checks to the Python API
# -------------------------------------


dataset_table_ids = bd_credential.setup()

checks = Template(
    Path("/home/runner/work/mais/mais/.github/workflows/data-check/checks.yaml")
    .open("r", encoding="utf-8")
    .read()
)

configs = [
    yaml.safe_load(
        checks.render(
            project_id_staging=dataset_table_ids[table_id]["table_config"][
                "project_id_prod"
            ],
            dataset_id=dataset_table_ids[table_id]["table_config"]["dataset_id"],
            table_id=table_id,
        )
    )
    for table_id in dataset_table_ids.keys()
]


# -------------------------------------
# Initialize json report
# -------------------------------------


def pytest_sessionstart(session):
    with Path("./report.json").open("w") as file:
        file.write("[]")


# -------------------------------------
# Link fixtures to tests
# -------------------------------------


def pytest_generate_tests(metafunc):
    metafunc.parametrize("configs", configs)


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
            config["passed"] = False if res.failed else True

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

    with Path("./report.md").open("w") as file:
        file.write("Data Check Report\n---\n\n")
        for datum in data:
            file.write("✔️ " if datum["passed"] else "❌ ")
            file.write(f"{datum['name']}  \n")
            file.write(f"```sql  \n")
            file.write(f"{datum['query']}")
            file.write(f"```  \n\n")


# -------------------------------------
# Reference
# https://docs.pytest.org/en/6.2.x/example/simple.html#post-process-test-reports-failures
# -------------------------------------
