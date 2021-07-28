# -------------------------------------
# Execute at Test Time
# -------------------------------------
# Each test is executed
# once for all tables
# -------------------------------------

import basedosdados as bd
import pandas as pd
import pytest

# -------------------------------------
# Fetch data from Big Query
# -------------------------------------


def fetch_data(check, configs):
    assert check in configs
    assert "query" in configs[check]
    query = configs[check]["query"]

    print(f"Check: {check}")
    print(f"Query: \n{query}")

    data = bd.read_sql(
        query=query.replace("\n", " "),
        billing_project_id="basedosdados-dev",
        from_file=True,
    )

    assert isinstance(data, pd.DataFrame)
    return data


# -------------------------------------
# Test Suite
# Please write your tests below
# -------------------------------------


def test_table_exists(configs):
    result = fetch_data("test_table_exists", configs)
    assert result.failure.values == False


def test_select_all_works(configs):
    result = fetch_data("test_select_all_works", configs)
    assert result.failure.values == False


def test_table_has_no_null_column(configs):
    result = fetch_data("test_table_has_no_null_column", configs)
    assert result.empty or result.null_percent.max() < 1


def test_primary_key_has_unique_values(configs):
    name = "test_primary_key_has_unique_values"
    if name in configs and "query" in configs[name]:
        result = fetch_data(name, configs)
        assert result.unique_percentage.values == 1
