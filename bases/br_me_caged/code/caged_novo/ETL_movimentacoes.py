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

for year_month in list(download_dict.keys()):
    
    year = year_month[0:4]
    save_path = "/media/isadorabugarin/Data/BasesdosDados/downloads/"
    
    caged_novo.download_data(save_path, f'{download_dict[year_month]}')
      
    file_name = download_dict[year_month].split("/")[-1].split(".")[0]
    file_path = "/media/isadorabugarin/Data/BasesdosDados/downloads/"
             
    caged_novo.extract_file(file_path, file_name, save_rows=None)

    municipios = get_municipios()
    df = caged_novo.rename_add_orginaze_columns(file_path, file_name, municipios)

    save_clean_path = "/media/isadorabugarin/Data/BasesdosDados/downloads/"
    caged_novo.creat_partition(df, save_clean_path, year_month)

#CREATE TABLE AND FILL METADATA

tb = bd.Table(table_id = 'microdados_movimentacoes', dataset_id = 'br_me_caged')
st = bd.Storage('br_me_caged','microdados_movimentacoes')

st.delete_table(bucket_name='basedosdados-dev')
tb.create(path='../data/caged_novo/clean/movimentacoes/',
          if_table_config_exists='pass',
          if_storage_data_exists='replace',
          if_table_exists='replace'
         )
print('IM HERE')
tb.update_columns('https://docs.google.com/spreadsheets/d/1ihyOCSkaarmR3uMHj8bmP9tv-OChVeL2LkEWaGqxp7w/edit#gid=787251136')

tb.publish(if_exists='replace')