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
                "project_id_prod"
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
def fetch_data(data_ckeck, configs):
    query = configs[data_ckeck]["query"].replace("\n", " ")
    return bd.read_sql(
        query=query,
        billing_project_id="basedosdados-dev",
        from_file=True,
    )


def test_table_exists(configs):
    result = fetch_data("test_table_exists", configs)

    assert result.failure.values == False


def test_select_all_works(configs):
    result = fetch_data("test_select_all_works", configs)

    assert result.failure.values == False


def test_table_has_no_null_column(configs):
    result = fetch_data("test_table_has_no_null_column", configs)

    assert result.null_percent.max() < 1


# ### TODO | Ativar depois de testar a query
# def test_primary_key_has_unique_values(configs):
#     check = configs["test_primary_key_has_unique_values"]
#     result = fetch_data("test_primary_key_has_unique_values")
#     assert result.to_numpy().all()
