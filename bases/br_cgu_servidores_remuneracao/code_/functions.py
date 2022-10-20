"""
Utilities functions to download and unzip files from CGU
"""

import zipfile
from pathlib import Path
from typing import Optional

from settings import CGU_FILES, IN_DIR, TMP_DIR  # pylint: disable=import-error


# pylint: disable=too-many-arguments


def zipped_file_name(
    year: str, month: str, career: str = "Militares", kind: Optional[str] = None
) -> str:
    """
    Returns the name of the zipped file to download.
    :param year: year to download
    :param month: month to download
    :param career: the career of the employee (milirares or civis)
    :param kind: the situation of the employee (ativos or inativos)
    :return:
    """
    if not kind:
        return f"{year}{month}_{CGU_FILES[career]}.zip"

    return f"{year}{month}_{CGU_FILES[career][kind]}.zip"


def unzip_salary_file(
    filepath: Path,
    year: str,
    month: str,
    career: str,
    kind: str = None,
) -> str:
    """
    Unzip the file and returns the name of the unzipped file.
    :param filepath: the path of the file to unzip
    :param year: year to download
    :param month: month to download
    :param career: career of the employee (milirares or civis)
    :param kind: situation of the employee (ativos or inativos)
    :return: the name of file to unzip
    """
    division = str(filepath).rsplit("_", maxsplit=1)[-1]
    division = division.split(".")[0].lower()
    if division not in ["bacen", "siape"]:
        division = None
    else:
        division = f"_{division}"

    file_to_unzip = f"{year}{month}_Remuneracao.csv"
    path_to_unzip = IN_DIR / career.lower() / kind.lower()
    filename_to_unzip = f"{year}{month}_Remuneracao{division}.csv"

    with zipfile.ZipFile(filepath) as zip_file:
        zip_file.extract(
            file_to_unzip,
            path=path_to_unzip,
        )

        if division:
            (path_to_unzip / file_to_unzip).rename(path_to_unzip / filename_to_unzip)
            return filename_to_unzip

    return file_to_unzip


def save_file(filename: str, content: bytes) -> Path:
    """
    Save the file in the input folder.
    :param filename: the name of the file to save
    :param content: content of the file to save
    :return: tha path of the file to be saved
    """
    with open(TMP_DIR / filename, "wb") as fname:
        fname.write(content)

    return TMP_DIR / filename


def file_exists(
    year: str, month: str, career: str, kind: str = None, division: str = None
) -> bool:
    """
    Check if the file exists in the input folder.
    :param year: year of the file to check
    :param month: month of the file to check
    :param career: career of the employee (milirares or civis)
    :param kind: situation of the employee (ativos or inativos)
    :param division: division of the civilians (BACEN or SIAPE)
    :return: if the file exists or not
    """
    print("Checking if file exists...\n")
    file_to_check = IN_DIR / career.lower() / kind.lower()
    if division:
        file_to_check = file_to_check / f"{year}{month}_Remuneracao_{division.lower()}.csv"
    else:
        file_to_check = file_to_check / f"{year}{month}_Remuneracao.csv"
    return file_to_check.exists()
