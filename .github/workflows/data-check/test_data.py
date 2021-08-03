# -------------------------------------
# Execute at Test Time
# -------------------------------------
# Each test is executed
# once for all tables
# -------------------------------------

import json
from pathlib import Path

import basedosdados as bd
import pandas as pd

# -------------------------------------
# Auxiliar functions
# -------------------------------------


def fetch_data(configs, check):
    """Fetch data from Big Query with basedosdados package"""
    return bd.read_sql(
        query=configs[check]["query"].replace("\n", " "),
        billing_project_id="basedosdados-dev",  # change this value for local debugging
        from_file=True,  # comment this line for local debugging
    )


def store_log(configs, check):
    """Store each test configuration on report.json"""
    with Path("./report.json").open("r+") as file:
        config = configs[check]
        data = json.load(file)
        data.append(config)
        file.seek(0)
        json.dump(data, file)


# -------------------------------------
# Test Suite
# Please write your tests below
# -------------------------------------


def test_table_exists(configs):
    name = "test_table_exists"
    result = fetch_data(configs, name)

    store_log(configs, name)

    assert result.sucess.values == True


# def test_select_all_works(configs):
#     name = "test_select_all_works"
#     result = fetch_data(configs, name)

#     store_log(configs, name)

#     assert result.sucess.values == True


def test_table_has_no_null_column(configs):
    name = "test_table_has_no_null_column"
    result = fetch_data(configs, name)

    if not result.empty:
        vars = result[result.null_percent == 1]
        vars = vars.col_name.values.ravel()
        vars = "\n".join([f"- {v}  " for v in vars])
        configs[name]["name"] += f"\n{vars}"

    store_log(configs, name)

    assert result.empty or (result.null_percent.max() < 1)


def test_primary_key_has_unique_values(configs):
    name = "test_primary_key_has_unique_values"

    if "query" in configs[name]:
        result = fetch_data(configs, name)
        result = result.unique_percentage.values[0]
    else:
        result = 1

    configs[name]["name"] += f" ({100.0 * result:.2f})"
    store_log(configs, name)

    assert result == 1
