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

CREATE VIEW basedosdados-dev.br_cgu_servidores_remuneracao.microdados_militar_reservista AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(id_servidor_portal AS STRING) id_servidor_portal,
SAFE_CAST(cpf AS STRING) cpf,
SAFE_CAST(nome AS STRING) nome,
SAFE_CAST(remuneracao_bruta_brl AS FLOAT64) remuneracao_bruta_brl,
SAFE_CAST(remuneracao_bruta_usd AS FLOAT64) remuneracao_bruta_usd,
SAFE_CAST(abate_teto_brl AS FLOAT64) abate_teto_brl,
SAFE_CAST(abate_teto_usd AS FLOAT64) abate_teto_usd,
SAFE_CAST(gratificao_natalina_brl AS FLOAT64) gratificao_natalina_brl,
SAFE_CAST(gratificao_natalina_usd AS FLOAT64) gratificao_natalina_usd,
SAFE_CAST(abate_teto_gratificacao_natalina_brl AS FLOAT64) abate_teto_gratificacao_natalina_brl,
SAFE_CAST(abate_teto_gratificacao_natalina_usd AS FLOAT64) abate_teto_gratificacao_natalina_usd,
SAFE_CAST(ferias_brl AS FLOAT64) ferias_brl,
SAFE_CAST(ferias_usd AS FLOAT64) ferias_usd,
SAFE_CAST(outras_remuneracoes_brl AS FLOAT64) outras_remuneracoes_brl,
SAFE_CAST(outras_remuneracoes_usd AS FLOAT64) outras_remuneracoes_usd,
SAFE_CAST(irrf_brl AS FLOAT64) irrf_brl,
SAFE_CAST(irrf_usd AS FLOAT64) irrf_usd,
SAFE_CAST(pss_rgps_brl AS FLOAT64) pss_rgps_brl,
SAFE_CAST(pss_rgps_usd AS FLOAT64) pss_rgps_usd,
SAFE_CAST(demais_deducoes_brl AS FLOAT64) demais_deducoes_brl,
SAFE_CAST(demais_deducoes_usd AS FLOAT64) demais_deducoes_usd,
SAFE_CAST(pensao_militar_brl AS FLOAT64) pensao_militar_brl,
SAFE_CAST(pensao_militar_usd AS FLOAT64) pensao_militar_usd,
SAFE_CAST(fundo_saude_brl AS FLOAT64) fundo_saude_brl,
SAFE_CAST(fundo_saude_usd AS FLOAT64) fundo_saude_usd,
SAFE_CAST(taxa_ocupacao_imovel_funcional_brl AS FLOAT64) taxa_ocupacao_imovel_funcional_brl,
SAFE_CAST(taxa_ocupacao_imovel_funcional_usd AS FLOAT64) taxa_ocupacao_imovel_funcional_usd,
SAFE_CAST(remuneracao_liquida_militar_brl AS FLOAT64) remuneracao_liquida_militar_brl,
SAFE_CAST(remuneracao_liquida_militar_usd AS FLOAT64) remuneracao_liquida_militar_usd,
SAFE_CAST(verba_indenizatoria_civil_brl AS FLOAT64) verba_indenizatoria_civil_brl,
SAFE_CAST(verba_indenizatoria_civil_usd AS FLOAT64) verba_indenizatoria_civil_usd,
SAFE_CAST(verba_indenizatoria_militar_brl AS FLOAT64) verba_indenizatoria_militar_brl,
SAFE_CAST(verba_indenizatoria_militar_usd AS FLOAT64) verba_indenizatoria_militar_usd,
SAFE_CAST(verba_indenizatoria_deslig_voluntario_brl AS FLOAT64) verba_indenizatoria_deslig_voluntario_brl,
SAFE_CAST(verba_indenizatoria_deslig_voluntario_usd AS FLOAT64) verba_indenizatoria_deslig_voluntario_usd,
SAFE_CAST(total_verba_indenizatoria_brl AS FLOAT64) total_verba_indenizatoria_brl,
SAFE_CAST(total_verba_indenizatoria_usd AS FLOAT64) total_verba_indenizatoria_usd
FROM basedosdados-dev.br_cgu_servidores_remuneracao_staging.microdados_militar_reservista AS t