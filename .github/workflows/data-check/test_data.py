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
# bd_credential.setup()

# with Path("github/workspace/files.json").open("r") as changed_files:
#     changed_files = json.load(changed_files)
#     changed_files = map(lambda x: Path(x), changed_files)
#     changed_files = filter(lambda x: x.is_file(), changed_files)
#     changed_files = filter(lambda x: x.name == "table_config.yaml", changed_files)

# # DEBUG START
# # changed_files = [Path("C:/Users/Vinicius/Documents/mais/bases/br_bd_diretorios_brasil/municipio/table_config.yaml")]
# # DEBUG END

# with Path("./checks.yaml").open("r") as checkfile:
#     configs = []
#     checks = checkfile.read()
#     checks = Template(checks)
#     for changed_file in changed_files:
#         with changed_file.open("r") as configfile:
#             config = yaml.safe_load(configfile)
#             config = checks.render(**config)
#             config = yaml.safe_load(config)
#             configs.append(config)

print("\n\n++++++++++++++++++++++++++++LOG_IDS++++++++++++++++++++++++++++")
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

print("\n\n++++++++++++++++++++++++++++LOG_CONFIGS++++++++++++++++++++++++++++")
for config in configs:
    print(
        "\n test_table_exists\n",
        config["test_table_exists"]["query"],
        "\n test_select_all_works\n",
        config["test_select_all_works"]["query"],
        "\n test_table_has_no_null_column\n",
        config["test_table_has_no_null_column"]["query"],
        "\n\n",
    )
from basedosdados.upload.base import Base

print("\n\n++++++++++++++++++++++++++++TEST_BDM++++++++++++++++++++++++++++")
print(Base().config_path)
print(bd.__file__)
print(
    bd.read_sql(
        query="""SELECT * FROM `basedosdados-dev.br_bd_diretorios_brasil.municipio` LIMIT 10""",
        billing_project_id="basedosdados-dev",
    )
)


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
    query = configs["test_table_exists"]["query"].replace("\n", "")
    result = bd.read_sql(query=query, billing_project_id="basedosdados-dev")
    assert result.failure.values == False


def test_select_all_works(configs):
    query = configs["test_select_all_works"]["query"].replace("\n", "")
    result = bd.read_sql(query=query, billing_project_id="basedosdados-dev")
    assert result.failure.values == False


def test_table_has_no_null_column(configs):
    query = configs["test_table_has_no_null_column"]["query"].replace("\n", "")
    result = bd.read_sql(query=query, billing_project_id="basedosdados-dev")
    assert result.null_percent.max() < 1


### TODO | Ativar depois de testar a query
# def test_primary_key_has_unique_values(configs):
#     check = configs["test_primary_key_has_unique_values"]
#     result = bd.read_sql(check["query"])
#     assert result.to_numpy().all()
