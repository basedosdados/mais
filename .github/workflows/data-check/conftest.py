# -------------------------------------
# Execute at Collection Time
# -------------------------------------
# Gets jinja templates and fills them
# with data from table_config.yaml, then
# generate tests for different configs
# -------------------------------------

from pathlib import Path

import pytest
import yaml
from jinja2 import Template

import bd_credential

# -------------------------------------
# Get required tables
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
# Link fixtures to tests
# -------------------------------------


def pytest_generate_tests(metafunc):
    metafunc.parametrize("configs", configs)


# -------------------------------------
# Write a markdown report
# -------------------------------------


@pytest.hookimpl(tryfirst=True, hookwrapper=True)
def pytest_runtest_makereport(item, call):
    outcome = yield
    res = outcome.get_result()

    if res.when == "call" and res.failed:
        with Path("./report.md").open("a") as file:
            config = item.funcargs["configs"]
            config = config[item.originalname]

            file.write(f"❌ {config['error']}  \n")
            file.write(f"```sql  \n")
            file.write(f"{config['query']}")
            file.write(f"```  \n\n")
