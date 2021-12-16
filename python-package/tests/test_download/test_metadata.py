from os import read
import pytest
from pathlib import Path
import pandas as pd
from pandas_gbq.gbq import GenericGBQException
import shutil

from basedosdados import (
    list_datasets,
    list_dataset_tables,
    get_dataset_description,
    get_table_description,
    get_table_columns,
    get_table_size,
)
from basedosdados.exceptions import (
    BaseDosDadosException,
    BaseDosDadosNoBillingProjectIDException,
    BaseDosDadosInvalidProjectIDException,
)


TEST_PROJECT_ID = "basedosdados-dev"
SAVEFILE = Path(__file__).parent / "tmp_bases" / "test.csv"
SAVEPATH = Path(__file__).parent / "tmp_bases"
shutil.rmtree(SAVEPATH, ignore_errors=True)


def test_list_datasets(capsys):

    list_datasets(from_file=True)
    out, err = capsys.readouterr()  # Capture prints
    assert "dataset_id" in out


def test_list_datasets_complete(capsys):

    list_datasets(with_description=True, filter_by="ibge", from_file=True)
    out, err = capsys.readouterr()  # Capture prints
    assert "dataset_id" in out
    assert "description" in out


def test_list_datasets_all_descriptions(capsys):

    list_datasets(with_description=True, from_file=True)
    out, err = capsys.readouterr()  # Capture prints
    assert len(out) > 0


def test_list_datasets_verbose_false():

    out = list_datasets(from_file=True, verbose=False)
    assert type(out) == list
    assert len(out) > 0


def test_list_dataset_tables(capsys):

    list_dataset_tables(dataset_id="br_ibge_censo_demografico", from_file=True)
    out, err = capsys.readouterr()  # Capture prints
    assert "table_id" in out


def test_list_dataset_tables_complete(capsys):

    list_dataset_tables(
        dataset_id="br_ibge_censo_demografico",
        filter_by="renda",
        with_description=True,
        from_file=True,
    )
    out, err = capsys.readouterr()  # Capture prints
    assert "table_id" in out
    assert "description" in out
    assert "renda" in out


def test_list_dataset_tables_all_descriptions(capsys):
    list_dataset_tables(
        dataset_id="br_ibge_censo_demografico", with_description=True, from_file=True
    )
    out, err = capsys.readouterr()  # Capture prints
    assert len(out) > 0


def test_list_dataset_tables_verbose_false():

    out = list_dataset_tables(
        dataset_id="br_ibge_censo_demografico", from_file=True, verbose=False
    )
    assert type(out) == list
    assert len(out) > 0


def test_get_dataset_description(capsys):

    get_dataset_description("br_ibge_censo_demografico", from_file=True)
    out, err = capsys.readouterr()  # Capture prints
    assert len(out) > 0


def test_get_dataset_description_verbose_false():
    out = get_dataset_description(
        "br_ibge_censo_demografico", from_file=True, verbose=False
    )
    assert type(out) == str
    assert len(out) > 0


def test_get_table_description(capsys):
    get_table_description(
        "br_ibge_censo_demografico", "setor_censitario_basico_2010", from_file=True
    )
    out, err = capsys.readouterr()  # Capture prints
    assert len(out) > 0


def test_get_table_description_verbose_false():
    out = get_table_description(
        dataset_id="br_ibge_censo_demografico",
        table_id="setor_censitario_basico_2010",
        from_file=True,
        verbose=False,
    )
    assert type(out) == str
    assert len(out) > 0


def test_get_table_columns(capsys):
    get_table_columns(
        dataset_id="br_ibge_censo_demografico",
        table_id="setor_censitario_basico_2010",
        from_file=True,
    )
    out, err = capsys.readouterr()  # Capture prints
    assert "name" in out
    assert "field_type" in out
    assert "description" in out


def test_get_table_columns_verbose_false():
    out = get_table_columns(
        dataset_id="br_ibge_censo_demografico",
        table_id="setor_censitario_basico_2010",
        from_file=True,
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
