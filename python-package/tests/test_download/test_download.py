from os import read
import pytest
from pathlib import Path
import pandas as pd
from pandas_gbq.gbq import GenericGBQException
import shutil
from pydata_google_auth.exceptions import PyDataCredentialsError

from basedosdados import (
    reauth,
    download,
    read_sql,
    read_table,
)
from basedosdados.exceptions import (
    BaseDosDadosException,
    BaseDosDadosNoBillingProjectIDException,
    BaseDosDadosInvalidProjectIDException,
)


TEST_PROJECT_ID = "basedosdados-dev"
SAVEFILE = Path(__file__).parent.parent / "tmp_bases" / "test.csv"
SAVEPATH = Path(__file__).parent.parent / "tmp_bases"
shutil.rmtree(SAVEPATH, ignore_errors=True)


def test_download_by_query():

    download(
        SAVEFILE,
        query="select * from `basedosdados.br_ibge_pib.municipio` limit 10",
        billing_project_id=TEST_PROJECT_ID,
        from_file=True,
    )

    assert SAVEFILE.exists()


def test_download_by_table():

    download(
        SAVEFILE,
        dataset_id="br_ibge_pib",
        table_id="municipio",
        billing_project_id=TEST_PROJECT_ID,
        limit=10,
        from_file=True,
    )

    assert SAVEFILE.exists()


def test_download_large_file():

    download(
        SAVEFILE,
        query="select * from basedosdados.br_me_rais.microdados_vinculos limit 10000000",
        billing_project_id=TEST_PROJECT_ID,
        from_file=True,
    )

    assert (SAVEFILE).exists()


def test_download_no_query_or_table():

    with pytest.raises(BaseDosDadosException):
        download(
            SAVEFILE,
            limit=10,
        )


def test_read_sql():

    assert isinstance(
        read_sql(
            query="select * from `basedosdados.br_ibge_pib.municipio` limit 10",
            billing_project_id=TEST_PROJECT_ID,
            from_file=True,
        ),
        pd.DataFrame,
    )


def test_read_sql_no_billing_project_id():

    with pytest.raises(BaseDosDadosNoBillingProjectIDException) as excinfo:
        read_sql(
            query="select * from `basedosdados.br_ibge_pib.municipio` limit 10",
        )

    assert "We are not sure which Google Cloud project should be billed." in str(
        excinfo.value
    )


def test_read_sql_invalid_billing_project_id():

    pattern = r"You are using an invalid `billing_project_id`"

    with pytest.raises(BaseDosDadosInvalidProjectIDException, match=pattern):
        read_sql(
            query="select * from `basedosdados.br_ibge_pib.municipio` limit 10",
            billing_project_id="inexistent_project_id",
            from_file=True,
        )


def test_read_sql_inexistent_project():

    with pytest.raises(GenericGBQException) as excinfo:
        read_sql(
            query="select * from `asedosdados.br_ibge_pib.municipio` limit 10",
            billing_project_id=TEST_PROJECT_ID,
            from_file=True,
        )

    assert "Reason: 404 Not found: Project" in str(excinfo.value)


def test_read_sql_inexistent_dataset():

    with pytest.raises(GenericGBQException) as excinfo:
        read_sql(
            query="select * from `basedosdados-dev.br_ibge_inexistent.municipio` limit 10",
            billing_project_id=TEST_PROJECT_ID,
            from_file=True,
        )

    assert "Reason: 404 Not found: Dataset" in str(excinfo.value)


def test_read_sql_inexistent_table():

    with pytest.raises(GenericGBQException) as excinfo:
        read_sql(
            query="select * from `basedosdados.br_ibge_pib.inexistent` limit 10",
            billing_project_id=TEST_PROJECT_ID,
            from_file=True,
        )

    assert "Reason: 404 Not found: Table" in str(excinfo.value)


def test_read_sql_syntax_error():

    with pytest.raises(GenericGBQException) as excinfo:
        read_sql(
            query="invalid_statement * from `basedosdados.br_ibge_pib.municipio` limit 10",
            billing_project_id=TEST_PROJECT_ID,
            from_file=True,
        )

    assert "Reason: 400 Syntax error" in str(excinfo.value)


def test_read_sql_out_of_bound_date():

    read_sql(
        query="select DATE('1000-01-01')",
        billing_project_id=TEST_PROJECT_ID,
        from_file=True,
    )


def test_read_table():

    assert isinstance(
        read_table(
            dataset_id="br_ibge_pib",
            table_id="municipio",
            billing_project_id=TEST_PROJECT_ID,
            from_file=True,
            limit=10,
        ),
        pd.DataFrame,
    )


def test_reauth(monkeypatch):

    with pytest.raises(PyDataCredentialsError):

        monkeypatch.setattr("builtins.input", lambda _: "Error")

        reauth()
