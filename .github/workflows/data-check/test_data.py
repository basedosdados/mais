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


dataset_table_ids = bd_credential.setup()
print("++++++++++++++dataset_table_ids++++++++++++++")
print(dataset_table_ids)
checks = Template(Path("/app/checks.yaml").open("r", encoding="utf-8").read())

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

print("\n\n\n++++++++++++++CONFIGS++++++++++++++")
for config in configs:
    print("\n\n", configs["test_table_exists"])
    print("\n\n", configs["test_select_all_works"])
    print(
        "\n\n",
        configs[
            "test_table_has_no_null_column" "\n\n",
        ],
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
    check = configs["test_table_exists"]
    result = bd.read_sql(check["query"])
    assert result.failure.values == False


def test_select_all_works(configs):
    check = configs["test_select_all_works"]
    result = bd.read_sql(check["query"])
    assert result.failure.values == False


def test_table_has_no_null_column(configs):
    check = configs["test_table_has_no_null_column"]
    result = bd.read_sql(check["query"])
    assert result.null_percent.max() < 1


### TODO | Ativar depois de testar a query
# def test_primary_key_has_unique_values(configs):
#     check = configs["test_primary_key_has_unique_values"]
#     result = bd.read_sql(check["query"])
#     assert result.to_numpy().all()
