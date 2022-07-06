"""
Code to download data from the Brazilian SP-SAO Paulo DIEESE ICV
"""
# pylint: disable=invalid-name, redefined-outer-name
# ------------------------------------------------------------------------------#
# setup
# ------------------------------------------------------------------------------#

import pandas as pd
import ipeadatapy as idpy
import basedosdados as bd

# ------------------------------------------------------------------------------#
# path
# ------------------------------------------------------------------------------#

path_dados = "/Bases/br_sp_saopaulo_dieese_icv/"
path_output = path_dados + "output/"

# ------------------------------------------------------------------------------#
# listas
# ------------------------------------------------------------------------------#

codes = ["DIEESE12_ICVSPD12", "DIEESE12_ICVSPDG12", "DIEESE_ICVSPDG"]
drop_m = ["DATE", "DAY", "CODE", "RAW DATE"]
drop_a = ["DATE", "DAY", "CODE", "MONTH", "RAW DATE"]

rename_m = {
    "YEAR": "ano",
    "MONTH": "mes",
    "VALUE (-)": "indice",
    "VALUE ((% a.m.))": "variacao_mensal",
}

rename_a = {"YEAR": "ano", "MONTH": "mes", "VALUE ((% a.a.))": "variacao_anual"}

# ------------------------------------------------------------------------------#
# output
# ------------------------------------------------------------------------------#


def icv(filepath, drop_m, rename_m):
    """
    Build dataframe from ICV file
    """
    df = idpy.timeseries(filepath).reset_index()
    df.drop(drop_m, axis=1, inplace=True)
    df.rename(columns=rename_m, inplace=True)

    return df


indice = icv(codes[0], drop_m, rename_m)
variacao_mensal = icv(codes[1], drop_m, rename_m)
variacao_anual = icv(codes[2], drop_a, rename_a)

icv_mes = pd.merge(
    indice, variacao_mensal, how="left", left_on=["ano", "mes"], right_on=["ano", "mes"]
)

icv_mes.to_csv(path_output + "mes/mes.csv", index=False, encoding="utf-8", na_rep="")
variacao_anual.to_csv(
    path_output + "ano/ano.csv", index=False, encoding="utf-8", na_rep=""
)
print(icv_mes.head())
print(variacao_anual.head())
# ------------------------------------------------------------------------------#
# Bigquery
# ------------------------------------------------------------------------------#

table_ids = ["ano", "mes"]


for table_id in table_ids:
    tb = bd.Table(dataset_id="br_sp_saopaulo_dieese_icv", table_id=table_id)
    tb.create(
        path=path_dados + "output/{}".format(table_id),
        if_storage_data_exists="replace",
        if_table_config_exists="replace",
        if_table_exists="replace",
    )
