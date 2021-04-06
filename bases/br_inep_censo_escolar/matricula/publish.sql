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
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(id_escola AS INT64) id_escola,
SAFE_CAST(etapa_ensino AS INT64) etapa_ensino,
SAFE_CAST(id_turma AS INT64) id_turma,
SAFE_CAST(tipo_turma AS INT64) tipo_turma,
SAFE_CAST(id_matricula AS INT64) id_matricula,
SAFE_CAST(id_pessoa_fisica AS INT64) id_pessoa_fisica,
SAFE_CAST(dia_nascimento AS INT64) dia_nascimento,
SAFE_CAST(mes_nascimento AS INT64) mes_nascimento,
SAFE_CAST(ano_nascimento AS INT64) ano_nascimento,
SAFE_CAST(idade_referencia AS INT64) idade_referencia,
SAFE_CAST(idade AS INT64) idade,
SAFE_CAST(duracao_ativ_comp_mesma_rede AS INT64) duracao_ativ_comp_mesma_rede,
SAFE_CAST(duracao_ativ_comp_outras_redes AS INT64) duracao_ativ_comp_outras_redes,
SAFE_CAST(sexo AS INT64) sexo,
SAFE_CAST(cor_raca AS INT64) raca_cor,
SAFE_CAST(nacionalidade AS INT64) nacionalidade,
SAFE_CAST(id_pais_origem AS INT64) id_pais_origem,
SAFE_CAST(id_uf_nascimento AS INT64) id_uf_nascimento,
SAFE_CAST(id_municipio_nascimento AS INT64) id_municipio_nascimento,
SAFE_CAST(id_uf_endereco AS INT64) id_uf_endereco,
SAFE_CAST(id_municipio_endereco AS INT64) id_municipio_endereco,
SAFE_CAST(zona_residencial AS INT64) zona_residencial,
SAFE_CAST(outro_local_aula AS INT64) outro_local_aula,
SAFE_CAST(transporte_publico AS INT64) transporte_publico,
SAFE_CAST(responsavel_transporte AS INT64) responsavel_transporte,
SAFE_CAST(transporte_vans_kombi AS INT64) transporte_vans_kombi,
SAFE_CAST(transporte_micro_onibus AS INT64) transporte_micro_onibus,
SAFE_CAST(transporte_onibus AS INT64) transporte_onibus,
SAFE_CAST(transporte_bicicleta AS INT64) transporte_bicicleta,
SAFE_CAST(transporte_tr_animal AS INT64) transporte_tr_animal,
SAFE_CAST(transporte_outro_veiculo AS INT64) transporte_outro_veiculo,
SAFE_CAST(transporte_embarcacao_ate5 AS INT64) transporte_embarcacao_ate5,
SAFE_CAST(transporte_embarcacao_5a15 AS INT64) transporte_embarcacao_5a15,
SAFE_CAST(transporte_embarcacao_15a35 AS INT64) transporte_embarcacao_15a35,
SAFE_CAST(transporte_embarcacao_35 AS INT64) transporte_embarcacao_35,
SAFE_CAST(transporte_trem_metro AS INT64) transporte_trem_metro,
SAFE_CAST(necessidade_especial AS INT64) necessidade_especial,
SAFE_CAST(cegueira AS INT64) cegueira,
SAFE_CAST(baixa_visao AS INT64) baixa_visao,
SAFE_CAST(surdez AS INT64) surdez,
SAFE_CAST(deficiencia_auditiva AS INT64) deficiencia_auditiva,
SAFE_CAST(surdocegueira AS INT64) surdocegueira,
SAFE_CAST(deficiencia_fisica AS INT64) deficiencia_fisica,
SAFE_CAST(deficiencia_intelectual AS INT64) deficiencia_intelectual,
SAFE_CAST(deficiencia_multipla AS INT64) deficiencia_multipla,
SAFE_CAST(autismo AS INT64) autismo,
SAFE_CAST(sindrome_asperger AS INT64) sindrome_asperger,
SAFE_CAST(sindrome_rett AS INT64) sindrome_rett,
SAFE_CAST(transtorno_di AS INT64) transtorno_di,
SAFE_CAST(superdotacao AS INT64) superdotacao,
SAFE_CAST(recurso_ledor AS INT64) recurso_ledor,
SAFE_CAST(recurso_transcricao AS INT64) recurso_transcricao,
SAFE_CAST(recurso_interprete AS INT64) recurso_interprete,
SAFE_CAST(recurso_libras AS INT64) recurso_libras,
SAFE_CAST(recurso_labial AS INT64) recurso_labial,
SAFE_CAST(recurso_braille AS INT64) recurso_braille,
SAFE_CAST(recurso_ampliada_16 AS INT64) recurso_ampliada_16,
SAFE_CAST(recurso_ampliada_20 AS INT64) recurso_ampliada_20,
SAFE_CAST(recurso_ampliada_24 AS INT64) recurso_ampliada_24,
SAFE_CAST(recurso_nenhum AS INT64) recurso_nenhum,
SAFE_CAST(ingresso_federais AS INT64) ingresso_federais,
SAFE_CAST(id_curso_educ_profissional AS INT64) id_curso_educ_profissional,
SAFE_CAST(unificada AS INT64) unificada
from basedosdados-dev.br_inep_censo_escolar_staging.matricula as t