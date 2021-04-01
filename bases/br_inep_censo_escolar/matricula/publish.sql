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

CREATE VIEW basedosdados-dev.br_inep_censo_escolar.matricula AS
SELECT 
SAFE_CAST(id_matricula AS STRING) id_matricula,
SAFE_CAST(id_pessoa_fisica AS STRING) id_pessoa_fisica,
SAFE_CAST(dia_nascimento_aluno AS STRING) dia_nascimento_aluno,
SAFE_CAST(mes_nascimento_aluno AS STRING) mes_nascimento_aluno,
SAFE_CAST(ano_nascimento_aluno AS STRING) ano_nascimento_aluno,
SAFE_CAST(idade_referencia AS STRING) idade_referencia,
SAFE_CAST(idade AS STRING) idade,
SAFE_CAST(duracao_ativ_comp_mes_nascimento_alunoma_rede AS STRING) duracao_ativ_comp_mes_nascimento_alunoma_rede,
SAFE_CAST(duracao_ativ_comp_outras_redes AS STRING) duracao_ativ_comp_outras_redes,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(cor_raca AS STRING) cor_raca,
SAFE_CAST(nacionalidade AS STRING) nacionalidade,
SAFE_CAST(id_pais_origem AS STRING) id_pais_origem,
SAFE_CAST(id_uf_nasc AS STRING) id_uf_nasc,
SAFE_CAST(id_municipio_nasc AS STRING) id_municipio_nasc,
SAFE_CAST(id_uf_end AS STRING) id_uf_end,
SAFE_CAST(id_municipio_end AS STRING) id_municipio_end,
SAFE_CAST(zona_residencial AS STRING) zona_residencial,
SAFE_CAST(outro_local_aula AS STRING) outro_local_aula,
SAFE_CAST(transporte_publico AS STRING) transporte_publico,
SAFE_CAST(responsavel_transporte AS STRING) responsavel_transporte,
SAFE_CAST(transporte_vans_kombi AS STRING) transporte_vans_kombi,
SAFE_CAST(transporte_micro_onibus AS STRING) transporte_micro_onibus,
SAFE_CAST(transporte_onibus AS STRING) transporte_onibus,
SAFE_CAST(transporte_bicicleta AS STRING) transporte_bicicleta,
SAFE_CAST(transporte_tr_animal AS STRING) transporte_tr_animal,
SAFE_CAST(transporte_outro_veiculo AS STRING) transporte_outro_veiculo,
SAFE_CAST(transporte_embarcacao_ate5 AS STRING) transporte_embarcacao_ate5,
SAFE_CAST(transporte_embarcacao_5a15 AS STRING) transporte_embarcacao_5a15,
SAFE_CAST(transporte_embarcacao_15a35 AS STRING) transporte_embarcacao_15a35,
SAFE_CAST(transporte_embarcacao_35 AS STRING) transporte_embarcacao_35,
SAFE_CAST(transporte_trem_metro AS STRING) transporte_trem_metro,
SAFE_CAST(necessidade_especial AS STRING) necessidade_especial,
SAFE_CAST(cegueira AS STRING) cegueira,
SAFE_CAST(baixa_visao AS STRING) baixa_visao,
SAFE_CAST(surdez AS STRING) surdez,
SAFE_CAST(deficiencia_auditiva AS STRING) deficiencia_auditiva,
SAFE_CAST(surdocegueira AS STRING) surdocegueira,
SAFE_CAST(deficiencia_fisica AS STRING) deficiencia_fisica,
SAFE_CAST(deficiencia_intelectual AS STRING) deficiencia_intelectual,
SAFE_CAST(deficiencia_multipla AS STRING) deficiencia_multipla,
SAFE_CAST(autismo AS STRING) autismo,
SAFE_CAST(sindrome_asperger AS STRING) sindrome_asperger,
SAFE_CAST(sindrome_rett AS STRING) sindrome_rett,
SAFE_CAST(transtorno_di AS STRING) transtorno_di,
SAFE_CAST(superdotacao AS STRING) superdotacao,
SAFE_CAST(recurso_ledor AS STRING) recurso_ledor,
SAFE_CAST(recurso_transcricao AS STRING) recurso_transcricao,
SAFE_CAST(recurso_interprete AS STRING) recurso_interprete,
SAFE_CAST(recurso_libras AS STRING) recurso_libras,
SAFE_CAST(recurso_labial AS STRING) recurso_labial,
SAFE_CAST(recurso_braille AS STRING) recurso_braille,
SAFE_CAST(recurso_ampliada_16 AS STRING) recurso_ampliada_16,
SAFE_CAST(recurso_ampliada_20 AS STRING) recurso_ampliada_20,
SAFE_CAST(recurso_ampliada_24 AS STRING) recurso_ampliada_24,
SAFE_CAST(recurso_nenhum AS STRING) recurso_nenhum,
SAFE_CAST(ingresso_federais AS STRING) ingresso_federais,
SAFE_CAST(etapa_ensino AS STRING) etapa_ensino,
SAFE_CAST(id_turma AS STRING) id_turma,
SAFE_CAST(id_curso_educ_profissional AS STRING) id_curso_educ_profissional,
SAFE_CAST(unificada AS STRING) unificada,
SAFE_CAST(tipo_turma AS STRING) tipo_turma,
SAFE_CAST(id_entidade AS STRING) id_entidade,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_uf AS STRING) id_uf,
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf
from basedosdados-dev.br_inep_censo_escolar_staging.matricula as t