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

CREATE VIEW basedosdados-dev.br_capes_bolsas.mobilidade_internacional AS
SELECT 
SAFE_CAST(ano_inicial AS INT64) ano_inicial,
SAFE_CAST(mes_inicial AS INT64 ) mes_inicial,
SAFE_CAST(ano_final AS INT64 ) ano_final,
SAFE_CAST(mes_final AS INT64 ) mes_final,
SAFE_CAST(id_processo_concessao AS STRING) id_processo_concessao,
SAFE_CAST(cpf AS STRING) cpf,
SAFE_CAST(beneficiario AS STRING) beneficiario,
SAFE_CAST(programa_capes AS STRING) programa_capes,
SAFE_CAST(pais_destino AS STRING) pais_destino,
SAFE_CAST(sigla_moeda AS STRING) sigla_moeda,
SAFE_CAST(area_avaliacao AS STRING) area_avaliacao,
SAFE_CAST(area_conhecimento AS STRING) area_conhecimento,
SAFE_CAST(grande_area_conhecimento AS STRING) grande_area_conhecimento,
SAFE_CAST(nivel_ensino AS STRING) nivel_ensino,
SAFE_CAST(uf_instituicao_origem AS STRING) uf_instituicao_origem,
SAFE_CAST(instituicao_ensino_origem AS STRING) instituicao_ensino_origem,
SAFE_CAST(instituicao_ensino_principal AS STRING) instituicao_ensino_principal,
SAFE_CAST(instituicao_ensino AS STRING) instituicao_ensino,
SAFE_CAST(deducao_mensalidade_programa_atracao_jovens AS FLOAT64) deducao_mensalidade_programa_atracao_jovens,
SAFE_CAST(valor_adicional_pagos_doutorado_pleno_dependentes AS FLOAT64) valor_adicional_pagos_doutorado_pleno_dependentes,
SAFE_CAST(valor_auxilio_deslocamento AS FLOAT64) valor_auxilio_deslocamento,
SAFE_CAST(valor_auxilio_deslocamento_demanda AS FLOAT64) valor_auxilio_deslocamento_demanda,
SAFE_CAST(valor_auxilio_deslocamento_pesquisa AS FLOAT64) valor_auxilio_deslocamento_pesquisa,
SAFE_CAST(valor_auxilio_deslocamento_retorno AS FLOAT64) valor_auxilio_deslocamento_retorno,
SAFE_CAST(valor_auxilio_despesas_instalacao AS FLOAT64) valor_auxilio_despesas_instalacao,
SAFE_CAST(valor_auxilio_instalacao_dependente AS FLOAT64) valor_auxilio_instalacao_dependente,
SAFE_CAST(valor_auxilio_instalacao AS FLOAT64) valor_auxilio_instalacao,
SAFE_CAST(valor_auxilio_seguro_saude_anual AS FLOAT64) valor_auxilio_seguro_saude_anual,
SAFE_CAST(valor_auxilio_seguro_saude_capes_setec AS FLOAT64) valor_auxilio_seguro_saude_capes_setec,
SAFE_CAST(valor_auxilio_seguro_saude_demanda AS FLOAT64) valor_auxilio_seguro_saude_demanda,
SAFE_CAST(valor_auxilio_seguro_saude_dependente AS FLOAT64) valor_auxilio_seguro_saude_dependente,
SAFE_CAST(valor_auxilio_seguro_saude AS FLOAT64) valor_auxilio_seguro_saude,
SAFE_CAST(valor_auxilio_moradia AS FLOAT64) valor_auxilio_moradia,
SAFE_CAST(valor_auxilio_material_didatico AS FLOAT64) valor_auxilio_material_didatico,
SAFE_CAST(valor_recebido_bolsa AS FLOAT64) valor_recebido_bolsa,
SAFE_CAST(valor_recebido_adicional_localidade AS FLOAT64) valor_recebido_adicional_localidade,
SAFE_CAST(valor_recebido_ajuda_custo AS FLOAT64) valor_recebido_ajuda_custo,
SAFE_CAST(valor_recebido_ajuda_custo_capes_mtur AS FLOAT64) valor_recebido_ajuda_custo_capes_mtur,
SAFE_CAST(valor_recebido_ajuda_custo_capes_setec AS FLOAT64) valor_recebido_ajuda_custo_capes_setec,
SAFE_CAST(valor_recebido_custeio_taxas_escolares_menores AS FLOAT64) valor_recebido_custeio_taxas_escolares_menores,
SAFE_CAST(valor_recebido_reembolso_taxas_escolares AS FLOAT64) valor_recebido_reembolso_taxas_escolares,
SAFE_CAST(valor_recebido_custeio_taxas_escolares AS FLOAT64) valor_recebido_custeio_taxas_escolares,
SAFE_CAST(valor_recebido_despesas_adicional_dependente AS FLOAT64) valor_recebido_despesas_adicional_dependente,
SAFE_CAST(valor_recebido_despesas_auxilio_deslocamento AS FLOAT64) valor_recebido_despesas_auxilio_deslocamento,
SAFE_CAST(valor_recebido_despesas_extraordinarias AS FLOAT64) valor_recebido_despesas_extraordinarias,
SAFE_CAST(valor_recebido_despesas_mensalidade AS FLOAT64) valor_recebido_despesas_mensalidade,
SAFE_CAST(valor_recebido_despesas_seguro_saude AS FLOAT64) valor_recebido_despesas_seguro_saude,
SAFE_CAST(valor_recebido_seguro_saude AS FLOAT64) valor_recebido_seguro_saude,
SAFE_CAST(valor_recebido_diarias AS FLOAT64) valor_recebido_diarias,
SAFE_CAST(valor_recebido_escola_altos_estudos AS FLOAT64) valor_recebido_escola_altos_estudos,
SAFE_CAST(valor_recebido_licenca_maternidade AS FLOAT64) valor_recebido_licenca_maternidade,
SAFE_CAST(valor_recebido_mensalidade AS FLOAT64) valor_recebido_mensalidade,
SAFE_CAST(valor_recebido_mensalidade_agendadas AS FLOAT64) valor_recebido_mensalidade_agendadas,
SAFE_CAST(valor_recebido_mensalidade_demanda AS FLOAT64) valor_recebido_mensalidade_demanda,
SAFE_CAST(valor_recebido_outros_debitos AS FLOAT64) valor_recebido_outros_debitos,
SAFE_CAST(valor_recebido_passagem_aerea AS FLOAT64) valor_recebido_passagem_aerea,
SAFE_CAST(valor_recebido_capital AS FLOAT64) valor_recebido_capital,
SAFE_CAST(valor_recebido_total AS FLOAT64) valor_recebido_total
FROM basedosdados-dev.br_capes_bolsas_staging.mobilidade_internacional AS t