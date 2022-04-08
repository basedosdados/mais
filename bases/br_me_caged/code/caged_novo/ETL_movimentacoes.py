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

# deleta pasta
if os.path.isdir(CLEAN_PATH):
    shutil.rmtree(CLEAN_PATH)
if os.path.isdir(RAW_PATH):
    shutil.rmtree(RAW_PATH)

print("Get download links")
download_dict = caged_novo.get_download_links()
print("\n")

for tipo in list(download_dict.keys()):

    download_opt = caged_novo.get_filtered_download_dict(
        tipo=tipo, download_dict=download_dict, bucket_name="basedosdados-dev"
    )

    print(f"Filter download links {tipo}")

    trigger, download_opt = caged_novo.get_trigger_and_download_opt(download_opt, tipo)

    if trigger:
        for year_month_path in list(download_opt.keys()):
            print(tipo, ": ", year_month_path)
            ## download data
            save_path = RAW_PATH + f"{tipo}/" + year_month_path
            caged_novo.download_data(save_path, download_opt[year_month_path])
            
            #create some vars
            file_name = download_opt[year_month_path].split("/")[-1].split(".")[0]
            file_path = RAW_PATH + f"{tipo}/" + year_month_path
            
#             caged_novo.upload_to_raw(tipo=tipo, save_raw_path=f"{save_path}{file_name}.7z")


            # extrai arquivo
            caged_novo.extract_file(file_path, file_name, save_rows=None)

            # load e organiza os dados
            df = caged_novo.rename_add_orginaze_columns(file_path, file_name, tipo, municipios)

            # salva no formato de particao
            save_clean_path = CLEAN_PATH + f"{tipo}/"
            caged_novo.creat_partition(df, save_clean_path, year_month_path)

            # upload basedosdados
#             caged_novo.upload_to_bd(tipo, save_clean_path)

            # deleta pasta
#             shutil.rmtree(CLEAN_PATH + f"{tipo}/")
#             shutil.rmtree(RAW_PATH + f"{tipo}/")

    print("\n")

#CREATE TABLE AND FILL METADATA
tb = bd.Table(table_id = 'microdados_movimentacoes',dataset_id = 'br_me_caged')
st = bd.Storage('br_me_caged','microdados_movimentacoes',)
st.delete_table(bucket_name='basedosdados-dev')
tb.create(path='../data/caged_novo/clean/movimentacoes/',
          if_table_config_exists='pass',
          if_storage_data_exists='replace',
          if_table_exists='replace'
         )

tb.update_columns('https://docs.google.com/spreadsheets/d/1ihyOCSkaarmR3uMHj8bmP9tv-OChVeL2LkEWaGqxp7w/edit#gid=787251136')

tb.publish(if_exists='replace')