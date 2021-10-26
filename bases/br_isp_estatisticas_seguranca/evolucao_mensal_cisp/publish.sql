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

CREATE VIEW basedosdados-dev.br_isp_estatisticas_seguranca.evolucao_mensal_cisp AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(mes_ano AS STRING) mes_ano,
SAFE_CAST(cisp AS STRING) cisp,
SAFE_CAST(aisp AS STRING) aisp,
SAFE_CAST(risp AS STRING) risp,
SAFE_CAST(municipio AS STRING) municipio,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(regiao_rj AS STRING) regiao_rj,
SAFE_CAST(hom_doloso AS INT64) hom_doloso,
SAFE_CAST(lesao_corp_morte AS INT64) lesao_corp_morte,
SAFE_CAST(latrocinio AS INT64) latrocinio,
SAFE_CAST(cvli AS INT64) cvli,
SAFE_CAST(hom_por_interv_policial AS INT64) hom_por_interv_policial,
SAFE_CAST(letalidade_violenta AS INT64) letalidade_violenta,
SAFE_CAST(tentat_hom AS INT64) tentat_hom,
SAFE_CAST(lesao_corp_dolosa AS INT64) lesao_corp_dolosa,
SAFE_CAST(estupro AS INT64) estupro,
SAFE_CAST(hom_culposo AS INT64) hom_culposo,
SAFE_CAST(lesao_corp_culposa AS INT64) lesao_corp_culposa,
SAFE_CAST(roubo_transeunte AS INT64) roubo_transeunte,
SAFE_CAST(roubo_celular AS INT64) roubo_celular,
SAFE_CAST(roubo_em_coletivo AS INT64) roubo_em_coletivo,
SAFE_CAST(roubo_rua AS INT64) roubo_rua,
SAFE_CAST(roubo_veiculo AS INT64) roubo_veiculo,
SAFE_CAST(roubo_carga AS INT64) roubo_carga,
SAFE_CAST(roubo_comercio AS INT64) roubo_comercio,
SAFE_CAST(roubo_residencia AS INT64) roubo_residencia,
SAFE_CAST(roubo_banco AS INT64) roubo_banco,
SAFE_CAST(roubo_cx_eletronico AS INT64) roubo_cx_eletronico,
SAFE_CAST(roubo_conducao_saque AS INT64) roubo_conducao_saque,
SAFE_CAST(roubo_apos_saque AS INT64) roubo_apos_saque,
SAFE_CAST(roubo_bicicleta AS INT64) roubo_bicicleta,
SAFE_CAST(outros_roubos AS INT64) outros_roubos,
SAFE_CAST(total_roubos AS INT64) total_roubos,
SAFE_CAST(furto_veiculos AS INT64) furto_veiculos,
SAFE_CAST(furto_transeunte AS INT64) furto_transeunte,
SAFE_CAST(furto_coletivo AS INT64) furto_coletivo,
SAFE_CAST(furto_celular AS INT64) furto_celular,
SAFE_CAST(furto_bicicleta AS INT64) furto_bicicleta,
SAFE_CAST(outros_furtos AS INT64) outros_furtos,
SAFE_CAST(total_furtos AS INT64) total_furtos,
SAFE_CAST(sequestro AS INT64) sequestro,
SAFE_CAST(extorsao AS INT64) extorsao,
SAFE_CAST(sequestro_relampago AS INT64) sequestro_relampago,
SAFE_CAST(estelionato AS INT64) estelionato,
SAFE_CAST(apreensao_drogas AS INT64) apreensao_drogas,
SAFE_CAST(posse_drogas AS INT64) posse_drogas,
SAFE_CAST(trafico_drogas AS INT64) trafico_drogas,
SAFE_CAST(apreensao_drogas_sem_autor AS INT64) apreensao_drogas_sem_autor,
SAFE_CAST(recuperacao_veiculos AS INT64) recuperacao_veiculos,
SAFE_CAST(apf AS INT64) apf,
SAFE_CAST(aaapai AS INT64) aaapai,
SAFE_CAST(cmp AS INT64) cmp,
SAFE_CAST(cmba AS INT64) cmba,
SAFE_CAST(ameaca AS INT64) ameaca,
SAFE_CAST(pessoas_desaparecidas AS INT64) pessoas_desaparecidas,
SAFE_CAST(encontro_cadaver AS INT64) encontro_cadaver,
SAFE_CAST(encontro_ossada AS INT64) encontro_ossada,
SAFE_CAST(pol_militares_mortos_serv AS INT64) pol_militares_mortos_serv,
SAFE_CAST(pol_civis_mortos_serv AS INT64) pol_civis_mortos_serv,
SAFE_CAST(registro_ocorrencias AS INT64) registro_ocorrencias,
SAFE_CAST(fase AS INT64) fase
from basedosdados-dev.br_isp_estatisticas_seguranca_staging.evolucao_mensal_cisp as t