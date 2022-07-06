'''
Cleaning data from ALESP
'''
# pylint: disable=invalid-name
import unicodedata


def normalize_cols(df):
    '''
    Normalize columns
    '''
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
    '''
    Normalize dataframe
    '''

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
    '''
    Remove non ascii characters
    '''
    ss = "".join(
        c for c in unicodedata.normalize("NFD", s) if unicodedata.category(c) != "Mn"
    )

    return ss.lower().replace(" ", "_")
