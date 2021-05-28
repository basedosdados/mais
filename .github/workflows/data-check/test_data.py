import json
import yaml
import basedosdados as bd

from pathlib import Path
from jinja2 import Template

import bd_credential

# -------------------------------------
# 1.Executes at Collection Time
# -------------------------------------
# Gets jinja templates and fills them
# with data from table_config.yaml, then
# generate tests for different configs.
# -------------------------------------

# TODO: Adicionar try/excepts para erros de yamls mal configurados
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
                "project_id_staging"
            ],
            dataset_id=dataset_table_ids[table_id]["table_config"]["dataset_id"],
            table_id=table_id,
        )
    )
    for table_id in dataset_table_ids.keys()
]


def pytest_generate_tests(metafunc):
    metafunc.parametrize("configs", configs)


# -------------------------------------
# 2.Executes at Test Time
# -------------------------------------
# Each test is
# executed once
# for each table
# -------------------------------------


def test_table_exists(configs):
    query = configs["test_table_exists"]["query"].replace("\n", " ")
    result = bd.read_sql(
        query=query,
        billing_project_id="basedosdados-dev",
        from_file=True,
    )
    assert result.failure.values == False


def test_select_all_works(configs):
    query = configs["test_select_all_works"]["query"].replace("\n", " ")
    result = bd.read_sql(
        query=query,
        billing_project_id="basedosdados-dev",
        from_file=True,
    )
    assert result.failure.values == False


def test_table_has_no_null_column(configs):
    query = configs["test_table_has_no_null_column"]["query"].replace("\n", " ")
    result = bd.read_sql(
        query=query,
        billing_project_id="basedosdados-dev",
        from_file=True,
    )
    assert result.null_percent.max() < 1


### TODO | Ativar depois de testar a query
# def test_primary_key_has_unique_values(configs):
#     check = configs["test_primary_key_has_unique_values"]
#     result = bd.read_sql(check["query"])
#     assert result.to_numpy().all()
