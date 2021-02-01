import pytest
from pathlib import Path
import pandas as pd
import shutil

from basedosdados import (
    download,
    read_sql,
    read_table,
    list_datasets,
    list_dataset_tables,
    get_dataset_description,
    get_table_description,
    get_table_columns,
    get_table_size,
)
from basedosdados.exceptions import BaseDosDadosException


TEST_PROJECT_ID = "basedosdados-dev"
SAVEFILE = Path("tests/tmp_bases/test.csv")
SAVEPATH = Path("tests/tmp_bases/")
shutil.rmtree(SAVEPATH, ignore_errors=True)


def test_download_by_query():

    download(
        SAVEFILE,
        query="select * from `basedosdados.br_ibge_pib.municipios` limit 10",
        billing_project_id=TEST_PROJECT_ID,
    )

    assert SAVEFILE.exists()

    # No billing
    with pytest.raises(BaseDosDadosException):
        download(
            SAVEFILE,
            query="select * from `basedosdados.br_ibge_pib.municipios` limit 10",
        )


def test_download_by_table():

    download(
        SAVEFILE,
        dataset_id="br_ibge_pib",
        table_id="municipios",
        billing_project_id=TEST_PROJECT_ID,
        limit=10,
    )

    assert SAVEFILE.exists()

    # No billing
    with pytest.raises(BaseDosDadosException):
        download(
            SAVEFILE,
            dataset_id="br_ibge_pib",
            table_id="municipios",
            limit=10,
        )


def test_download_save_to_path():

    download(
        SAVEPATH,
        dataset_id="br_ibge_pib",
        table_id="municipios",
        billing_project_id=TEST_PROJECT_ID,
        limit=10,
    )

    assert (SAVEPATH / "municipios.csv").exists()


def test_download_no_query_or_table():

    with pytest.raises(BaseDosDadosException):
        download(
            SAVEFILE,
            limit=10,
        )


def test_download_pandas_kwargs():

    download(
        SAVEFILE,
        dataset_id="br_ibge_pib",
        table_id="municipios",
        billing_project_id=TEST_PROJECT_ID,
        limit=10,
        sep="|",
        index=False,
    )

    assert SAVEFILE.exists()


def test_read_sql():

    assert isinstance(
        read_sql(
            query="select * from `basedosdados.br_ibge_pib.municipios` limit 10",
            billing_project_id=TEST_PROJECT_ID,
        ),
        pd.DataFrame,
    )


def test_read_table():

    assert isinstance(
        read_table(
            dataset_id="br_ibge_pib",
            table_id="municipios",
            billing_project_id=TEST_PROJECT_ID,
            limit=10,
        ),
        pd.DataFrame,
    )


def test_list_datasets(capsys):

    list_datasets()
    out, err = capsys.readouterr()  # Capture prints
    assert "dataset_id" in out


def test_list_datasets_complete(capsys):

    list_datasets(with_description=True, filter_by="ibge")
    out, err = capsys.readouterr()  # Capture prints
    assert "dataset_id" in out
    assert "description" in out


def test_list_datasets_all_descriptions(capsys):

    list_datasets(with_description=True)
    out, err = capsys.readouterr()  # Capture prints
    assert len(out) > 0


def test_list_dataset_tables(capsys):

    list_dataset_tables(dataset_id="br_ibge_censo2010")
    out, err = capsys.readouterr()  # Capture prints
    assert "table_id" in out


def test_list_dataset_tables_complete(capsys):

    list_dataset_tables(
        dataset_id="br_ibge_censo2010",
        filter_by="renda",
        with_description=True,
    )
    out, err = capsys.readouterr()  # Capture prints
    assert "table_id" in out
    assert "description" in out
    assert "renda" in out


def test_list_dataset_tables_all_descriptions(capsys):
    list_dataset_tables(dataset_id="br_ibge_censo2010", with_description=True)
    out, err = capsys.readouterr()  # Capture prints
    assert len(out) > 0


def test_get_dataset_description(capsys):

    get_dataset_description("br_ibge_censo2010")
    out, err = capsys.readouterr()  # Capture prints
    assert len(out) > 0


def test_get_table_description(capsys):
    get_table_description("br_ibge_censo2010", "pessoa_renda_setor_censitario")
    out, err = capsys.readouterr()  # Capture prints
    assert len(out) > 0


def test_get_table_columns(capsys):
    get_table_columns(
        dataset_id="br_ibge_censo2010",
        table_id="pessoa_renda_setor_censitario",
    )
    out, err = capsys.readouterr()  # Capture prints
    assert "name" in out
    assert "field_type" in out
    assert "description" in out


def test_get_table_size(capsys):
    get_table_size(
        dataset_id="br_ibge_censo2010",
        table_id="pessoa_renda_setor_censitario",
        billing_project_id=TEST_PROJECT_ID,
    )
    out, err = capsys.readouterr()
    assert "num_rows" in out
    assert "size_mb" in out
