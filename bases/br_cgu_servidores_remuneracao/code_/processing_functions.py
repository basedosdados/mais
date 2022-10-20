"""
Module for processing the raw data from CGU files.
"""

import csv

import pandas as pd

from settings import IN_DIR, OUT_DIR, REMUNERACAO_COLUMNS  # pylint: disable=import-error

# pylint: disable=useless-return


def clean_observation_lines(df_career: pd.DataFrame) -> pd.DataFrame:
    """Remove lines that are observations."""
    for row in df_career.itertuples():
        if isinstance(row.ano, str) and row.ano.startswith("("):
            df_career.drop(row.Index, axis=0, inplace=True)
    return df_career


def get_career_df(career: str, kind: str) -> None:
    """Get the dataframe of the career."""
    in_path = IN_DIR / f"{career.lower()}/{kind.lower()}"
    print("Processing ", in_path)
    if in_path.is_dir():
        for file in in_path.iterdir():
            if file.suffix == ".csv":
                print(f"Reading {file.name}")
                yearmonth = file.name[:6]
                division = file.name.split("_")[-1].split(".")[0].lower()
                if division not in ["bacen", "siape"]:
                    division = None
                out_dir = (
                    OUT_DIR
                    / f"microdados_{career}_{kind}"
                    / f"ano={yearmonth[:4]}"
                    / f"mes={yearmonth[4:]}"
                )
                out_file = out_dir / f"microdados_{career}_{kind}.csv"

                df_career = pd.read_csv(
                    file,
                    sep=";",
                    encoding="iso-8859-1",
                    decimal=",",
                    low_memory=False,
                    dtype={"id_servidor": str},
                )
                df_career.columns = REMUNERACAO_COLUMNS
                df_career = clean_observation_lines(df_career)
                # df_career["ano"] = pd.to_numeric(df_career["ano"], errors="ignore", downcast="integer")
                # df_career["mes"] = pd.to_numeric(df_career["mes"], errors="ignore", downcast="integer")
                df_career.drop(columns=["ano", "mes"], inplace=True)
                df_career["id_servidor_portal"] = pd.to_numeric(
                    df_career["id_servidor_portal"], errors="ignore", downcast="integer"
                )
                if division:
                    df_career["origem"] = division

                if not out_dir.exists():
                    out_dir.mkdir(parents=True)

                if out_file.exists():
                    df = pd.read_csv(out_file, sep=",", encoding="utf-8")  # pylint: disable=invalid-name
                    df_career = pd.concat([df, df_career], ignore_index=True)
                    del df

                df_career.to_csv(
                    out_file,
                    index=False,
                    sep=",",
                    encoding="utf-8",
                    na_rep="",  # empty string for NaN
                    quoting=csv.QUOTE_NONNUMERIC,
                    quotechar='"',
                )
                del df_career

    return None
