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

CREATE VIEW basedosdados-dev.br_me_clima_organizacional.microdados AS
SELECT 
SAFE_CAST(classe AS STRING) classe,
SAFE_CAST(subclasse AS STRING) subclasse,
SAFE_CAST(area_empresa AS STRING) area_empresa,
SAFE_CAST(quantidade_resposta AS FLOAT64) quantidade_resposta,
SAFE_CAST(media_geral AS FLOAT64) media_geral,
SAFE_CAST(credibilidade AS FLOAT64) credibilidade,
SAFE_CAST(respeito AS FLOAT64) respeito,
SAFE_CAST(imparcialidade AS FLOAT64) imparcialidade,
SAFE_CAST(orgulho AS FLOAT64) orgulho,
SAFE_CAST(camaradagem AS FLOAT64) camaradagem,
SAFE_CAST(gestao AS FLOAT64) gestao,
SAFE_CAST(adicionais AS FLOAT64) adicionais,
SAFE_CAST(gestor_atualizacao_informacao AS FLOAT64) gestor_atualizacao_informacao,
SAFE_CAST(gestor_expectativa_clara AS FLOAT64) gestor_expectativa_clara,
SAFE_CAST(gestor_resposta_direta AS FLOAT64) gestor_resposta_direta,
SAFE_CAST(gestor_facil_proximidade AS FLOAT64) gestor_facil_proximidade,
SAFE_CAST(gestor_competente AS FLOAT64) gestor_competente,
SAFE_CAST(gestor_boa_selecao AS FLOAT64) gestor_boa_selecao,
SAFE_CAST(gestor_coordenacao_tarefa AS FLOAT64) gestor_coordenacao_tarefa,
SAFE_CAST(gestor_confianca_trabalho AS FLOAT64) gestor_confianca_trabalho,
SAFE_CAST(gestor_autonomia AS FLOAT64) gestor_autonomia,
SAFE_CAST(gestor_visao_clara AS FLOAT64) gestor_visao_clara,
SAFE_CAST(gestor_cumprimento_promessa AS FLOAT64) gestor_cumprimento_promessa,
SAFE_CAST(gestor_coerencia_acao AS FLOAT64) gestor_coerencia_acao,
SAFE_CAST(gestor_honestidade_etica AS FLOAT64) gestor_honestidade_etica,
SAFE_CAST(oferta_desenvolvimento_profissional AS FLOAT64) oferta_desenvolvimento_profissional,
SAFE_CAST(equipamento_necessario_fornecido AS FLOAT64) equipamento_necessario_fornecido,
SAFE_CAST(gestor_agradecimento AS FLOAT64) gestor_agradecimento,
SAFE_CAST(gestor_compreensao_erro AS FLOAT64) gestor_compreensao_erro,
SAFE_CAST(gestor_incentivo_ideia AS FLOAT64) gestor_incentivo_ideia,
SAFE_CAST(gestor_envolvimento_decisao AS FLOAT64) gestor_envolvimento_decisao,
SAFE_CAST(ambiente_fisicamente_seguro AS FLOAT64) ambiente_fisicamente_seguro,
SAFE_CAST(ambiente_psicologicamente_saudavel AS FLOAT64) ambiente_psicologicamente_saudavel,
SAFE_CAST(instalacao_bom_ambiente AS FLOAT64) instalacao_bom_ambiente,
SAFE_CAST(possibilidade_ausentar AS FLOAT64) possibilidade_ausentar,
SAFE_CAST(equilibrio_profissional_pessoal AS FLOAT64) equilibrio_profissional_pessoal,
SAFE_CAST(gestor_interesse_pessoal AS FLOAT64) gestor_interesse_pessoal,
SAFE_CAST(beneficio_diferenciado AS FLOAT64) beneficio_diferenciado,
SAFE_CAST(remuneracao_adequada AS FLOAT64) remuneracao_adequada,
SAFE_CAST(oportunidade_reconhecimento AS FLOAT64) oportunidade_reconhecimento,
SAFE_CAST(importancia_posicao_neutra AS FLOAT64) importancia_posicao_neutra,
SAFE_CAST(promocao_merito AS FLOAT64) promocao_merito,
SAFE_CAST(gestor_sem_favoritismo AS FLOAT64) gestor_sem_favoritismo,
SAFE_CAST(evitar_intriga AS FLOAT64) evitar_intriga,
SAFE_CAST(tratada_bem_idade AS FLOAT64) tratada_bem_idade,
SAFE_CAST(tratada_bem_etnia_raca AS FLOAT64) tratada_bem_etnia_raca,
SAFE_CAST(tratada_bem_genero AS FLOAT64) tratada_bem_genero,
SAFE_CAST(tratada_bem_orientacao_sexual AS FLOAT64) tratada_bem_orientacao_sexual,
SAFE_CAST(ser_ouvido_efetivamente AS FLOAT64) ser_ouvido_efetivamente,
SAFE_CAST(disposicao_trabalho AS FLOAT64) disposicao_trabalho,
SAFE_CAST(continuar_trabalho AS FLOAT64) continuar_trabalho,
SAFE_CAST(vontade_trabalho AS FLOAT64) vontade_trabalho,
SAFE_CAST(realizacao_contribuicao_comunidade AS FLOAT64) realizacao_contribuicao_comunidade,
SAFE_CAST(liberdade_ser AS FLOAT64) liberdade_ser,
SAFE_CAST(outra_pessoa_importa AS FLOAT64) outra_pessoa_importa,
SAFE_CAST(ambiente_descontraido AS FLOAT64) ambiente_descontraido,
SAFE_CAST(acolhimento_entrada AS FLOAT64) acolhimento_entrada,
SAFE_CAST(acolhimento_mudanca_funcao AS FLOAT64) acolhimento_mudanca_funcao,
SAFE_CAST(sentimento_equipe AS FLOAT64) sentimento_equipe,
SAFE_CAST(grupo_colaborativo AS FLOAT64) grupo_colaborativo,
SAFE_CAST(ambiente_excelente_trabalho AS FLOAT64) ambiente_excelente_trabalho,
SAFE_CAST(gestor_representa_orgao AS FLOAT64) gestor_representa_orgao,
SAFE_CAST(valoriza_inovacao AS FLOAT64) valoriza_inovacao,
SAFE_CAST(adaptacao_rapida_mudanca AS FLOAT64) adaptacao_rapida_mudanca,
SAFE_CAST(recomendacao_trabalho_orgao AS FLOAT64) recomendacao_trabalho_orgao,
SAFE_CAST(produto_classificado_excelente AS FLOAT64) produto_classificado_excelente,
SAFE_CAST(entrega_alta_qualidade AS FLOAT64) entrega_alta_qualidade,
SAFE_CAST(tratada_bem_deficiencia AS FLOAT64) tratada_bem_deficiencia,
SAFE_CAST(trabalho_satisfacao_geral AS FLOAT64) trabalho_satisfacao_geral,
SAFE_CAST(trabalho_inspira AS FLOAT64) trabalho_inspira,
SAFE_CAST(trabalho_realizacao AS FLOAT64) trabalho_realizacao,
SAFE_CAST(conexao_pessoal_orgao AS FLOAT64) conexao_pessoal_orgao,
SAFE_CAST(identificacao_missao_orgao AS FLOAT64) identificacao_missao_orgao,
SAFE_CAST(contribuicao_bem_comum AS FLOAT64) contribuicao_bem_comum,
SAFE_CAST(orgao_preocupacao_acessibilidade AS FLOAT64) orgao_preocupacao_acessibilidade,
SAFE_CAST(entidade_representativa AS FLOAT64) entidade_representativa,
SAFE_CAST(clareza_competencia_geral AS FLOAT64) clareza_competencia_geral,
SAFE_CAST(avaliacao_desempenho_justa AS FLOAT64) avaliacao_desempenho_justa
FROM basedosdados-dev.br_me_clima_organizacional_staging.microdados AS t