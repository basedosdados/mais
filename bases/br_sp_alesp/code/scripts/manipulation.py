import pandas as pd
import numpy as np
import geopandas as gpd
import unicodedata


def normalize_cols(df):
    return (
        df.str.normalize("NFKD")
        .str.replace("$", "")
        .str.replace("(", "")
        .str.replace(")", "")
        .str.replace("-", "")
        .str.replace(" ", "_")
        .str.lower()
        .str.replace(".", "")
    )


def normalize(df, remove_words=0):

    dd = (
        df.str.normalize("NFKD")
        .str.encode("ascii", errors="ignore")
        .str.decode("utf-8")
        .str.upper()
        .str.strip()
    )

    if remove_words == 1:
        stop_words = [
            " DA",
            " DAS",
            " DAL",
            " DE",
            " DES",
            " DEL",
            " DI",
            " DIS",
            " DO",
            " DOS",
            " DU",
            " DUS",
        ]
        for word in stop_words:
            dd = dd.str.replace(word, "").str.strip()

    return dd


def remove_acentos(s):
    ss = "".join(
        c for c in unicodedata.normalize("NFD", s) if unicodedata.category(c) != "Mn"
    )

    return ss.lower().replace(" ", "_")
