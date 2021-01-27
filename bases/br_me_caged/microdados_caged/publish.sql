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

CREATE VIEW basedosdados.br_me_caged.microdados_caged AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(id_municipio_6 AS INT64) id_municipio_6,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(admitidos_desligados AS INT64) admitidos_desligados,
SAFE_CAST(cbo_2002_ocupacao AS INT64) cbo_2002_ocupacao,
SAFE_CAST(cnae_10_classe AS STRING) cnae_10_classe,
SAFE_CAST(cnae_20_classe AS INT64) cnae_20_classe,
SAFE_CAST(cnae_20_subclas AS STRING) cnae_20_subclas,
SAFE_CAST(faixa_empr_inicio_jan AS INT64) faixa_empr_inicio_jan,
SAFE_CAST(grau_instrucao AS INT64) grau_instrucao,
SAFE_CAST(qtd_hora_contrat AS INT64) qtd_hora_contrat,
SAFE_CAST(ibge_subsetor AS INT64) ibge_subsetor,
SAFE_CAST(idade AS INT64) idade,
SAFE_CAST(ind_aprendiz AS INT64) ind_aprendiz,
SAFE_CAST(ind_portador_defic AS INT64) ind_portador_defic,
SAFE_CAST(raca_cor AS STRING) raca_cor,
SAFE_CAST(salario_mensal AS FLOAT64) salario_mensal,
SAFE_CAST(saldo_mov AS INT64) saldo_mov,
SAFE_CAST(sexo AS INT64) sexo,
SAFE_CAST(tempo_emprego AS FLOAT64) tempo_emprego,
SAFE_CAST(tipo_estab AS INT64) tipo_estab,
SAFE_CAST(tipo_defic AS INT64) tipo_defic,
SAFE_CAST(tipo_mov_desagregado AS INT64) tipo_mov_desagregado,
SAFE_CAST(bairros_sp AS INT64) bairros_sp,
SAFE_CAST(bairros_fortaleza AS INT64) bairros_fortaleza,
SAFE_CAST(bairros_rj AS INT64) bairros_rj,
SAFE_CAST(distritos_sp AS INT64) distritos_sp,
SAFE_CAST(regioes_adm_df AS INT64) regioes_adm_df,
SAFE_CAST(regiao_adm_rj AS INT64) regiao_adm_rj,
SAFE_CAST(regiao_adm_sp AS INT64) regiao_adm_sp,
SAFE_CAST(regiao_corede AS INT64) regiao_corede,
SAFE_CAST(regiao_corede_04 AS INT64) regiao_corede_04,
SAFE_CAST(regiao_gov_sp AS INT64) regiao_gov_sp,
SAFE_CAST(regiao_senac_pr AS INT64) regiao_senac_pr,
SAFE_CAST(regiao_senai_pr AS INT64) regiao_senai_pr,
SAFE_CAST(regiao_senai_sp AS INT64) regiao_senai_sp,
SAFE_CAST(subregiao_senai_pr AS INT64) subregiao_senai_pr,
SAFE_CAST(ind_trab_parcial AS INT64) ind_trab_parcial,
SAFE_CAST(ind_trab_intermitente AS INT64) ind_trab_intermitente
from basedosdados-staging.br_me_caged_staging.microdados_caged as t