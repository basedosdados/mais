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

CREATE VIEW basedosdados-dev.br_ms_sinasc.microdados AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sequencial_nascimento AS STRING) sequencial_nascimento,
SAFE_CAST(id_municipio_nascimento AS STRING) id_municipio_nascimento,
SAFE_CAST(local_nascimento AS STRING) local_nascimento,
SAFE_CAST(codigo_estabelecimento AS STRING) codigo_estabelecimento,
SAFE_CAST(data_nascimento AS DATE) data_nascimento,
SAFE_CAST(hora_nascimento AS TIME) hora_nascimento,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(peso AS INT64) peso,
SAFE_CAST(raca_cor AS STRING) raca_cor,
SAFE_CAST(apgar1 AS STRING) apgar1,
SAFE_CAST(apgar5 AS STRING) apgar5,
SAFE_CAST(id_anomalia AS STRING) id_anomalia,
SAFE_CAST(codigo_anomalia AS STRING) codigo_anomalia,
SAFE_CAST(semana_gestacao AS INT64) semana_gestacao,
SAFE_CAST(semana_gestacao_estimada AS STRING) semana_gestacao_estimada,
SAFE_CAST(gestacao_agr AS STRING) gestacao_agr,
SAFE_CAST(tipo_gravidez AS STRING) tipo_gravidez,
SAFE_CAST(tipo_parto AS STRING) tipo_parto,
SAFE_CAST(inicio_pre_natal AS STRING) inicio_pre_natal,
SAFE_CAST(pre_natal AS INT64) pre_natal,
SAFE_CAST(pre_natal_agr AS STRING) pre_natal_agr,
SAFE_CAST(classificacao_pre_natal AS STRING) classificacao_pre_natal,
SAFE_CAST(quantidade_filhos_vivos AS INT64) quantidade_filhos_vivos,
SAFE_CAST(quantidade_filhos_mortos AS INT64) quantidade_filhos_mortos,
SAFE_CAST(id_pais_mae AS STRING) id_pais_mae,
SAFE_CAST(id_uf_mae AS STRING) id_uf_mae,
SAFE_CAST(id_municipio_mae AS STRING) id_municipio_mae,
SAFE_CAST(id_pais_residencia AS STRING) id_pais_residencia,
SAFE_CAST(id_municipio_residencia AS STRING) id_municipio_residencia,
SAFE_CAST(data_nascimento_mae AS DATE) data_nascimento_mae,
SAFE_CAST(idade_mae AS INT64) idade_mae,
SAFE_CAST(escolaridade AS STRING) escolaridade,
SAFE_CAST(serie_escolar_mae AS STRING) serie_escolar_mae,
SAFE_CAST(escolaridade_2010 AS STRING) escolaridade_2010,
SAFE_CAST(escolaridade_2010_agr AS STRING) escolaridade_2010_agr,
SAFE_CAST(estado_civil AS STRING) estado_civil,
SAFE_CAST(ocupacao AS STRING) ocupacao,
SAFE_CAST(raca_cor_mae AS STRING) raca_cor_mae,
SAFE_CAST(gestacoes_ant AS INT64) gestacoes_ant,
SAFE_CAST(quantidade_parto_normal AS INT64) quantidade_parto_normal,
SAFE_CAST(quantidade_parto_cesareo AS INT64) quantidade_parto_cesareo,
SAFE_CAST(data_ultima_menstruacao AS DATE) data_ultima_menstruacao,
SAFE_CAST(tipo_apresentacao AS STRING) tipo_apresentacao,
SAFE_CAST(inducao_parto AS STRING) inducao_parto,
SAFE_CAST(cesarea_antes_parto AS STRING) cesarea_antes_parto,
SAFE_CAST(tipo_robson AS STRING) tipo_robson,
SAFE_CAST(idade_pai AS INT64) idade_pai,
SAFE_CAST(cartorio AS STRING) cartorio,
SAFE_CAST(registro_cartorio AS STRING) registro_cartorio,
SAFE_CAST(data_registro_cartorio AS DATE) data_registro_cartorio,
SAFE_CAST(origem AS STRING) origem,
SAFE_CAST(numero_lote AS STRING) numero_lote,
SAFE_CAST(versao_sistema AS FLOAT64) versao_sistema,
SAFE_CAST(data_cadastro AS DATE) data_cadastro,
SAFE_CAST(data_recebimento AS DATE) data_recebimento,
SAFE_CAST(data_recebimento_original AS DATE) data_recebimento_original,
SAFE_CAST(diferenca_data AS INT64) diferenca_data,
SAFE_CAST(data_declaracao AS DATE) data_declaracao,
SAFE_CAST(funcao_responsavel AS STRING) funcao_responsavel,
SAFE_CAST(documento_responsavel AS STRING) documento_responsavel,
SAFE_CAST(formacao_profissional AS STRING) formacao_profissional,
SAFE_CAST(status_dn AS STRING) status_dn,
SAFE_CAST(status_dn_nova AS STRING) status_dn_nova,
SAFE_CAST(paridade AS STRING) paridade
from basedosdados-dev.br_ms_sinasc_staging.microdados as t