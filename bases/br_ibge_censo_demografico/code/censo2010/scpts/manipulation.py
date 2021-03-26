import pandas as pd
import numpy as np


def normalize_cols(df):
    return (
        df.str.normalize("NFKD")
        .str.encode("ascii", errors="ignore")
        .str.decode("utf-8")
        .str.replace("$", "")
        .str.replace("(", "")
        .str.replace(")", "")
        .str.replace("-", "")
        .str.replace(" ", "_")
        .str.lower()
        .str.replace(".", "")
        .str.replace("/", "_")
    )
