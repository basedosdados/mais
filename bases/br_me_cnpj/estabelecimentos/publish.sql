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

CREATE VIEW basedosdados-dev.br_me_cnpj.estabelecimentos AS
SELECT 
SAFE_CAST(data AS DATE) data,
SAFE_CAST(cnpj AS STRING) cnpj,
SAFE_CAST(cnpj_basico AS STRING) cnpj_basico,
SAFE_CAST(cnpj_ordem AS STRING) cnpj_ordem,
SAFE_CAST(cnpj_dv AS STRING) cnpj_dv,
SAFE_CAST(identificador_matriz_filial AS STRING) identificador_matriz_filial,
SAFE_CAST(nome_fantasia AS STRING) nome_fantasia,
SAFE_CAST(situacao_cadastral AS STRING) situacao_cadastral,
SAFE_CAST(data_situacao_cadastral AS DATE) data_situacao_cadastral,
SAFE_CAST(motivo_situacao_cadastral AS STRING) motivo_situacao_cadastral,
SAFE_CAST(nome_cidade_exterior AS STRING) nome_cidade_exterior,
SAFE_CAST(id_pais AS STRING) id_pais,
SAFE_CAST(data_inicio_atividade AS DATE) data_inicio_atividade,
SAFE_CAST(cnae_fiscal_principal AS STRING) cnae_fiscal_principal,
SAFE_CAST(cnae_fiscal_secundaria AS STRING) cnae_fiscal_secundaria,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_municipio_rf AS STRING) id_municipio_rf,
SAFE_CAST(tipo_logradouro AS STRING) tipo_logradouro,
SAFE_CAST(logradouro AS STRING) logradouro,
SAFE_CAST(numero AS STRING) numero,
SAFE_CAST(complemento AS STRING) complemento,
SAFE_CAST(bairro AS STRING) bairro,
SAFE_CAST(cep AS STRING) cep,
SAFE_CAST(ddd_1 AS STRING) ddd_1,
SAFE_CAST(telefone_1 AS STRING) telefone_1,
SAFE_CAST(ddd_2 AS STRING) ddd_2,
SAFE_CAST(telefone_2 AS STRING) telefone_2,
SAFE_CAST(ddd_fax AS STRING) ddd_fax,
SAFE_CAST(fax AS STRING) fax,
SAFE_CAST(email AS STRING) email,
SAFE_CAST(situacao_especial AS STRING) situacao_especial,
SAFE_CAST(data_situacao_especial AS DATE) data_situacao_especial
FROM basedosdados-dev.br_me_cnpj_staging.estabelecimentos AS t