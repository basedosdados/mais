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

CREATE VIEW basedosdados-dev.br_rj_isp_estatisticas_seguranca.taxa_evolucao_anual_uf AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(taxa_homicidio_doloso AS INT64) taxa_homicidio_doloso,
SAFE_CAST(taxa_latrocinio AS INT64) taxa_latrocinio,
SAFE_CAST(taxa_lesao_corporal_morte AS INT64) taxa_lesao_corporal_morte,
SAFE_CAST(taxa_crimes_violentos_letais_intencionais AS INT64) taxa_crimes_violentos_letais_intencionais,
SAFE_CAST(taxa_homicidio_intervencao_policial AS INT64) taxa_homicidio_intervencao_policial,
SAFE_CAST(taxa_letalidade_violenta AS INT64) taxa_letalidade_violenta,
SAFE_CAST(taxa_tentativa_homicidio AS INT64) taxa_tentativa_homicidio,
SAFE_CAST(taxa_lesao_corporal_dolosa AS INT64) taxa_lesao_corporal_dolosa,
SAFE_CAST(taxa_estupro AS INT64) taxa_estupro,
SAFE_CAST(taxa_homicidio_culposo AS INT64) taxa_homicidio_culposo,
SAFE_CAST(taxa_lesao_corporal_culposa AS INT64) taxa_lesao_corporal_culposa,
SAFE_CAST(taxa_roubo_transeunte AS INT64) taxa_roubo_transeunte,
SAFE_CAST(taxa_roubo_celular AS INT64) taxa_roubo_celular,
SAFE_CAST(taxa_roubo_corporal_coletivo AS INT64) taxa_roubo_corporal_coletivo,
SAFE_CAST(taxa_roubo_rua AS INT64) taxa_roubo_rua,
SAFE_CAST(taxa_roubo_veiculo AS INT64) taxa_roubo_veiculo,
SAFE_CAST(taxa_roubo_carga AS INT64) taxa_roubo_carga,
SAFE_CAST(taxa_roubo_comercio AS INT64) taxa_roubo_comercio,
SAFE_CAST(taxa_roubo_residencia AS INT64) taxa_roubo_residencia,
SAFE_CAST(taxa_roubo_banco AS INT64) taxa_roubo_banco,
SAFE_CAST(taxa_roubo_caixa_eletronico AS INT64) taxa_roubo_caixa_eletronico,
SAFE_CAST(taxa_roubo_conducao_saque AS INT64) taxa_roubo_conducao_saque,
SAFE_CAST(taxa_roubo_apos_saque AS INT64) taxa_roubo_apos_saque,
SAFE_CAST(taxa_roubo_bicicleta AS INT64) taxa_roubo_bicicleta,
SAFE_CAST(taxa_outros_roubos AS INT64) taxa_outros_roubos,
SAFE_CAST(taxa_total_roubos AS INT64) taxa_total_roubos,
SAFE_CAST(taxa_furto_veiculos AS INT64) taxa_furto_veiculos,
SAFE_CAST(taxa_furto_transeunte AS INT64) taxa_furto_transeunte,
SAFE_CAST(taxa_furto_coletivo AS INT64) taxa_furto_coletivo,
SAFE_CAST(taxa_furto_celular AS INT64) taxa_furto_celular,
SAFE_CAST(taxa_furto_bicicleta AS INT64) taxa_furto_bicicleta,
SAFE_CAST(taxa_outros_furtos AS INT64) taxa_outros_furtos,
SAFE_CAST(taxa_total_furtos AS INT64) taxa_total_furtos,
SAFE_CAST(taxa_sequestro AS INT64) taxa_sequestro,
SAFE_CAST(taxa_extorsao AS INT64) taxa_extorsao,
SAFE_CAST(taxa_sequestro_relampago AS INT64) taxa_sequestro_relampago,
SAFE_CAST(taxa_estelionato AS INT64) taxa_estelionato,
SAFE_CAST(taxa_apreensao_drogas AS INT64) taxa_apreensao_drogas,
SAFE_CAST(taxa_registro_posse_drogas AS INT64) taxa_registro_posse_drogas,
SAFE_CAST(taxa_registro_trafico_drogas AS INT64) taxa_registro_trafico_drogas,
SAFE_CAST(taxa_registro_apreensao_drogas_sem_autor AS INT64) taxa_registro_apreensao_drogas_sem_autor,
SAFE_CAST(taxa_registro_veiculo_recuperado AS INT64) taxa_registro_veiculo_recuperado,
SAFE_CAST(taxa_apf AS INT64) taxa_apf,
SAFE_CAST(taxa_aaapai AS INT64) taxa_aaapai,
SAFE_CAST(taxa_cmp AS INT64) taxa_cmp,
SAFE_CAST(taxa_cmba AS INT64) taxa_cmba,
SAFE_CAST(taxa_ameaca AS INT64) taxa_ameaca,
SAFE_CAST(taxa_pessoas_desaparecidas AS INT64) taxa_pessoas_desaparecidas,
SAFE_CAST(taxa_encontro_cadaver AS INT64) taxa_encontro_cadaver,
SAFE_CAST(taxa_encontro_ossada AS INT64) taxa_encontro_ossada,
SAFE_CAST(taxa_policial_militar_morto_servico AS INT64) taxa_policial_militar_morto_servico,
SAFE_CAST(taxa_policial_civil_morto_servico AS INT64) taxa_policial_civil_morto_servico,
SAFE_CAST(taxa_registro_ocorrencia AS INT64) taxa_registro_ocorrencia,
SAFE_CAST(tipo_fase AS STRING) tipo_fase
FROM basedosdados-dev.br_rj_isp_estatisticas_seguranca_staging.taxa_evolucao_anual_uf AS t