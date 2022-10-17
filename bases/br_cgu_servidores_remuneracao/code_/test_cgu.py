"""
Tests for the the functions.
"""

# pylint: disable=import-error, too-many-arguments

from unittest.mock import Mock

from code_.main import download_file

requests = Mock()


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
