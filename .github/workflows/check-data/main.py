import sys
import json
import yaml
import basedosdados as bd
from pathlib import Path
from jinja2 import Template

def get_configs(filepath = Path("github/workspace/files.json"), configname = Path("table_config.yaml")):
    if not filepath.exists():
        return []
    
    with open(filepath, "r") as file:
        filepaths = json.load(file)
        return filter(lambda x: x.name == configname, filepaths)

def get_checks(configpath: Path, checkspath: Path = Path("./checks.yml")):
    with open(configpath, "r") as file:
        config = yaml.safe_load(file)

    with open(checkspath, "r") as file:
        checks = file.read()
        checks = Template(checks)
        checks = checks.render(**config)
        checks = yaml.safe_load(checks)
        return checks

def check_table(checks):
    has_error = False

    for check in checks:
        try:
            result = bd.read_sql(
                check["query"],
                billing_project_id="basedosdados42"
            )
            if result.failure.values:
                print(f"ERROR: {check['error']}")
                has_error = True
        except Exception as error:
            print(f"ERROR: {error}")
            has_error = True
    
    return has_error

def check_data():
    has_error = False

    configpaths = sys.argv[1:]
    configpaths.extend(get_configs())
    
    for configpath in configpaths:
        checks = get_checks(configpath)
        has_error |= check_table(checks)

    if has_error:
        raise Exception("Unexpected Data")

if __name__ == "__main__":
    check_data()
