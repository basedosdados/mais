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

CREATE VIEW basedosdados-dev.br_bcb_agencia.agencia AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(data_inicio AS STRING) data_inicio,
SAFE_CAST(cnpj AS STRING) cnpj,
SAFE_CAST(nome_agencia AS STRING) nome_agencia,
SAFE_CAST(instituicao AS STRING) instituicao,
SAFE_CAST(segmento AS STRING) segmento,
SAFE_CAST(id_compe_bcb_agencia AS STRING) id_compe_bcb_agencia,
SAFE_CAST(id_compe_bcb_instituicao AS STRING) id_compe_bcb_instituicao,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(cep AS STRING) cep,
SAFE_CAST(endereco AS STRING) endereco,
SAFE_CAST(complemento AS STRING) complemento,
SAFE_CAST(bairro AS STRING) bairro,
SAFE_CAST(ddd AS STRING) ddd,
SAFE_CAST(fone AS STRING) fone,
SAFE_CAST(id_instalacao AS STRING) id_instalacao
FROM basedosdados-dev.br_bcb_agencia_staging.agencia AS t