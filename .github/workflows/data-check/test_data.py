# -------------------------------------
# Execute at Test Time
# -------------------------------------
# Each test is executed
# once for all tables
# -------------------------------------

import json

import basedosdados as bd
import pytest

# -------------------------------------
# Auxiliar functions
# -------------------------------------


def store_log(config):
    """Store each test log on report.json"""
    with open("./report.json", "r") as file:
        data = json.load(file)
        data[config["id"]] = config
    with open("./report.json", "w") as file:
        json.dump(data, file)


def store_skip(config):
    """Store each test error on report.json"""
    store_log(config)
    pytest.skip()


def store_error(config):
    """Store each test error on report.json"""
    store_log(config)
    pytest.fail()


def fetch_data(config):
    """Fetch data from Big Query with basedosdados package"""
    if not config["query"].strip():
        config["name"] += " (QueryDoesNotExist Exception)"
        store_skip(config)
    try:
        return bd.read_sql(
            query=config["query"].replace("\n", " "),
            billing_project_id="basedosdados-dev",  # change this value for local debugging
            from_file=True,  # comment this line for local debugging
        )
    except:
        config["name"] += " (BaseDosDados Exception)"
        store_error(config)


# -------------------------------------
# Test Suite
# Please write your tests below
# -------------------------------------


def test_table_exists(configs):
    config = configs["test_table_exists"]
    result = fetch_data(config)

    store_log(config)

    assert result.success.values == True


def test_table_has_no_null_column(configs):
    config = configs["test_table_has_no_null_column"]
    result = fetch_data(config)

    if not result.empty:
        vars = result[result.null_percent == 1]
        vars = vars.col_name.values.ravel()
        vars = ", ".join(vars)
        if vars:
            config["name"] += f"\n- {vars}"

    store_log(config)

    assert result.empty or (result.null_percent.max() < 1)


def test_identifying_column_has_unique_values(configs):
    config = configs["test_identifying_column_has_unique_values"]
    result = fetch_data(config)

    result = result.unique_percentage.values[0]
    config["name"] += f" ({100.0 * result:.2f})"

    store_log(config)

    assert True
