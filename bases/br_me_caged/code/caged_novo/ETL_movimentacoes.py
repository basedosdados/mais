import pandas as pd
import numpy as np
import os
from datetime import datetime

pd.options.display.max_columns = 999
pd.options.display.max_rows = 1999
pd.options.display.max_colwidth = 200


from scpts import manipulation
import caged_novo

from basedosdados import Storage, Table, Dataset
import basedosdados as bd

import glob
import shutil

#DOWNLOADS SOURCE LINK
download_dict = caged_novo.get_download_links()

today = datetime.strftime(datetime.today(), "%Y-%m-%d")

RAW_PATH = "../data/caged_novo/raw/"
CLEAN_PATH = "../data/caged_novo/clean/"

def get_municipios():
    # GET MUNICIPIOS FROM BD
    print("====== ", today, " ======")
    query = """
    SELECT 
        sigla_uf,
        id_municipio,
        id_municipio_6
    FROM `basedosdados.br_bd_diretorios_brasil.municipio` 
    """

    municipios = bd.read_sql(query, billing_project_id="basedosdados-dev")
    print("\n")
    return municipios

# deleta pasta
if os.path.isdir(CLEAN_PATH):
    shutil.rmtree(CLEAN_PATH)
if os.path.isdir(RAW_PATH):
    shutil.rmtree(RAW_PATH)

print("Get download links")
download_dict = caged_novo.get_download_links()
tb = bd.Table(dataset_id="br_me_caged", table_id=f"microdados_movimentacoes")
st = bd.Storage(table_id="microdados_movimentacoes", dataset_id="br_me_caged")

def teste():
    if download_dict != {}:
        for year_month_path in list(download_dict.keys()):

            save_path = RAW_PATH + "movimentacoes/" + str(year_month_path)
            caged_novo.download_data(save_path, download_dict[year_month_path])
            
            file_name = download_dict[year_month_path].split("/")[-1].split(".")[0]
            file_path = RAW_PATH + "movimentacoes" + str(year_month_path)
             
            caged_novo.extract_file(file_path, file_name, save_rows=None)

            municipios = get_municipios
            df = caged_novo.rename_add_orginaze_columns(file_path, file_name, municipios)

            save_clean_path = CLEAN_PATH + "movimentacoes/"
            caged_novo.creat_partition(df, save_clean_path, year_month_path)


teste()
#CREATE TABLE AND FILL METADATA
print('IM HERE')
tb = bd.Table(table_id = 'microdados_movimentacoes', dataset_id = 'br_me_caged')
print('IM HERE')
st = bd.Storage('br_me_caged','microdados_movimentacoes')
print('IM HERE')
#st.delete_table(bucket_name='basedosdados-dev')
tb.create(path='../data/caged_novo/clean/movimentacoes/',
          if_table_config_exists='pass',
          if_storage_data_exists='replace',
          if_table_exists='replace'
         )
print('IM HERE')
tb.update_columns('https://docs.google.com/spreadsheets/d/1ihyOCSkaarmR3uMHj8bmP9tv-OChVeL2LkEWaGqxp7w/edit#gid=787251136')

tb.publish(if_exists='replace')