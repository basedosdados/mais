import pytest
from pathlib import Path
import pandas as pd

from basedosdados import download, read_sql, read_table
from basedosdados.exceptions import BaseDosDadosException


TEST_PROJECT_ID = "basedosdados-test"
SAVEFILE = Path("tests/tmp_bases/test.csv")
SAVEPATH = Path("tests/tmp_bases/")


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

    assert (SAVEPATH / "query_result.csv").exists()


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