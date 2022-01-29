from os import read
import pytest
from pathlib import Path
import pandas as pd
from pandas_gbq.gbq import GenericGBQException
import shutil
import requests

from basedosdados import (
    list_datasets,
    list_dataset_tables,
    get_dataset_description,
    get_table_description,
    get_table_columns,
    get_table_size,
    search
)


TEST_PROJECT_ID = "basedosdados-dev"
SAVEFILE = Path(__file__).parent / "tmp_bases" / "test.csv"
SAVEPATH = Path(__file__).parent / "tmp_bases"
shutil.rmtree(SAVEPATH, ignore_errors=True)

def test_list_datasets_simple_verbose(capsys):

    out = list_datasets(
        query="trabalho", limit=10, with_description=False, verbose=True
    )
    out, err = capsys.readouterr()  # Capture prints
    assert "dataset_id" in out
    # check input error
    with pytest.raises(ValueError):
        search(query="trabalho", order_by="name")


def test_list_datasets_simple_list():

    out = list_datasets(query="", limit=12, with_description=False, verbose=False)
    # check if function returns list
    assert isinstance(out, list)
    assert len(out) == 12


def test_list_datasets_complete_list():

    out = list_datasets(
        query="trabalho", limit=12, with_description=True, verbose=False
    )
    # check if function returns list
    assert isinstance(out, list)
    assert "dataset_id" in out[0].keys()
    assert "description" in out[0].keys()


def test_list_datasets_complete_verbose(capsys):

    list_datasets(query="trabalho", limit=10, with_description=True, verbose=True)
    out, err = capsys.readouterr()  # Capture prints
    assert "dataset_id" in out
    assert "description" in out


def test_list_dataset_tables_simple_verbose(capsys):

    list_dataset_tables(dataset_id="br_me_caged", with_description=False, verbose=True)
    out, err = capsys.readouterr()  # Capture prints
    assert "table_id" in out


def test_list_dataset_tables_simple_list():

    out = list_dataset_tables(
        dataset_id="br_me_caged", with_description=False, verbose=False
    )

    assert type(out) == list
    assert len(out) > 0


def test_list_dataset_tables_complete_verbose(capsys):

    list_dataset_tables(dataset_id="br_me_caged", with_description=True, verbose=True)

    out, err = capsys.readouterr()  # Capture prints
    assert "table_id" in out
    assert "description" in out


def test_list_dataset_tables_complete_list():

    out = list_dataset_tables(
        dataset_id="br_me_caged", with_description=True, verbose=False
    )

    assert type(out) == list
    assert type(out[0]) == dict


def test_get_dataset_description(capsys):

    get_dataset_description("br_me_caged", verbose=True)
    out, err = capsys.readouterr()  # Capture prints
    assert len(out) > 0


def test_get_dataset_description_verbose_false():
    out = get_dataset_description("br_me_caged", verbose=False)
    assert type(out) == str
    assert len(out) > 0


def test_get_table_description(capsys):
    get_table_description("br_me_caged", "microdados_antigos")
    out, err = capsys.readouterr()  # Capture prints
    assert len(out) > 0


def test_get_table_description_verbose_false():
    out = get_table_description(
        dataset_id="br_me_caged",
        table_id="microdados_antigos",
        verbose=False,
    )
    assert type(out) == str
    assert len(out) > 0


def test_get_table_columns(capsys):
    get_table_columns(
        dataset_id="br_me_caged",
        table_id="microdados_antigos",
    )
    out, err = capsys.readouterr()  # Capture prints
    assert "name" in out
    assert "description" in out


def test_get_table_columns_verbose_false():
    out = get_table_columns(
        dataset_id="br_me_caged",
        table_id="microdados_antigos",
        verbose=False,
    )
    assert type(out) == list
    assert len(out) > 0


def test_get_table_size(capsys):
    get_table_size(
        dataset_id="br_ibge_censo_demografico",
        table_id="setor_censitario_basico_2010",
        billing_project_id=TEST_PROJECT_ID,
        from_file=True,
    )
    out, err = capsys.readouterr()
    assert "num_rows" in out
    assert "size_mb" in out


def test_get_table_size_verbose_false():
    out = get_table_size(
        dataset_id="br_ibge_censo_demografico",
        table_id="setor_censitario_basico_2010",
        billing_project_id=TEST_PROJECT_ID,
        from_file=True,
        verbose=False,
    )
    assert type(out) == list
    assert len(out) > 0


def test_search():
    out = search(query="agua", order_by="score")
    # check if function returns pd.DataFrame
    assert isinstance(out, pd.DataFrame)
    # check if there is duplicate tables in the result
    assert out.id.nunique() == out.shape[0]
    # check input error
    with pytest.raises(ValueError):
        search(query="agua", order_by="name")

def test_get_table_size(capsys):
    get_table_size(
        dataset_id="br_ibge_censo_demografico",
        table_id="setor_censitario_basico_2010",
        billing_project_id=TEST_PROJECT_ID,
        from_file=True,
    )
    out, err = capsys.readouterr()
    assert "num_rows" in out
    assert "size_mb" in out


def test_get_table_size_verbose_false():
    out = get_table_size(
        dataset_id="br_ibge_censo_demografico",
        table_id="setor_censitario_basico_2010",
        billing_project_id=TEST_PROJECT_ID,
        from_file=True,
        verbose=False,
    )
    assert type(out) == list
    assert len(out) > 0