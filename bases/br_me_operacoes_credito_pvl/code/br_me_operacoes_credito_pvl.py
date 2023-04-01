import pandas as pd
import csv
import requests
import os

header = [
    "interessado",
    "sigla_uf",
    "tipo_interessado",
    "tipo_operacao",
    "finalidade_operacao",
    "tipo_credor",
    "credor",
    "moeda",
    "valor_operacao",
    "id_pvl",
    "id_municipio",
    "status",
    "data",
    "instituicao_responsavel"
]

csv_url = "https://www.tesourotransparente.gov.br/ckan/dataset/25a770df-920e-4519-a172-65b84b14e643/resource/c9cbf4d5-8c68-4fa6-9224-afc34c006d11/download/SADIPEMCONSULTAPUBLICAGERALBATCH09032023.csv"

with requests.Session() as s:
    download = s.get(csv_url)

    decoded_content = download.content.decode('latin-1')

    reader = csv.reader(decoded_content.splitlines(), delimiter=';')

    data = []

    for row in reader:
        data.append(row)

with open("input/br_me_operacoes_credito_pvl.csv", "w") as file:
  writer = csv.writer(file)
  writer.writerows(data)

df = pd.DataFrame(data, columns=header)
df = df.drop(0)

df["tipo_interessado"] = df["tipo_interessado"].str.lower().str.capitalize()
df["tipo_operacao"] = df["tipo_operacao"].str.lower().str.capitalize()
df["tipo_credor"] = df["tipo_credor"].str.lower().str.capitalize()
df["credor"] = df["credor"].str.lower().str.capitalize()
df["valor_operacao"] = df["valor_operacao"].replace(".", "", regex=True)
df["valor_operacao"] = df["valor_operacao"].replace(",", ".", regex=True)
df["data"] = pd.to_datetime(df["data"], format = "%d/%m/%Y")
df["ano"] = pd.DatetimeIndex(df["data"]).year
df["mes"] = pd.DatetimeIndex(df["data"]).month
df['id_estado'] = df['id_municipio'].str.extract(r'(\d{2})', expand=False)
df['id_municipio'] = df['id_municipio'].str.extract(r'(\d{7})', expand=False)

df = df[["ano", "mes", "data", "sigla_uf", "id_municipio", "id_estado", "id_pvl", "status", "instituicao_responsavel", "tipo_interessado", "interessado", "tipo_operacao", "tipo_credor", "credor", "moeda", "valor_operacao"]]

df.to_csv(f"output/br_me_operacoes_credito_pvl.csv", index=False, encoding='utf-8', na_rep='')