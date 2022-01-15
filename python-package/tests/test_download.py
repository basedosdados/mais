from os import read
import pytest
from pathlib import Path
import pandas as pd
from pandas_gbq.gbq import GenericGBQException
import shutil
from basedosdados.download.download import search

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
from basedosdados.exceptions import (
    BaseDosDadosException,
    BaseDosDadosNoBillingProjectIDException,
    BaseDosDadosInvalidProjectIDException,
)


TEST_PROJECT_ID = "basedosdados-dev"
SAVEFILE = Path(__file__).parent / "tmp_bases" / "test.csv"
SAVEPATH = Path(__file__).parent / "tmp_bases"
shutil.rmtree(SAVEPATH, ignore_errors=True)


def test_download_by_query():

    download(
        SAVEFILE,
        query="select * from `basedosdados.br_ibge_pib.municipio` limit 10",
        billing_project_id=TEST_PROJECT_ID,
        index=False,
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
        index=False,
    )

    assert SAVEFILE.exists()


def test_download_save_to_path():

    download(
        SAVEPATH,
        dataset_id="br_ibge_pib",
        table_id="municipio",
        billing_project_id=TEST_PROJECT_ID,
        from_file=True,
        limit=10,
        index=False,
    )

    assert (SAVEPATH / "municipio.csv").exists()


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
        table_id="municipio",
        billing_project_id=TEST_PROJECT_ID,
        from_file=True,
        limit=10,
        sep="|",
        index=False,
    )

    assert SAVEFILE.exists()


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


def test_list_datasets_default(capsys):

    out = list_datasets(
        query="trabalho", limit=10, with_description=False, verbose=True
    )
    out, err = capsys.readouterr()  # Capture prints
    assert "dataset_id" in out
    # check input error
    with pytest.raises(ValueError):
        search(query="trabalho", order_by="name")


def test_list_datasets_noverbose():

    out = list_datasets(
        query="", limit=12, with_description=False, verbose=False
    )
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

    list_datasets(
        query="trabalho", limit=10, with_description=True, verbose=True
    )
    out, err = capsys.readouterr()  # Capture prints
    assert "dataset_id" in out
    assert "description" in out


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

def test_search():
    out = search(
        query='agua', 
        order_by='score'
    )
    #check if function returns pd.DataFrame
    assert isinstance(out, pd.DataFrame)
    #check if there is duplicate tables in the result
    assert out.id.nunique()==out.shape[0]
    #check input error
    with pytest.raises(ValueError):
        search(
        query='agua', 
        order_by='name'
    )
        
