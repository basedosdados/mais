# -------------------------------------
# Execute at Collection Time
# -------------------------------------
# Gets jinja templates and fills them
# with data from table_config.yaml, then
# generate tests with different configs
# -------------------------------------


import csv
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
        if len(data) >= 2:
            hidden = f"{data[0]}{data[-1]}" != "<>"
            return data.strip() if hidden else None
        return data.strip()
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
    with open("files.json", "r") as file:
        files = json.load(file)

    folders = [Path(file).parent for file in files]

    files = [folder / "table_config.yaml" for folder in folders]
    files = [file for file in files if file.exists()]
    files = list(set(files))

    return files


def filter_table_configs(config_paths: list[Path], skipfile: Path) -> list[Path]:
    """Filter table_config.yaml files not in DATA_CHECK_SKIP.csv"""
    with open(skipfile, "r") as file:
        reader = csv.reader(file)
        datasets = [row[0] for row in reader if len(row) > 0]

    is_banned = lambda x: x.parent.parent.name not in datasets

    config_paths = filter(is_banned, config_paths)
    config_paths = list(config_paths)

    return config_paths


def pytest_addoption(parser):
    parser.addoption(
        "--skipfile",
        action="store",
        default="",
        help="csv filepath with datasets to ignore",
    )


def pytest_configure(config):
    global _options
    _options = config.option


def pytest_sessionstart(session):
    """Initialize session, loading table configs"""
    global _configs

    # set filepaths for checks and configs
    # change this line to "checks.yaml" for local debugging
    check_path = "./.github/workflows/data-check/checks.yaml"
    # replace this line with a list of table_config.yaml paths for local debugging
    config_paths = get_table_configs()

    # filter datasets if skipfile is activated
    if _options.skipfile:
        skipfile = Path(_options.skipfile)
        config_paths = filter_table_configs(config_paths, skipfile)

    # exit if it has no fixtures
    if not config_paths:
        pytest.exit("No fixtures found", 0)

    # load checks with jinja2 placeholders
    # and replace the project variable by the
    # production environment if it's table approve action
    with open(check_path, "r", encoding="utf-8") as file:
        skeleton = file.read()
        if os.environ.get("IS_PROD_ENV", False):
            skeleton = skeleton.replace("{{ project_id }}", "basedosdados")
        else:
            skeleton = skeleton.replace("{{ project_id }}", "{{ project_id_prod }}")
        checks = Template(skeleton)

    # load checks with configs from table_config.yaml
    _configs = []
    for cpath in config_paths:
        with open(cpath, "r") as file:
            # load configs, a.k.a. table_config.yaml
            config = yaml.safe_load(file)
            config = omit_hints(config)

            # render jinja2 checks with config definitions
            config = checks.render(**config)
            config = yaml.safe_load(config)

            # save configs
            _configs.append(config)

    # create empty json report
    with open("./report.json", "w") as file:
        file.write("{}")


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
        with open("./report.json", "r") as file:
            config_id = item.funcargs["configs"]
            config_id = config_id[item.originalname]
            config_id = config_id["id"]

            data = json.load(file)
            data[config_id]["passed"] = not res.failed
        with open("./report.json", "w") as file:
            json.dump(data, file)


# -------------------------------------
# Execute once at session finish
# -------------------------------------


def pytest_sessionfinish(session, exitstatus):
    """Report overall test status in markdown"""
    with open("./report.json", "r") as file:
        data = json.load(file)
        data = [v for _, v in data.items()]
        data = sorted(data, key=lambda x: x["id"])
        n = [datum["id"].split("/")[-1] for datum in data]
        n = max(int(ni) for ni in n)

    with open("./report.md", "w") as file:
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
# https://docs.pytest.org/en/6.2.x/contents.html
# -------------------------------------
