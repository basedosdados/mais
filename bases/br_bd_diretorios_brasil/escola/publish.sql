/*
Query para publicar a tabela.

Esse é o lugar para:
    - modificar nomes, ordem e tipos de colunas
    - dar join com outras tabelas
    - criar colunas extras (e.g. logs, proporções, etc.)

Qualquer coluna definida aqui deve também existir em `table_config.yaml`.

# Além disso, sinta-se à vontade para alterar alguns nomes obscuros
# para algo um pouco mais explícito.

TIPOS:
    - Para modificar tipos de colunas, basta substituir STRING por outro tipo válido.
    - Exemplo: `SAFE_CAST(column_name AS NUMERIC) column_name`
    - Mais detalhes: https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types
*/

CREATE VIEW basedosdados-dev.br_bd_diretorios_brasil.escola AS
SELECT 
SAFE_CAST(id_escola AS STRING) id_escola,
SAFE_CAST(nome AS STRING) nome,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(restricao_atendimento AS STRING) restricao_atendimento,
SAFE_CAST(localizacao AS STRING) localizacao,
SAFE_CAST(localidade_diferenciada AS STRING) localidade_diferenciada,
SAFE_CAST(categoria_administrativa AS STRING) categoria_administrativa,
SAFE_CAST(endereco AS STRING) endereco,
SAFE_CAST(telefone AS STRING) telefone,
SAFE_CAST(dependencia_administrativa AS STRING) dependencia_administrativa,
SAFE_CAST(categoria_privada AS STRING) categoria_privada,
SAFE_CAST(conveniada_poder_publico AS STRING) conveniada_poder_publico,
SAFE_CAST(regulacao_conselho_educacao AS STRING) regulacao_conselho_educacao,
SAFE_CAST(porte AS STRING) porte,
SAFE_CAST(etapas_modalidades_oferecidas AS STRING) etapas_modalidades_oferecidas,
SAFE_CAST(outras_ofertas_educacionais AS STRING) outras_ofertas_educacionais,
SAFE_CAST(latitude AS STRING) latitude,
SAFE_CAST(longitude AS STRING) longitude
FROM basedosdados-dev.br_bd_diretorios_brasil_staging.escola AS t