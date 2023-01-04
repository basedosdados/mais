import pandas as pd
import csv
import requests
import os

header = [
    "id_divida",
    "vencimento_divida",
    "valor_estoque",
    "quantidade_estoque",
    "mes_ano",
    "classe_carteira",
    "tipo_divida"
]

csv_url = "https://www.tesourotransparente.gov.br/ckan/dataset/0998f610-bc25-4ce3-b32c-a873447500c2/resource/b6280ed3-ef7e-4569-954a-bded97c2c8a1/download/EstoqueDPF.csv"

with requests.Session() as s:
    download = s.get(csv_url)

    decoded_content = download.content.decode('utf-8')

    reader = csv.reader(decoded_content.splitlines(), delimiter=';')

    data = []

    for row in reader:
        data.append(row)

with open("input/br_testouro_estoque_divida_publica_original.csv", "w") as file:
  writer = csv.writer(file)
  writer.writerow(data)

df = pd.DataFrame(data, columns=header)

df = df.drop(0)

df["valor_estoque"] = df["valor_estoque"].replace(",", ".", regex=True)
df["quantidade_estoque"] = df["quantidade_estoque"].replace(",", ".", regex=True)
df["vencimento_divida"] = pd.to_datetime(df.vencimento_divida, dayfirst=True)
df["ano"] = pd.DatetimeIndex(df["mes_ano"]).year
df["mes"] = pd.DatetimeIndex(df["mes_ano"]).month
df.drop("mes_ano", inplace=True, axis=1)
df.insert(0, 'ano', df.pop('ano'))
df.insert(1, 'mes', df.pop('mes'))
df["tipo_divida"] = df["tipo_divida"].str.capitalize()
df = df[["id_divida","vencimento_divida","tipo_divida","classe_carteira","valor_estoque","quantidade_estoque","ano","mes"]]
df["quantidade_estoque"] = df["quantidade_estoque"].astype(float)
df["quantidade_estoque"] = df["quantidade_estoque"].astype(int)

for ano in [*range(2017, 2023)]:
  for mes in [*range(1, 13)]:
    particao = f'output/ano={ano}/mes={mes}'
    if not os.path.exists(particao):
      os.makedirs(particao)

for ano in [*range(2017, 2023)]:
  for mes in [*range(1, 13)]:
    df_particao = df[df['ano'] == ano].copy() 
    df_particao = df_particao[df_particao['mes'] == mes]
    df_particao.drop(['ano', 'mes'], axis=1, inplace=True) 
    particao = f'output/ano={ano}/mes={mes}/br_me_estoque_divida_publica_{ano}_{mes}.csv'
    df_particao.to_csv(particao, index=False, encoding='utf-8', na_rep='')