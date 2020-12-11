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
CREATE VIEW basedosdados.br_ms_sim.microdados AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(estado_abrev AS STRING) estado_abrev,
SAFE_CAST(sequencial_obito AS INT64) sequencial_obito,
SAFE_CAST(tipo_obito AS STRING) tipo_obito,
SAFE_CAST(causa_basica AS STRING) causa_basica,
SAFE_CAST(data_obito AS DATE) data_obito,
SAFE_CAST(data_nasc AS DATE) data_nasc,
SAFE_CAST(idade AS NUMERIC) idade,
SAFE_CAST(genero AS STRING) genero,
SAFE_CAST(raca_cor AS STRING) raca_cor,
SAFE_CAST(estado_civil AS STRING) estado_civil,
SAFE_CAST(escolaridade AS STRING) escolaridade,
SAFE_CAST(ocupacao AS STRING) ocupacao,
SAFE_CAST(naturalidade AS INT64) naturalidade,
SAFE_CAST(codigo_bairro_resid AS INT64) codigo_bairro_resid,
SAFE_CAST(id_municipio_resid AS INT64) id_municipio_resid,
SAFE_CAST(local_ocor AS STRING) local_ocor,
SAFE_CAST(codigo_bairro_ocor AS INT64) codigo_bairro_ocor,
SAFE_CAST(id_municipio_ocor AS INT64) id_municipio_ocor,
SAFE_CAST(idade_mae AS NUMERIC) idade_mae,
SAFE_CAST(escolaridade_mae AS STRING) escolaridade_mae,
SAFE_CAST(ocupacao_mae AS STRING) ocupacao_mae,
SAFE_CAST(qtde_filhos_vivos AS INT64) qtde_filhos_vivos,
SAFE_CAST(qtde_filhos_mortos AS INT64) qtde_filhos_mortos,
SAFE_CAST(gravidez AS STRING) gravidez,
SAFE_CAST(gestacao AS STRING) gestacao,
SAFE_CAST(parto AS STRING) parto,
SAFE_CAST(peso AS NUMERIC) peso,
SAFE_CAST(obito_parto AS STRING) obito_parto,
SAFE_CAST(morte_parto AS STRING) morte_parto,
SAFE_CAST(obito_gravidez AS STRING) obito_gravidez,
SAFE_CAST(obito_puerperio AS STRING) obito_puerperio,
SAFE_CAST(assistencia_medica AS STRING) assistencia_medica,
SAFE_CAST(exame AS STRING) exame,
SAFE_CAST(cirurgia AS STRING) cirurgia,
SAFE_CAST(necropsia AS STRING) necropsia,
SAFE_CAST(linha_a AS STRING) linha_a,
SAFE_CAST(linha_b AS STRING) linha_b,
SAFE_CAST(linha_c AS STRING) linha_c,
SAFE_CAST(linha_d AS STRING) linha_d,
SAFE_CAST(linha_ii AS STRING) linha_ii,
SAFE_CAST(circunstancia_obito AS STRING) circunstancia_obito,
SAFE_CAST(acidente_trabalho AS STRING) acidente_trabalho,
SAFE_CAST(fonte AS STRING) fonte,
SAFE_CAST(id_estab AS INT64) id_estab,
SAFE_CAST(descricao_estab AS STRING) descricao_estab,
SAFE_CAST(atestante AS STRING) atestante,
SAFE_CAST(hora_obito AS TIME) hora_obito,
SAFE_CAST(tipo_assinatura AS INT64) tipo_assinatura,
SAFE_CAST(data_atestado AS DATE) data_atestado,
SAFE_CAST(tipo_pos AS STRING) tipo_pos,
SAFE_CAST(data_investigacao AS DATE) data_investigacao,
SAFE_CAST(causa_basica_original AS STRING) causa_basica_original,
SAFE_CAST(data_cadastro AS DATE) data_cadastro,
SAFE_CAST(fonte_investigacao AS STRING) fonte_investigacao,
SAFE_CAST(data_recebimento AS DATE) data_recebimento,
SAFE_CAST(causa_basica_pre AS STRING) causa_basica_pre,
SAFE_CAST(tipo_obito_ocor AS STRING) tipo_obito_ocor,
SAFE_CAST(data_cadastro_inf AS DATE) data_cadastro_inf,
SAFE_CAST(numero_DN AS INT64) numero_DN,
SAFE_CAST(id_municipio_SVO_IML AS INT64) id_municipio_SVO_IML,
SAFE_CAST(data_cadastro_investigacao AS DATE) data_cadastro_investigacao,
SAFE_CAST(data_recebimento_original AS DATE) data_recebimento_original,
SAFE_CAST(data_recoriga AS DATE) data_recoriga,
SAFE_CAST(causa_materna AS STRING) causa_materna,
SAFE_CAST(status_DO_epidem AS STRING) status_DO_epidem,
SAFE_CAST(status_DO_nova AS STRING) status_DO_nova,
SAFE_CAST(id_municipio_cartorio AS STRING) id_municipio_cartorio,
SAFE_CAST(codigo_cartorio AS STRING) codigo_cartorio,
SAFE_CAST(numero_registro_cartorio AS STRING) numero_registro_cartorio,
SAFE_CAST(data_registro_cartorio AS DATE) data_registro_cartorio,
SAFE_CAST(serie_escolar_falecido AS STRING) serie_escolar_falecido,
SAFE_CAST(serie_escolar_mae AS STRING) serie_escolar_mae,
SAFE_CAST(escolaridade_2010 AS STRING) escolaridade_2010,
SAFE_CAST(escolaridade_falecido_2010_agr AS STRING) escolaridade_falecido_2010_agr,
SAFE_CAST(escolaridade_mae_2010 AS STRING) escolaridade_mae_2010,
SAFE_CAST(escolaridade_mae_2010_agr AS STRING) escolaridade_mae_2010_agr,
SAFE_CAST(semanas_gestacao AS NUMERIC) semanas_gestacao,
SAFE_CAST(tipo_morte_ocor AS STRING) tipo_morte_ocor,
SAFE_CAST(exp_diferenca_data AS INT64) exp_diferenca_data,
SAFE_CAST(diferenca_data AS INT64) diferenca_data,
SAFE_CAST(data_conclusao_investigacao AS DATE) data_conclusao_investigacao,
SAFE_CAST(data_conclusao_caso AS DATE) data_conclusao_caso,
SAFE_CAST(numero_dias_obito_investigacao AS INT64) numero_dias_obito_investigacao,
SAFE_CAST(id_municipio_naturalidade AS INT64) id_municipio_naturalidade,
SAFE_CAST(CRM AS STRING) CRM,
SAFE_CAST(numero_lote AS INT64) numero_lote,
SAFE_CAST(status_codificadora AS STRING) status_codificadora,
SAFE_CAST(codificado AS STRING) codificado,
SAFE_CAST(versao_sistema AS STRING) versao_sistema,
SAFE_CAST(versao_SCB AS STRING) versao_SCB,
SAFE_CAST(atestado AS STRING) atestado,
SAFE_CAST(numero_dias_obito_ficha AS INT64) numero_dias_obito_ficha,
SAFE_CAST(fontes AS STRING) fontes,
SAFE_CAST(tipo_resgate_informacao AS STRING) tipo_resgate_informacao,
SAFE_CAST(tipo_nivel_investigador AS STRING) tipo_nivel_investigador,
SAFE_CAST(numero_dias_inf AS INT64) numero_dias_inf,
SAFE_CAST(fontes_inf AS STRING) fontes_inf,
SAFE_CAST(alt_causa AS STRING) alt_causa
from basedosdados-staging.br_ms_sim_staging.microdados as t