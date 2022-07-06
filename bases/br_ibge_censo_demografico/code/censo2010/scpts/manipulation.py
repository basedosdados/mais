'''
Define function to normalize columns.
'''

# pylint: disable=invalid-name
def normalize_cols(df):
    '''
    Normaliza os valores de uma coluna.
    '''
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
