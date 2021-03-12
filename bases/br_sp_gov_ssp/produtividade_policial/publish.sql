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
    - Para modificar tipos de colunas, basta substituir INT64 por outro tipo válido.
    - Exemplo: `SAFE_CAST(column_name AS NUMERIC) column_name`
    - Mais detalhes: https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types

*/

CREATE VIEW basedosdados-dev.br_sp_gov_ssp.produtividade_policial AS
SELECT
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(id_estado AS INT64) id_estado,
SAFE_CAST(regiao_ssp AS STRING) regiao_ssp,
SAFE_CAST(ocorrencias_de_porte_de_entorpecentes AS INT64) ocorrencias_de_porte_de_entorpecentes,
SAFE_CAST(ocorrencias_de_trafico_de_entorpecentes AS INT64) ocorrencias_de_trafico_de_entorpecentes,
SAFE_CAST(ocorrencias_de_apreensao_de_entorpecentes AS INT64) ocorrencias_de_apreensao_de_entorpecentes,
SAFE_CAST(ocorrencias_de_porte_ilegal_de_arma AS INT64) ocorrencias_de_porte_ilegal_de_arma,
SAFE_CAST(numero_de_armas_de_fogo_apreendidas AS INT64) numero_de_armas_de_fogo_apreendidas,
SAFE_CAST(numero_de_flagrantes_lavrados AS INT64) numero_de_flagrantes_lavrados,
SAFE_CAST(numero_de_infratores_apreendidos_em_flagrante AS INT64) numero_de_infratores_apreendidos_em_flagrante,
SAFE_CAST(numero_de_infratores_apreendidos_por_mandado AS INT64) numero_de_infratores_apreendidos_por_mandado,
SAFE_CAST(numero_de_pessoas_presas_em_flagrante AS INT64) numero_de_pessoas_presas_em_flagrante,
SAFE_CAST(numero_de_pessoas_presas_por_mandado AS INT64) numero_de_pessoas_presas_por_mandado,
SAFE_CAST(numero_de_prisoes_efetuadas AS INT64) numero_de_prisoes_efetuadas,
SAFE_CAST(numero_de_veiculos_recuperados AS INT64) numero_de_veiculos_recuperados,
SAFE_CAST(total_de_inqueritos_policiais_instaurados AS INT64) total_de_inqueritos_policiais_instaurados
from basedosdados-dev.br_sp_gov_ssp_staging.produtividade_policial as t