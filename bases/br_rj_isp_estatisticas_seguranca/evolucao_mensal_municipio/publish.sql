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

CREATE VIEW basedosdados-dev.br_rj_isp_estatisticas_seguranca.evolucao_mensal_municipio AS
SELECT 
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(mes AS STRING) mes,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(regiao AS STRING) regiao,
SAFE_CAST(quantidade_homicidio_doloso AS STRING) quantidade_homicidio_doloso,
SAFE_CAST(quantidade_latrocinio AS STRING) quantidade_latrocinio,
SAFE_CAST(quantidade_lesao_corporal_morte AS STRING) quantidade_lesao_corporal_morte,
SAFE_CAST(quantidade_crimes_violento_letal_intencional AS STRING) quantidade_crimes_violento_letal_intencional,
SAFE_CAST(quantidade_homicidio_intervencao_policial AS STRING) quantidade_homicidio_intervencao_policial,
SAFE_CAST(quantidade_letalidade_violenta AS STRING) quantidade_letalidade_violenta,
SAFE_CAST(quantidade_tentativa_homicidio AS STRING) quantidade_tentativa_homicidio,
SAFE_CAST(quantidade_lesao_corporal_dolosa AS STRING) quantidade_lesao_corporal_dolosa,
SAFE_CAST(quantidade_estupro AS STRING) quantidade_estupro,
SAFE_CAST(quantidade_homicidio_culposo AS STRING) quantidade_homicidio_culposo,
SAFE_CAST(quantidade_lesao_corporal_culposa AS STRING) quantidade_lesao_corporal_culposa,
SAFE_CAST(quantidade_roubo_ AS STRING) quantidade_roubo_,
SAFE_CAST(quantidade_roubo_celular AS STRING) quantidade_roubo_celular,
SAFE_CAST(quantidade_roubo_corporal_coletivo AS STRING) quantidade_roubo_corporal_coletivo,
SAFE_CAST(quantidade_roubo_rua AS STRING) quantidade_roubo_rua,
SAFE_CAST(quantidade_roubo_veiculo AS STRING) quantidade_roubo_veiculo,
SAFE_CAST(quantidade_roubo_carga AS STRING) quantidade_roubo_carga,
SAFE_CAST(quantidade_roubo_comercio AS STRING) quantidade_roubo_comercio,
SAFE_CAST(quantidade_roubo_residencia AS STRING) quantidade_roubo_residencia,
SAFE_CAST(quantidade_roubo_banco AS STRING) quantidade_roubo_banco,
SAFE_CAST(quantidade_roubo_caixa_eletronico AS STRING) quantidade_roubo_caixa_eletronico,
SAFE_CAST(quantidade_roubo_conducao_saque AS STRING) quantidade_roubo_conducao_saque,
SAFE_CAST(quantidade_roubo_apos_saque AS STRING) quantidade_roubo_apos_saque,
SAFE_CAST(quantidade_roubo_bicicleta AS STRING) quantidade_roubo_bicicleta,
SAFE_CAST(quantidade_outros_roubo AS STRING) quantidade_outros_roubo,
SAFE_CAST(quantidade_total_roubos AS STRING) quantidade_total_roubos,
SAFE_CAST(quantidade_furto_veiculos AS STRING) quantidade_furto_veiculos,
SAFE_CAST(quantidade_furto_transeunte AS STRING) quantidade_furto_transeunte,
SAFE_CAST(quantidade_furto_coletivo AS STRING) quantidade_furto_coletivo,
SAFE_CAST(quantidade_furto_celular AS STRING) quantidade_furto_celular,
SAFE_CAST(quantidade_furto_bicicleta AS STRING) quantidade_furto_bicicleta,
SAFE_CAST(quantidade_outros_furto AS STRING) quantidade_outros_furto,
SAFE_CAST(quantidade_total_furtos AS STRING) quantidade_total_furtos,
SAFE_CAST(quantidade_sequestro AS STRING) quantidade_sequestro,
SAFE_CAST(quantidade_extorsao AS STRING) quantidade_extorsao,
SAFE_CAST(quantidade_sequestro_relampago AS STRING) quantidade_sequestro_relampago,
SAFE_CAST(quantidade_estelionato AS STRING) quantidade_estelionato,
SAFE_CAST(quantidade_apreensao_drogas AS STRING) quantidade_apreensao_drogas,
SAFE_CAST(quantidade_registro_posse_droga AS STRING) quantidade_registro_posse_droga,
SAFE_CAST(quantidade_registro_trafico_droga AS STRING) quantidade_registro_trafico_droga,
SAFE_CAST(quantidade_registro_apreensao_droga_sem_autor AS STRING) quantidade_registro_apreensao_droga_sem_autor,
SAFE_CAST(quantidade_registro_veiculo_recuperado AS STRING) quantidade_registro_veiculo_recuperado,
SAFE_CAST(quantidade_apf AS STRING) quantidade_apf,
SAFE_CAST(quantidade_aaapai AS STRING) quantidade_aaapai,
SAFE_CAST(quantidade_cmp AS STRING) quantidade_cmp,
SAFE_CAST(quantidade_cmba AS STRING) quantidade_cmba,
SAFE_CAST(quantidade_ameaca AS STRING) quantidade_ameaca,
SAFE_CAST(quantidade_pessoa_desaparecida AS STRING) quantidade_pessoa_desaparecida,
SAFE_CAST(quantidade_encontro_cadaver AS STRING) quantidade_encontro_cadaver,
SAFE_CAST(quantidade_encontro_ossada AS STRING) quantidade_encontro_ossada,
SAFE_CAST(quantidade_policial_militar_morto_servico AS STRING) quantidade_policial_militar_morto_servico,
SAFE_CAST(quantidade_policial_civil_morto_servico AS STRING) quantidade_policial_civil_morto_servico,
SAFE_CAST(quantidade_registro_ocorrencia AS STRING) quantidade_registro_ocorrencia,
SAFE_CAST(tipo_fase AS STRING) tipo_fase
FROM basedosdados-dev.br_rj_isp_estatisticas_seguranca_staging.evolucao_mensal_municipio AS t