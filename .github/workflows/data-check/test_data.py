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

# TODO: Adicionar try/catchs para erros de yamls mal configurados

bd_credential.setup()

with Path("github/workspace/files.json").open("r") as changesfile:
    changedfiles = json.load(changesfile)
    changed_files = filter(lambda x: x.name == "table_config.yaml", changed_files)
    changed_files = filter(lambda x: Path(x).is_file(), changed_files)
    changed_files = map(lambda x: Path(x), changed_files)
    changed_files = list(changed_files)

# DEBUG START
# changed_files = [Path("C:/Users/Vinicius/Documents/mais/bases/br_bd_diretorios_brasil/municipio/table_config.yaml")]
# DEBUG END

with Path("./checks.yaml").open("r") as checkfile:
    configs = []
    checks = checkfile.read()
    checks = Template(checks)
    for changed_file in changed_files:
        with changed_file.open("r") as configfile:
            config = yaml.safe_load(configfile)
            config = checks.render(**config)
            config = yaml.safe_load(config)
            configs.append(config)

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
    
def test_primary_key_has_unique_values(configs):
    check = configs["test_primary_key_has_unique_values"]
    result = bd.read_sql(check["query"])
    assert result.to_numpy().all()