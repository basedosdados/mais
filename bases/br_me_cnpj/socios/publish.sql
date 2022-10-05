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

CREATE VIEW basedosdados-dev.br_me_cnpj.socios AS
SELECT 
SAFE_CAST(data AS DATE) data,
SAFE_CAST(cnpj_basico AS STRING) cnpj_basico,
SAFE_CAST(tipo AS STRING) tipo,
SAFE_CAST(nome AS STRING) nome,
SAFE_CAST(documento AS STRING) documento,
SAFE_CAST(qualificacao AS STRING) qualificacao,
SAFE_CAST(data_entrada_sociedade AS DATE) data_entrada_sociedade,
SAFE_CAST(id_pais AS STRING) id_pais,
SAFE_CAST(cpf_representante_legal AS STRING) cpf_representante_legal,
SAFE_CAST(nome_representante_legal AS STRING) nome_representante_legal,
SAFE_CAST(qualificacao_representante_legal AS STRING) qualificacao_representante_legal,
SAFE_CAST(faixa_etaria AS STRING) faixa_etaria
FROM basedosdados-dev.br_me_cnpj_staging.socios AS t