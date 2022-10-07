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

CREATE VIEW basedosdados-dev.br_bcb_sicor.microdados_operacao AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_referencia_bacen AS STRING) id_referencia_bacen,
SAFE_CAST(numero_ordem AS STRING) numero_ordem,
SAFE_CAST(id_categoria_emitente AS STRING) id_categoria_emitente,
SAFE_CAST(id_empreendimento AS STRING) id_empreendimento,
SAFE_CAST(id_fase_ciclo_producao AS STRING) id_fase_ciclo_producao,
SAFE_CAST(id_fonte_recurso AS STRING) id_fonte_recurso,
SAFE_CAST(id_instrumento_credito AS STRING) id_instrumento_credito,
SAFE_CAST(id_programa AS STRING) id_programa,
SAFE_CAST(id_referencia_bacen_investimento AS STRING) id_referencia_bacen_investimento,
SAFE_CAST(id_subprograma AS STRING) id_subprograma,
SAFE_CAST(id_tipo_agricultura AS STRING) id_tipo_agricultura,
SAFE_CAST(id_tipo_cultivo AS STRING) id_tipo_cultivo,
SAFE_CAST(id_tipo_encargo_financeiro AS STRING) id_tipo_encargo_financeiro,
SAFE_CAST(id_tipo_grao_semente AS STRING) id_tipo_grao_semente,
SAFE_CAST(id_tipo_integracao_consorcio AS STRING) id_tipo_integracao_consorcio,
SAFE_CAST(id_tipo_irrigacao AS STRING) id_tipo_irrigacao,
SAFE_CAST(id_tipo_seguro AS STRING) id_tipo_seguro,
SAFE_CAST(cnpj_agente_investimento AS STRING) cnpj_agente_investimento,
SAFE_CAST(cnpj_instituicao_financeira AS STRING) cnpj_instituicao_financeira,
SAFE_CAST(data_emissao AS DATE) data_emissao,
SAFE_CAST(data_vencimento AS DATE) data_vencimento,
SAFE_CAST(data_fim_colheita AS DATE) data_fim_colheita,
SAFE_CAST(data_fim_plantio AS DATE) data_fim_plantio,
SAFE_CAST(data_inicio_colheita AS DATE) data_inicio_colheita,
SAFE_CAST(data_inicio_plantio AS DATE) data_inicio_plantio,
SAFE_CAST(area_financiada AS FLOAT64) area_financiada,
SAFE_CAST(valor_aliquota_proagro AS FLOAT64) valor_aliquota_proagro,
SAFE_CAST(valor_parcela_credito AS FLOAT64) valor_parcela_credito,
SAFE_CAST(valor_prestacao_investimento AS FLOAT64) valor_prestacao_investimento,
SAFE_CAST(valor_recurso_proprio AS FLOAT64) valor_recurso_proprio,
SAFE_CAST(valor_receita_bruta_esperada AS FLOAT64) valor_receita_bruta_esperada,
SAFE_CAST(valor_recurso_proprio_srv AS FLOAT64) valor_recurso_proprio_srv,
SAFE_CAST(valor_quantidade_itens_financiados AS FLOAT64) valor_quantidade_itens_financiados,
SAFE_CAST(valor_produtividade_obtida AS FLOAT64) valor_produtividade_obtida,
SAFE_CAST(valor_previsao_producao AS FLOAT64) valor_previsao_producao,
SAFE_CAST(taxa_juro AS FLOAT64) taxa_juro,
SAFE_CAST(taxa_juro_encargo_financeiro_posfixado AS FLOAT64) taxa_juro_encargo_financeiro_posfixado,
SAFE_CAST(valor_percentual_risco_stn AS FLOAT64) valor_percentual_risco_stn,
SAFE_CAST(valor_percentual_custo_efetivo_total AS FLOAT64) valor_percentual_custo_efetivo_total,
SAFE_CAST(valor_percentual_risco_fundo_constitucional AS FLOAT64) valor_percentual_risco_fundo_constitucional,
SAFE_CAST(ano_safra_emissao AS INT64) ano_safra_emissao,
SAFE_CAST(ano_safra_vencimento AS INT64) ano_safra_vencimento
FROM basedosdados-dev.br_bcb_sicor_staging.microdados_operacao AS t