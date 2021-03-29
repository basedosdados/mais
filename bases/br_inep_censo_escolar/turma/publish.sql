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

CREATE VIEW basedosdados-dev.br_inep_censo_escolar.turma AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(id_escola AS INT64) id_escola,
SAFE_CAST(tipo_localizacao AS INT64) tipo_localizacao,
SAFE_CAST(tipo_categoria_escola_privada AS INT64) tipo_categoria_escola_privada,
SAFE_CAST(conveniada_poder_publico AS INT64) conveniada_poder_publico,
SAFE_CAST(tipo_convenio_poder_publico AS INT64) tipo_convenio_poder_publico,
SAFE_CAST(id_turma AS INT64) id_turma,
SAFE_CAST(taxa_hora_inicial AS INT64) taxa_hora_inicial,
SAFE_CAST(taxa_minuto_inicial AS INT64) taxa_minuto_inicial,
SAFE_CAST(numero_duracao_turma AS INT64) numero_duracao_turma,
SAFE_CAST(quantidade_matriculas AS INT64) quantidade_matriculas,
SAFE_CAST(tipo_etapa_ensino AS INT64) tipo_etapa_ensino,
SAFE_CAST(id_curso_educ_profissional AS INT64) id_curso_educ_profissional,
SAFE_CAST(tipo_turma AS INT64) tipo_turma,
SAFE_CAST(id_tipo_atividade_1 AS INT64) id_tipo_atividade_1,
SAFE_CAST(id_tipo_atividade_2 AS INT64) id_tipo_atividade_2,
SAFE_CAST(id_tipo_atividade_3 AS INT64) id_tipo_atividade_3,
SAFE_CAST(id_tipo_atividade_4 AS INT64) id_tipo_atividade_4,
SAFE_CAST(id_tipo_atividade_5 AS INT64) id_tipo_atividade_5,
SAFE_CAST(id_tipo_atividade_6 AS INT64) id_tipo_atividade_6,
SAFE_CAST(numero_dias_atividade AS INT64) numero_dias_atividade,
SAFE_CAST(braille AS INT64) braille,
SAFE_CAST(recursos_baixa_visao AS INT64) recursos_baixa_visao,
SAFE_CAST(processos_mentais AS INT64) processos_mentais,
SAFE_CAST(orientacao_mobilidade AS INT64) orientacao_mobilidade,
SAFE_CAST(sinais AS INT64) sinais,
SAFE_CAST(comunicacao_alt_aument AS INT64) comunicacao_alt_aument,
SAFE_CAST(enriquecimento_curricular AS INT64) enriquecimento_curricular,
SAFE_CAST(soroban AS INT64) soroban,
SAFE_CAST(informatica_acessivel AS INT64) informatica_acessivel,
SAFE_CAST(port_escrita AS INT64) port_escrita,
SAFE_CAST(autonomia_escolar AS INT64) autonomia_escolar,
SAFE_CAST(disciplina_quimica AS INT64) disciplina_quimica,
SAFE_CAST(disciplina_fisica AS INT64) disciplina_fisica,
SAFE_CAST(disciplina_matematica AS INT64) disciplina_matematica,
SAFE_CAST(disciplina_biologia AS INT64) disciplina_biologia,
SAFE_CAST(disciplina_ciencias AS INT64) disciplina_ciencias,
SAFE_CAST(disciplina_lingua_portuguesa AS INT64) disciplina_lingua_portuguesa,
SAFE_CAST(disciplina_lingua_ingles AS INT64) disciplina_lingua_ingles,
SAFE_CAST(disciplina_lingua_espanhol AS INT64) disciplina_lingua_espanhol,
SAFE_CAST(disciplina_lingua_frances AS INT64) disciplina_lingua_frances,
SAFE_CAST(disciplina_lingua_outra AS INT64) disciplina_lingua_outra,
SAFE_CAST(disciplina_lingua_indigena AS INT64) disciplina_lingua_indigena,
SAFE_CAST(disciplina_artes AS INT64) disciplina_artes,
SAFE_CAST(disciplina_educacao_fisica AS INT64) disciplina_educacao_fisica,
SAFE_CAST(disciplina_historia AS INT64) disciplina_historia,
SAFE_CAST(disciplina_geografia AS INT64) disciplina_geografia,
SAFE_CAST(disciplina_filosofia AS INT64) disciplina_filosofia,
SAFE_CAST(disciplina_ensino_religioso AS INT64) disciplina_ensino_religioso,
SAFE_CAST(disciplina_estudos_sociais AS INT64) disciplina_estudos_sociais,
SAFE_CAST(disciplina_sociologia AS INT64) disciplina_sociologia,
SAFE_CAST(disciplina_informatica_computacao AS INT64) disciplina_informatica_computacao,
SAFE_CAST(disciplina_profissionalizante AS INT64) disciplina_profissionalizante,
SAFE_CAST(disciplina_atendimento_especiais AS INT64) disciplina_atendimento_especiais,
SAFE_CAST(disciplina_diver_socio_cultural AS INT64) disciplina_diver_socio_cultural,
SAFE_CAST(disciplina_libras AS INT64) disciplina_libras,
SAFE_CAST(disciplina_pedagogicas AS INT64) disciplina_pedagogicas,
SAFE_CAST(disciplina_outras AS INT64) disciplina_outras,
SAFE_CAST(mantenedora_escola_privada_emp AS INT64) mantenedora_escola_privada_emp,
SAFE_CAST(mantenedora_escola_privada_ong AS INT64) mantenedora_escola_privada_ong,
SAFE_CAST(mantenedora_escola_privada_sind AS INT64) mantenedora_escola_privada_sind,
SAFE_CAST(mantenedora_escola_privada_sist_s AS INT64) mantenedora_escola_privada_sist_s,
SAFE_CAST(mantenedora_escola_privada_s_fins AS INT64) mantenedora_escola_privada_s_fins,
SAFE_CAST(tipo_regulamentacao AS INT64) tipo_regulamentacao,
SAFE_CAST(tipo_localizacao_diferenciada AS INT64) tipo_localizacao_diferenciada,
SAFE_CAST(educacao_indigena AS INT64) educacao_indigena,
SAFE_CAST(dia_semana_domingo AS INT64) dia_semana_domingo,
SAFE_CAST(dia_semana_segunda AS INT64) dia_semana_segunda,
SAFE_CAST(dia_semana_terca AS INT64) dia_semana_terca,
SAFE_CAST(dia_semana_quarta AS INT64) dia_semana_quarta,
SAFE_CAST(dia_semana_quinta AS INT64) dia_semana_quinta,
SAFE_CAST(dia_semana_sexta AS INT64) dia_semana_sexta,
SAFE_CAST(dia_semana_sabado AS INT64) dia_semana_sabado
from basedosdados-dev.br_inep_censo_escolar_staging.turma as t