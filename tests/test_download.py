import pytest
from pathlib import Path
import pandas as pd

from src import download, read_sql, read_table


def test_download():

    savepath = Path("tests/tmp_bases/test.csv")

    download(
        savepath,
        query="select * from `basedosdados.pytest.pytest` limit 10",
    )

    assert savepath.exists()

    savepath = Path("tests/tmp_bases/")

    download(
        savepath,
        query="select * from `basedosdados.pytest.pytest` limit 10",
    )

    assert (savepath / "query_result.csv").exists()

    with pytest.raises(Exception):

        download()


def test_read_sql():

    assert isinstance(
        read_sql(
            query="select * from `basedosdados.pytest.pytest` limit 10",
        ),
        pd.DataFrame,
    )


def test_read_table():

    assert isinstance(
        read_table(dataset_id="pytest", table_id="pytest", limit=10),
        pd.DataFrame,
    )