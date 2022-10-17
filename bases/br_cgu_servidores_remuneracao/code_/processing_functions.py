import csv

import pandas as pd

from settings import REMUNERACAO_MILITARES_COLUMNS, IN_DIR, OUT_DIR


def clean_observation_lines(df_career: pd.DataFrame) -> pd.DataFrame:
    """Remove lines that are observations."""
    for row in df_career.itertuples():
        if isinstance(row.ano, str) and row.ano.startswith("("):
            df_career.drop(row.Index, axis=0, inplace=True)
    return df_career


def get_career_df(career: str, kind: str) -> None:
    in_path = IN_DIR / f"{career.lower()}/{kind.lower()}"
    for file in in_path.iterdir():
        if file.suffix == ".csv":
            print(f"Reading {file.name}")
            yearmonth = file.name[:6]
            out_dir = OUT_DIR / f"microdados_{career}_{kind}" / f"ano={yearmonth[:4]}" / f"mes={yearmonth[4:]}"
            out_file = out_dir / f"microdados_{career}_{kind}.csv"
            if not out_file.exists():
                df_career = pd.read_csv(
                    file, sep=";", encoding="iso-8859-1", decimal=',', low_memory=False, dtype={"id_servidor": str}
                )
                df_career.columns = REMUNERACAO_MILITARES_COLUMNS
                df_career = clean_observation_lines(df_career)
                df_career["ano"] = pd.to_numeric(df_career["ano"], errors="ignore", downcast="integer")
                df_career["mes"] = pd.to_numeric(df_career["mes"], errors="ignore", downcast="integer")
                df_career["id_servidor_portal"] = pd.to_numeric(df_career["id_servidor_portal"], errors="ignore", downcast="integer")
                if not out_dir.exists():
                    out_dir.mkdir(parents=True)
                df_career.to_csv(
                    out_dir / f"microdados_{career}_{kind}.csv",
                    index=False,
                    sep=",",
                    encoding="utf-8",
                    na_rep="",  # empty string for NaN
                    quoting=csv.QUOTE_NONNUMERIC,
                    quotechar='"',
                )
    return None
