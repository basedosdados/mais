"""
Tests for the the functions.
"""

# pylint: disable=import-error, too-many-arguments

from unittest.mock import Mock

import pandas as pd
import pytest

from main import download_file
from processing_functions import clean_observation_lines

requests = Mock()


@pytest.fixture
def df_test():
    dff = pd.DataFrame(
        [["2016", "02", "blabla"], ["2016", "02", "bleble"], ["(*) xxxxx", 2, "blibli"]],
        columns=["ano", "mes", "nome"]
    )
    return dff


def test_clean_observations(df_test):
    """
    Test if the function clean_observations is working.
    :return: None
    """
    assert clean_observation_lines(df_test).shape == (2, 3)


def test_download_file_does_not_exists():
    """
    Test if the file does not exists.
    :return: Error present in reaults
    """
    requests.return_value = "Arquivo inexistente"
    res = download_file("2013", "01", "militares", "ativos")
    assert "Arquivos baixados:" in res


# @pytest.mark.skip()
# def test_unzip():
#     file = unzip_file("2013", "01")
#     assert isinstance(file, Path)


# def test_unzip_salary_file():
#     filepath = "path/to/file/202201_Qualquer_coisa_aqui.zip"
#     name = unzip_salary_file(Path(filepath))
#     print(name)
