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

CREATE VIEW basedosdados-dev.br_isp_estatisticas_seguranca.taxa_evolucao_mensal_municipio AS
SELECT 
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(municipio AS STRING) municipio,
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(mes_ano AS STRING) mes_ano,
SAFE_CAST(regiao_rj AS STRING) regiao_rj,
SAFE_CAST(hom_doloso AS FLOAT64) hom_doloso,
SAFE_CAST(lesao_corp_morte AS FLOAT64) lesao_corp_morte,
SAFE_CAST(latrocinio AS FLOAT64) latrocinio,
SAFE_CAST(hom_por_interv_policial AS FLOAT64) hom_por_interv_policial,
SAFE_CAST(letalidade_violenta AS FLOAT64) letalidade_violenta,
SAFE_CAST(tentat_hom AS FLOAT64) tentat_hom,
SAFE_CAST(lesao_corp_dolosa AS FLOAT64) lesao_corp_dolosa,
SAFE_CAST(estupro AS FLOAT64) estupro,
SAFE_CAST(hom_culposo AS FLOAT64) hom_culposo,
SAFE_CAST(lesao_corp_culposa AS FLOAT64) lesao_corp_culposa,
SAFE_CAST(roubo_comercio AS FLOAT64) roubo_comercio,
SAFE_CAST(roubo_residencia AS FLOAT64) roubo_residencia,
SAFE_CAST(roubo_veiculo AS FLOAT64) roubo_veiculo,
SAFE_CAST(roubo_carga AS FLOAT64) roubo_carga,
SAFE_CAST(roubo_transeunte AS FLOAT64) roubo_transeunte,
SAFE_CAST(roubo_em_coletivo AS FLOAT64) roubo_em_coletivo,
SAFE_CAST(roubo_banco AS FLOAT64) roubo_banco,
SAFE_CAST(roubo_cx_eletronico AS FLOAT64) roubo_cx_eletronico,
SAFE_CAST(roubo_celular AS FLOAT64) roubo_celular,
SAFE_CAST(roubo_conducao_saque AS FLOAT64) roubo_conducao_saque,
SAFE_CAST(roubo_apos_saque AS FLOAT64) roubo_apos_saque,
SAFE_CAST(roubo_bicicleta AS FLOAT64) roubo_bicicleta,
SAFE_CAST(outros_roubos AS FLOAT64) outros_roubos,
SAFE_CAST(total_roubos AS FLOAT64) total_roubos,
SAFE_CAST(furto_veiculos AS FLOAT64) furto_veiculos,
SAFE_CAST(furto_transeunte AS FLOAT64) furto_transeunte,
SAFE_CAST(furto_coletivo AS FLOAT64) furto_coletivo,
SAFE_CAST(furto_celular AS FLOAT64) furto_celular,
SAFE_CAST(furto_bicicleta AS FLOAT64) furto_bicicleta,
SAFE_CAST(outros_furtos AS FLOAT64) outros_furtos,
SAFE_CAST(total_furtos AS FLOAT64) total_furtos,
SAFE_CAST(sequestro AS FLOAT64) sequestro,
SAFE_CAST(extorsao AS FLOAT64) extorsao,
SAFE_CAST(sequestro_relampago AS FLOAT64) sequestro_relampago,
SAFE_CAST(estelionato AS FLOAT64) estelionato,
SAFE_CAST(apreensao_drogas AS FLOAT64) apreensao_drogas,
SAFE_CAST(posse_drogas AS FLOAT64) posse_drogas,
SAFE_CAST(trafico_drogas AS FLOAT64) trafico_drogas,
SAFE_CAST(apreensao_drogas_sem_autor AS FLOAT64) apreensao_drogas_sem_autor,
SAFE_CAST(recuperacao_veiculos AS FLOAT64) recuperacao_veiculos,
SAFE_CAST(apf AS FLOAT64) apf,
SAFE_CAST(aaapai AS FLOAT64) aaapai,
SAFE_CAST(cmp AS FLOAT64) cmp,
SAFE_CAST(cmba AS FLOAT64) cmba,
SAFE_CAST(ameaca AS FLOAT64) ameaca,
SAFE_CAST(pessoas_desaparecidas AS FLOAT64) pessoas_desaparecidas,
SAFE_CAST(encontro_cadaver AS FLOAT64) encontro_cadaver,
SAFE_CAST(encontro_ossada AS FLOAT64) encontro_ossada,
SAFE_CAST(indicador_cvli AS FLOAT64) indicador_cvli,
SAFE_CAST(indicador_roubo_rua AS FLOAT64) indicador_roubo_rua,
SAFE_CAST(indicador_roubo_veic AS FLOAT64) indicador_roubo_veic,
SAFE_CAST(indicador_roubo_carga AS FLOAT64) indicador_roubo_carga,
SAFE_CAST(registro_ocorrencias AS INT64) registro_ocorrencias,
SAFE_CAST(fase AS INT64) fase
FROM basedosdados-dev.br_isp_estatisticas_seguranca_staging.taxa_evolucao_mensal_municipio AS t