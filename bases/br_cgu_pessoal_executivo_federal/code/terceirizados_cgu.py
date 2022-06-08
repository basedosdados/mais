"""Esse script faz o download dos dados de pessoal terceirizado de órgãos do Poder Executivo Federal
incluindo autarquias e fundações públicas; e padroniza as colunas para o padrão da Base dos Dados.
"""
from io import BytesIO
import requests

import pandas as pd
from bs4 import BeautifulSoup
from tqdm import tqdm


BASE_URL = "https://www.gov.br/cgu/pt-br/acesso-a-informacao/dados-abertos/arquivos/terceirizados"

# Extrarir todas as urls de arquivos csv
html_page = requests.get(BASE_URL).content
urls = BeautifulSoup(html_page, "html.parser").find_all(
    "a", {"class": "internal-link"}, href=True
)
urls = [url["href"] for url in urls if url["href"].endswith("csv")]

# Baixar cada csv para memoria, ler no pandas e concatenar no DataFrame final
cols = [
    "id_terc",
    "sg_orgao_sup_tabela_ug",
    "cd_ug_gestora",
    "nm_ug_tabela_ug",
    "sg_ug_gestora",
    "nr_contrato",
    "nr_cnpj",
    "nm_razao_social",
    "nr_cpf",
    "nm_terceirizado",
    "nm_categoria_profissional",
    "nm_escolaridade",
    "nr_jornada",
    "nm_unidade_prestacao",
    "vl_mensal_salario",
    "vl_mensal_custo",
    "Num_Mes_Carga",
    "Mes_Carga",
    "Ano_Carga",
    "sg_orgao",
    "nm_orgao",
    "cd_orgao_siafi",
    "cd_orgao_siape",
]
df = pd.DataFrame(columns=cols)
for url in tqdm(urls):
    csv = requests.get(url)
    f = BytesIO()
    f.write(csv.content)
    f.seek(0)
    # Alguns csv's contem header embutido e outros não
    if "id_terc" in csv.text[:20]:
        df_url = pd.read_csv(f, sep=";", low_memory=False)
    else:
        df_url = pd.read_csv(f, sep=";", low_memory=False, names=cols, header=None)
    df = pd.concat([df, df_url], ignore_index=True)
    del df_url


# Renomeia colunas para padrão anterior (script R) e remove coluna não utilizada
new_cols_names = {
    "id_terc": "id_terceirizado",
    "sg_orgao_sup_tabela_ug": "sigla_orgao_superior_unidade_gestora",
    "cd_ug_gestora": "codigo_unidade_gestora",
    "nm_ug_tabela_ug": "unidade_gestora",
    "sg_ug_gestora": "sigla_unidade_gestora",
    "nr_contrato": "contrato_empresa",
    "nr_cnpj": "cnpj_empresa",
    "nm_razao_social": "razao_social_empresa",
    "nr_cpf": "cpf",
    "nm_terceirizado": "nome",
    "nm_categoria_profissional": "categoria_profissional",
    "nm_escolaridade": "nivel_escolaridade",
    "nr_jornada": "quantidade_horas_trabalhadas_semanais",
    "nm_unidade_prestacao": "unidade_trabalho",
    "vl_mensal_salario": "valor_mensal",
    "vl_mensal_custo": "custo_mensal",
    "Num_Mes_Carga": "mes",
    "Ano_Carga": "ano",
    "sg_orgao": "sigla_orgao_trabalho",
    "nm_orgao": "nome_orgao_trabalho",
    "cd_orgao_siafi": "codigo_siafi_trabalho",
    "cd_orgao_siape": "codigo_siape_trabalho",
}

df.drop(columns=["Mes_Carga"], inplace=True)
df.rename(columns=new_cols_names, inplace=True)

# Seleciona colunas na ordem selecionadas no script em R
selected_cols = [
    "ano",
    "mes",
    "id_terceirizado",
    "sigla_orgao_superior_unidade_gestora",
    "codigo_unidade_gestora",
    "unidade_gestora",
    "sigla_unidade_gestora",
    "contrato_empresa",
    "cnpj_empresa",
    "razao_social_empresa",
    "cpf",
    "nome",
    "categoria_profissional",
    "nivel_escolaridade",
    "quantidade_horas_trabalhadas_semanais",
    "unidade_trabalho",
    "valor_mensal",
    "custo_mensal",
    "sigla_orgao_trabalho",
    "nome_orgao_trabalho",
    "codigo_siafi_trabalho",
    "codigo_siape_trabalho",
]
df = df[selected_cols]

# Salva csv
df.to_csv("terceirizados.csv", encoding="utf-8", index=False)
