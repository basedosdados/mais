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
CREATE VIEW basedosdados-dev.br_ms_sim.microdados AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(sequencial_obito AS STRING) sequencial_obito,
SAFE_CAST(tipo_obito AS STRING) tipo_obito,
SAFE_CAST(causa_basica AS STRING) causa_basica,
SAFE_CAST(data_obito AS DATE) data_obito,
SAFE_CAST(hora_obito AS TIME) hora_obito,
SAFE_CAST(naturalidade AS STRING) naturalidade,
SAFE_CAST(data_nascimento AS DATE) data_nascimento,
SAFE_CAST(idade AS FLOAT64) idade,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(raca_cor AS STRING) raca_cor,
SAFE_CAST(estado_civil AS STRING) estado_civil,
SAFE_CAST(escolaridade AS STRING) escolaridade,
SAFE_CAST(ocupacao AS STRING) ocupacao,
SAFE_CAST(codigo_bairro_residencia AS STRING) codigo_bairro_residencia,
SAFE_CAST(id_municipio_residencia AS STRING) id_municipio_residencia,
SAFE_CAST(local_ocorrencia AS STRING) local_ocorrencia,
SAFE_CAST(codigo_bairro_ocorrencia AS STRING) codigo_bairro_ocorrencia,
SAFE_CAST(id_municipio_ocorrencia AS STRING) id_municipio_ocorrencia,
SAFE_CAST(idade_mae AS INT64) idade_mae,
SAFE_CAST(escolaridade_mae AS STRING) escolaridade_mae,
SAFE_CAST(ocupacao_mae AS STRING) ocupacao_mae,
SAFE_CAST(quantidade_filhos_vivos AS INT64) quantidade_filhos_vivos,
SAFE_CAST(quantidade_filhos_mortos AS INT64) quantidade_filhos_mortos,
SAFE_CAST(gravidez AS STRING) gravidez,
SAFE_CAST(gestacao AS STRING) gestacao,
SAFE_CAST(parto AS STRING) parto,
SAFE_CAST(obito_parto AS STRING) obito_parto,
SAFE_CAST(morte_parto AS STRING) morte_parto,
SAFE_CAST(peso AS INT64) peso,
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
SAFE_CAST(codigo_estabelecimento AS STRING) codigo_estabelecimento,
SAFE_CAST(atestante AS STRING) atestante,
SAFE_CAST(data_atestado AS DATE) data_atestado,
SAFE_CAST(tipo_pos AS STRING) tipo_pos,
SAFE_CAST(data_investigacao AS DATE) data_investigacao,
SAFE_CAST(causa_basica_original AS STRING) causa_basica_original,
SAFE_CAST(data_cadastro AS DATE) data_cadastro,
SAFE_CAST(fonte_investigacao AS STRING) fonte_investigacao,
SAFE_CAST(data_recebimento AS DATE) data_recebimento,
SAFE_CAST(causa_basica_pre AS STRING) causa_basica_pre,
SAFE_CAST(tipo_obito_ocorrencia AS STRING) tipo_obito_ocorrencia,
SAFE_CAST(tipo_morte_ocorrencia AS STRING) tipo_morte_ocorrencia,
SAFE_CAST(data_cadastro_informacao AS DATE) data_cadastro_informacao,
SAFE_CAST(data_cadastro_investigacao AS DATE) data_cadastro_investigacao,
SAFE_CAST(id_municipio_svo_iml AS STRING) id_municipio_svo_iml,
SAFE_CAST(data_recebimento_original AS DATE) data_recebimento_original,
SAFE_CAST(data_recebimento_original_a AS DATE) data_recebimento_original_a,
SAFE_CAST(causa_materna AS STRING) causa_materna,
SAFE_CAST(status_do_epidem AS STRING) status_do_epidem,
SAFE_CAST(status_do_nova AS STRING) status_do_nova,
SAFE_CAST(serie_escolar_falecido AS INT64) serie_escolar_falecido,
SAFE_CAST(serie_escolar_mae AS INT64) serie_escolar_mae,
SAFE_CAST(escolaridade_2010 AS STRING) escolaridade_2010,
SAFE_CAST(escolaridade_mae_2010 AS STRING) escolaridade_mae_2010,
SAFE_CAST(escolaridade_falecido_2010_agr AS STRING) escolaridade_falecido_2010_agr,
SAFE_CAST(escolaridade_mae_2010_agr AS STRING) escolaridade_mae_2010_agr,
SAFE_CAST(semanas_gestacao AS INT64) semanas_gestacao,
SAFE_CAST(diferenca_data AS INT64) diferenca_data,
SAFE_CAST(data_conclusao_investigacao AS DATE) data_conclusao_investigacao,
SAFE_CAST(data_conclusao_caso AS DATE) data_conclusao_caso,
SAFE_CAST(numero_dias_obito_investigacao AS INT64) numero_dias_obito_investigacao,
SAFE_CAST(id_municipio_naturalidade AS STRING) id_municipio_naturalidade,
SAFE_CAST(descricao_estabelecimento AS STRING) descricao_estabelecimento,
SAFE_CAST(crm AS STRING) crm,
SAFE_CAST(numero_lote AS STRING) numero_lote,
SAFE_CAST(status_codificadora AS STRING) status_codificadora,
SAFE_CAST(codificado AS STRING) codificado,
SAFE_CAST(versao_sistema AS STRING) versao_sistema,
SAFE_CAST(versao_scb AS STRING) versao_scb,
SAFE_CAST(atestado AS STRING) atestado,
SAFE_CAST(numero_dias_obito_ficha AS INT64) numero_dias_obito_ficha,
SAFE_CAST(fontes AS STRING) fontes,
SAFE_CAST(tipo_resgate_informacao AS STRING) tipo_resgate_informacao,
SAFE_CAST(tipo_nivel_investigador AS STRING) tipo_nivel_investigador,
SAFE_CAST(numero_dias_informacao AS INT64) numero_dias_informacao,
SAFE_CAST(fontes_informacao AS STRING) fontes_informacao,
SAFE_CAST(alt_causa AS STRING) alt_causa
FROM basedosdados-dev.br_ms_sim_staging.microdados AS t