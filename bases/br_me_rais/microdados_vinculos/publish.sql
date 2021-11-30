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

CREATE VIEW basedosdados-dev.br_me_rais.microdados_vinculos AS
SELECT 
SAFE_CAST(ano AS int64) ano,
SAFE_CAST(sigla_uf AS string) sigla_uf,
SAFE_CAST(id_municipio AS string) id_municipio,
SAFE_CAST(tipo_vinculo AS string) tipo_vinculo,
SAFE_CAST(vinculo_ativo_3112 AS int64) vinculo_ativo_3112,
SAFE_CAST(tipo_admissao AS string) tipo_admissao,
SAFE_CAST(mes_admissao AS int64) mes_admissao,
SAFE_CAST(mes_desligamento AS int64) mes_desligamento,
SAFE_CAST(motivo_desligamento AS string) motivo_desligamento,
SAFE_CAST(causa_desligamento_1 AS string) causa_desligamento_1,
SAFE_CAST(causa_desligamento_2 AS string) causa_desligamento_2,
SAFE_CAST(causa_desligamento_3 AS string) causa_desligamento_3,
SAFE_CAST(faixa_tempo_emprego AS string) faixa_tempo_emprego,
SAFE_CAST(tempo_emprego AS float64) tempo_emprego,
SAFE_CAST(faixa_horas_contratadas AS string) faixa_horas_contratadas,
SAFE_CAST(quantidade_horas_contratadas AS int64) quantidade_horas_contratadas,
SAFE_CAST(id_municipio_6_trabalho AS string) id_municipio_6_trabalho,
SAFE_CAST(quantidade_dias_afastamento AS int64) quantidade_dias_afastamento,
SAFE_CAST(indicador_cei_vinculado AS int64) indicador_cei_vinculado,
SAFE_CAST(indicador_trabalho_parcial AS int64) indicador_trabalho_parcial,
SAFE_CAST(indicador_trabalho_intermitente AS int64) indicador_trabalho_intermitente,
SAFE_CAST(faixa_remuneracao_media_sm AS string) faixa_remuneracao_media_sm,
SAFE_CAST(valor_remuneracao_media_sm AS float64) valor_remuneracao_media_sm,
SAFE_CAST(valor_remuneracao_media_nominal AS float64) valor_remuneracao_media_nominal,
SAFE_CAST(faixa_remuneracao_dezembro_sm AS string) faixa_remuneracao_dezembro_sm,
SAFE_CAST(valor_remuneracao_dezembro_sm AS float64) valor_remuneracao_dezembro_sm,
SAFE_CAST(valor_remuneracao_janeiro_nominal AS float64) valor_remuneracao_janeiro_nominal,
SAFE_CAST(valor_remuneracao_fevereiro_nominal AS float64) valor_remuneracao_fevereiro_nominal,
SAFE_CAST(valor_remuneracao_marco_nominal AS float64) valor_remuneracao_marco_nominal,
SAFE_CAST(valor_remuneracao_abril_nominal AS float64) valor_remuneracao_abril_nominal,
SAFE_CAST(valor_remuneracao_maio_nominal AS float64) valor_remuneracao_maio_nominal,
SAFE_CAST(valor_remuneracao_junho_nominal AS float64) valor_remuneracao_junho_nominal,
SAFE_CAST(valor_remuneracao_julho_nominal AS float64) valor_remuneracao_julho_nominal,
SAFE_CAST(valor_remuneracao_agosto_nominal AS float64) valor_remuneracao_agosto_nominal,
SAFE_CAST(valor_remuneracao_setembro_nominal AS float64) valor_remuneracao_setembro_nominal,
SAFE_CAST(valor_remuneracao_outubro_nominal AS float64) valor_remuneracao_outubro_nominal,
SAFE_CAST(valor_remuneracao_novembro_nominal AS float64) valor_remuneracao_novembro_nominal,
SAFE_CAST(valor_remuneracao_dezembro_nominal AS float64) valor_remuneracao_dezembro_nominal,
SAFE_CAST(tipo_salario AS string) tipo_salario,
SAFE_CAST(valor_salario_contratual AS float64) valor_salario_contratual,
SAFE_CAST(subatividade_ibge AS string) subatividade_ibge,
SAFE_CAST(subsetor_ibge AS string) subsetor_ibge,
SAFE_CAST(cbo_1994 AS string) cbo_1994,
SAFE_CAST(cbo_2002 AS string) cbo_2002,
SAFE_CAST(cnae_1 AS string) cnae_1,
SAFE_CAST(cnae_2 AS string) cnae_2,
SAFE_CAST(cnae_2_subclasse AS string) cnae_2_subclasse,
SAFE_CAST(faixa_etaria AS string) faixa_etaria,
SAFE_CAST(idade AS int64) idade,
SAFE_CAST(grau_instrucao_1985_2005 AS string) grau_instrucao_1985_2005,
SAFE_CAST(grau_instrucao_apos_2005 AS string) grau_instrucao_apos_2005,
SAFE_CAST(nacionalidade AS string) nacionalidade,
SAFE_CAST(sexo AS string) sexo,
SAFE_CAST(raca_cor AS string) raca_cor,
SAFE_CAST(indicador_portador_deficiencia AS int64) indicador_portador_deficiencia,
SAFE_CAST(tipo_deficiencia AS string) tipo_deficiencia,
SAFE_CAST(ano_chegada_brasil AS int64) ano_chegada_brasil,
SAFE_CAST(tamanho_estabelecimento AS string) tamanho_estabelecimento,
SAFE_CAST(tipo_estabelecimento AS string) tipo_estabelecimento,
SAFE_CAST(natureza_juridica AS string) natureza_juridica,
SAFE_CAST(indicador_simples AS int64) indicador_simples,
SAFE_CAST(bairros_sp AS string) bairros_sp,
SAFE_CAST(distritos_sp AS string) distritos_sp,
SAFE_CAST(bairros_fortaleza AS string) bairros_fortaleza,
SAFE_CAST(bairros_rj AS string) bairros_rj,
SAFE_CAST(regioes_administrativas_df AS string) regioes_administrativas_df
FROM basedosdados-dev.br_me_rais_staging.microdados_vinculos AS t