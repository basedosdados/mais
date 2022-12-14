""" Utilities functions for Upload sub-module"""
# pylint: disable=invalid-name,too-many-arguments,too-many-locals,too-many-branches,too-many-statements, protected-access,line-too-long
from typing import List
from pathlib import Path
import os

import ruamel.yaml as ryaml
import pandas as pd

import basedosdados as bd
from basedosdados.exceptions import BaseDosDadosException


def update_columns(table_obj: bd.Table, columns_config_url_or_path=None):
    """
    Fills columns in table_config.yaml automatically using a public google sheets URL or a local file. Also regenerate
    publish.sql and autofill type using bigquery_type.
    The sheet must contain the columns:
        - name: column name
        - description: column description
        - bigquery_type: column bigquery type
        - measurement_unit: column mesurement unit
        - covered_by_dictionary: column related dictionary
        - directory_column: column related directory in the format <dataset_id>.<table_id>:<column_name>
        - temporal_coverage: column temporal coverage
        - has_sensitive_data: the column has sensitive data
        - observations: column observations
    Args:
        columns_config_url_or_path (str): Path to the local architeture file or a public google sheets URL.
            Path only suports csv, xls, xlsx, xlsm, xlsb, odf, ods, odt formats.
            Google sheets URL must be in the format https://docs.google.com/spreadsheets/d/<table_key>/edit#gid=<table_gid>.
    """
    ruamel = ryaml.YAML()
    ruamel.preserve_quotes = True
    ruamel.indent(mapping=4, sequence=6, offset=4)
    table_config_yaml = ruamel.load(
        (table_obj.table_folder / "table_config.yaml").open(encoding="utf-8")
    )

    if "https://docs.google.com/spreadsheets/d/" in columns_config_url_or_path:
        if (
            "edit#gid=" not in columns_config_url_or_path
            or "https://docs.google.com/spreadsheets/d/"
            not in columns_config_url_or_path
            or not columns_config_url_or_path.split("=")[1].isdigit()
        ):
            raise BaseDosDadosException(
                "The Google sheet url not in correct format."
                "The url must be in the format https://docs.google.com/spreadsheets/d/<table_key>/edit#gid=<table_gid>"
            )
        df = table_obj._sheet_to_df(columns_config_url_or_path)
    else:
        file_type = columns_config_url_or_path.split(".")[-1]
        if file_type == "csv":
            df = pd.read_csv(columns_config_url_or_path, encoding="utf-8")
        elif file_type in ["xls", "xlsx", "xlsm", "xlsb", "odf", "ods", "odt"]:
            df = pd.read_excel(columns_config_url_or_path)
        else:
            raise BaseDosDadosException(
                "File not suported. Only csv, xls, xlsx, xlsm, xlsb, odf, ods, odt are supported."
            )

    df = df.fillna("NULL")

    required_columns = [
        "name",
        "bigquery_type",
        "description",
        "temporal_coverage",
        "covered_by_dictionary",
        "directory_column",
        "measurement_unit",
        "has_sensitive_data",
        "observations",
    ]

    not_found_columns = required_columns.copy()
    for sheet_column in df.columns.tolist():
        for required_column in required_columns:
            if sheet_column == required_column:
                not_found_columns.remove(required_column)
    if not_found_columns:
        raise BaseDosDadosException(
            f"The following required columns are not found: {', '.join(not_found_columns)}."
        )

    columns_parameters = zip(
        *[df[required_column].tolist() for required_column in required_columns]
    )
    for (
        name,
        bigquery_type,
        description,
        temporal_coverage,
        covered_by_dictionary,
        directory_column,
        measurement_unit,
        has_sensitive_data,
        observations,
    ) in columns_parameters:
        for col in table_config_yaml["columns"]:
            if col["name"] == name:
                col["bigquery_type"] = (
                    col["bigquery_type"]
                    if bigquery_type == "NULL"
                    else bigquery_type.lower()
                )

                col["description"] = (
                    col["description"] if description == "NULL" else description
                )

                col["temporal_coverage"] = (
                    col["temporal_coverage"]
                    if temporal_coverage == "NULL"
                    else [temporal_coverage]
                )

                col["covered_by_dictionary"] = (
                    "no" if covered_by_dictionary == "NULL" else covered_by_dictionary
                )

                dataset = directory_column.split(".")[0]
                col["directory_column"]["dataset_id"] = (
                    col["directory_column"]["dataset_id"]
                    if dataset == "NULL"
                    else dataset
                )

                table = directory_column.split(".")[-1].split(":")[0]
                col["directory_column"]["table_id"] = (
                    col["directory_column"]["table_id"] if table == "NULL" else table
                )

                column = directory_column.split(".")[-1].split(":")[-1]
                col["directory_column"]["column_name"] = (
                    col["directory_column"]["column_name"]
                    if column == "NULL"
                    else column
                )
                col["measurement_unit"] = (
                    col["measurement_unit"]
                    if measurement_unit == "NULL"
                    else measurement_unit
                )

                col["has_sensitive_data"] = (
                    "no" if has_sensitive_data == "NULL" else has_sensitive_data
                )

                col["observations"] = (
                    col["observations"] if observations == "NULL" else observations
                )

    with open(table_obj.table_folder / "table_config.yaml", "w", encoding="utf-8") as f:
        ruamel.dump(table_config_yaml, f)

    # regenerate publish.sql
    table_obj._make_publish_sql()


def to_partitions(data: pd.DataFrame, partition_columns: List[str], savepath: str):
    """Save data in to hive patitions schema, given a dataframe and a list of partition columns.
    Args:
        data (pandas.core.frame.DataFrame): Dataframe to be partitioned.
        partition_columns (list): List of columns to be used as partitions.
        savepath (str, pathlib.PosixPath): folder path to save the partitions
    Exemple:
        data = {
            "ano": [2020, 2021, 2020, 2021, 2020, 2021, 2021,2025],
            "mes": [1, 2, 3, 4, 5, 6, 6,9],
            "sigla_uf": ["SP", "SP", "RJ", "RJ", "PR", "PR", "PR","PR"],
            "dado": ["a", "b", "c", "d", "e", "f", "g",'h'],
        }
        to_partitions(
            data=pd.DataFrame(data),
            partition_columns=['ano','mes','sigla_uf'],
            savepath='partitions/'
        )
    """

    if isinstance(data, (pd.core.frame.DataFrame)):

        savepath = Path(savepath)

        # create unique combinations between partition columns
        unique_combinations = (
            data[partition_columns]
            .drop_duplicates(subset=partition_columns)
            .to_dict(orient="records")
        )

        for filter_combination in unique_combinations:
            patitions_values = [
                f"{partition}={value}"
                for partition, value in filter_combination.items()
            ]

            # get filtered data
            df_filter = data.loc[
                data[filter_combination.keys()]
                .isin(filter_combination.values())
                .all(axis=1),
                :,
            ]
            df_filter = df_filter.drop(columns=partition_columns)

            # create folder tree
            filter_save_path = Path(savepath / "/".join(patitions_values))
            filter_save_path.mkdir(parents=True, exist_ok=True)
            file_filter_save_path = Path(filter_save_path) / "data.csv"

            # append data to csv
            df_filter.to_csv(
                file_filter_save_path,
                index=False,
                mode="a",
                header=not file_filter_save_path.exists(),
            )
    else:
        raise BaseException("Data need to be a pandas DataFrame")


def break_file(filepath: str, columns: list, chunksize: int = 1000000) -> None:
    """
    Break a file into smaller files, given a list of columns to be used as a key.
    Args:
        filepath (str, pathlib.PosixPath): file path to be broken.
        columns (list): list of columns to be used as a key.
        chunksize (int): number of rows to be read at a time.
    Returns:
        None
    """
    reader = pd.read_csv(filepath, chunksize=chunksize, usecols=columns)
    for i, chunk in enumerate(reader):
        folder = os.path.dirname(filepath)
        filename = os.path.basename(filepath)
        subfolder = os.path.join(folder, filename.split(".")[0])
        # create subfolder
        if not os.path.exists(subfolder):
            os.makedirs(subfolder)
        # save chunk
        chunk.to_csv(
            os.path.join(subfolder, f'{filename.split(".")[0]}_{i}.csv'), index=False
        )
