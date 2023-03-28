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

CREATE VIEW basedosdados-dev.br_cnpq_bolsas.microdados AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(processo AS STRING) processo,
SAFE_CAST(data_inicio_processo AS DATE) data_inicio_processo,
SAFE_CAST(data_fim_processo AS DATE) data_fim_processo,
SAFE_CAST(beneficiario AS STRING) beneficiario,
SAFE_CAST(titulo_projeto AS STRING) titulo_projeto,
SAFE_CAST(palavra_chave AS STRING) palavra_chave,
SAFE_CAST(linha_fomento AS STRING) linha_fomento,
SAFE_CAST(modalidade AS STRING) modalidade,
SAFE_CAST(categoria_nivel AS STRING) categoria_nivel,
SAFE_CAST(chamada AS STRING) chamada,
SAFE_CAST(programa_cnpq AS STRING) programa_cnpq,
SAFE_CAST(grande_area_conhecimento AS STRING) grande_area_conhecimento,
SAFE_CAST(area_conhecimento AS STRING) area_conhecimento,
SAFE_CAST(subarea_conhecimento AS STRING) subarea_conhecimento,
SAFE_CAST(pais_origem AS STRING) pais_origem,
SAFE_CAST(sigla_uf_origem AS STRING) sigla_uf_origem,
SAFE_CAST(instituicao_origem AS STRING) instituicao_origem,
SAFE_CAST(pais_destino AS STRING) pais_destino,
SAFE_CAST(sigla_uf_destino AS STRING) sigla_uf_destino,
SAFE_CAST(municipio_destino AS STRING) municipio_destino,
SAFE_CAST(sigla_instituicao_destino AS STRING) sigla_instituicao_destino,
SAFE_CAST(sigla_instituicao_macro AS STRING) sigla_instituicao_macro,
SAFE_CAST(instituicao_destino AS STRING) instituicao_destino,
SAFE_CAST(plano_interno AS STRING) plano_interno,
SAFE_CAST(unidade_orcamentaria AS STRING) unidade_orcamentaria,
SAFE_CAST(fonte_recurso AS STRING) fonte_recurso,
SAFE_CAST(natureza_despesa AS STRING) natureza_despesa,
SAFE_CAST(programa_ppa AS STRING) programa_ppa,
SAFE_CAST(acao_ppa AS STRING) acao_ppa,
SAFE_CAST(valor AS FLOAT64) valor
FROM basedosdados-dev.br_cnpq_bolsas_staging.microdados AS t