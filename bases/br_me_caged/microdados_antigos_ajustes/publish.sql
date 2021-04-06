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

CREATE VIEW basedosdados-dev.br_me_caged.microdados_antigos_ajustes AS
SELECT
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(competencia_movimentacao AS STRING) competencia_movimentacao,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(id_municipio_6 AS INT64) id_municipio_6,
SAFE_CAST(admitidos_desligados AS INT64) admitidos_desligados,
SAFE_CAST(tipo_estabelecimento AS INT64) tipo_estabelecimento,
SAFE_CAST(tipo_movimentacao_desagregado AS INT64) tipo_movimentacao_desagregado,
SAFE_CAST(faixa_emprego_inicio_janeiro AS INT64) faixa_emprego_inicio_janeiro,
SAFE_CAST(tempo_emprego AS FLOAT64) tempo_emprego,
SAFE_CAST(quantidade_horas_contratadas AS INT64) quantidade_horas_contratadas,
SAFE_CAST(salario_mensal AS FLOAT64) salario_mensal,
SAFE_CAST(saldo_movimentacao AS INT64) saldo_movimentacao,
SAFE_CAST(indicador_aprendiz AS INT64) indicador_aprendiz,
SAFE_CAST(indicador_trabalho_intermitente AS INT64) indicador_trabalho_intermitente,
SAFE_CAST(indicador_trabalho_parcial AS INT64) indicador_trabalho_parcial,
SAFE_CAST(indicador_portador_deficiencia AS INT64) indicador_portador_deficiencia,
SAFE_CAST(tipo_deficiencia AS INT64) tipo_deficiencia,
SAFE_CAST(cbo_1994 AS STRING) cbo_1994,
SAFE_CAST(cbo_2002 AS STRING) cbo_2002,
SAFE_CAST(cnae_1 AS STRING) cnae_1,
SAFE_CAST(cnae_2_subclasse AS STRING) cnae_2_subclasse,
SAFE_CAST(grau_instrucao AS INT64) grau_instrucao,
SAFE_CAST(idade AS INT64) idade,
SAFE_CAST(sexo AS INT64) sexo,
SAFE_CAST(raca_cor AS INT64) raca_cor,
SAFE_CAST(subsetor_ibge AS INT64) subsetor_ibge,
SAFE_CAST(bairros_sp AS INT64) bairros_sp,
SAFE_CAST(bairros_fortaleza AS INT64) bairros_fortaleza,
SAFE_CAST(bairros_rj AS INT64) bairros_rj,
SAFE_CAST(distritos_sp AS INT64) distritos_sp,
SAFE_CAST(regiao_administrativas_df AS INT64) regiao_administrativas_df,
SAFE_CAST(regiao_administrativas_rj AS INT64) regiao_administrativas_rj,
SAFE_CAST(regiao_administrativas_sp AS INT64) regiao_administrativas_sp,
SAFE_CAST(regiao_corede AS INT64) regiao_corede,
SAFE_CAST(regiao_corede_04 AS INT64) regiao_corede_04,
SAFE_CAST(regiao_gov_sp AS INT64) regiao_gov_sp,
SAFE_CAST(regiao_senac_pr AS INT64) regiao_senac_pr,
SAFE_CAST(regiao_senai_pr AS INT64) regiao_senai_pr,
SAFE_CAST(regiao_senai_sp AS INT64) regiao_senai_sp,
SAFE_CAST(subregiao_senai_pr AS INT64) subregiao_senai_pr,
SAFE_CAST(regiao_metropolitana_mte AS INT64) regiao_metropolitana_mte
from basedosdados-dev.br_me_caged_staging.microdados_antigos_ajutes as t
