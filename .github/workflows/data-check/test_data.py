# -------------------------------------
# Execute at Test Time
# -------------------------------------
# Each test is executed
# once for all tables
# -------------------------------------

import pytest
import basedosdados as bd
import pandas as pd


# -------------------------------------
# Fetch data from Big Query
# -------------------------------------


def fetch_data(data_check, configs):
    assert data_check in configs
    query = configs[data_check]["query"]

    print(f"Check: {data_check}")
    print(f"Query: \n{query}\n\n")

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


# TODO: Ativar depois de testar a query
# def test_primary_key_has_unique_values(configs):
#     check = configs["test_primary_key_has_unique_values"]
#     result = fetch_data("test_primary_key_has_unique_values")
#     assert result.to_numpy().all()
