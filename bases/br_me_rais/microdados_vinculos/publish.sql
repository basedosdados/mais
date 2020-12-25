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
CREATE VIEW basedosdados.br_me_rais.microdados_vinculos AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(id_municipio_6 AS INT64) id_municipio_6,
SAFE_CAST(tipo_vinculo AS INT64) tipo_vinculo,
SAFE_CAST(vinculo_ativo_3112 AS INT64) vinculo_ativo_3112,
SAFE_CAST(tipo_admissao AS INT64) tipo_admissao,
SAFE_CAST(mes_admissao AS INT64) mes_admissao,
SAFE_CAST(mes_desligamento AS INT64) mes_desligamento,
SAFE_CAST(motivo_desligamento AS INT64) motivo_desligamento,
SAFE_CAST(causa_desligamento_1 AS INT64) causa_desligamento_1,
SAFE_CAST(causa_desligamento_2 AS INT64) causa_desligamento_2,
SAFE_CAST(causa_desligamento_3 AS INT64) causa_desligamento_3,
SAFE_CAST(faixa_tempo_emprego AS INT64) faixa_tempo_emprego,
SAFE_CAST(tempo_emprego AS FLOAT64) tempo_emprego,
SAFE_CAST(faixa_horas_contratadas AS INT64) faixa_horas_contratadas,
SAFE_CAST(qtde_horas_contratadas AS INT64) qtde_horas_contratadas,
SAFE_CAST(id_municipio_6_trabalho AS INT64) id_municipio_6_trabalho,
SAFE_CAST(qtde_dias_afastamento AS INT64) qtde_dias_afastamento,
SAFE_CAST(indicador_cei_vinculado AS INT64) indicador_cei_vinculado,
SAFE_CAST(indicador_trabalho_parcial AS INT64) indicador_trabalho_parcial,
SAFE_CAST(indicador_trabalho_intermitente AS INT64) indicador_trabalho_intermitente,
SAFE_CAST(faixa_remun_media_sm AS INT64) faixa_remun_media_sm,
SAFE_CAST(valor_remun_media_sm AS FLOAT64) valor_remun_media_sm,
SAFE_CAST(valor_remun_media_nominal AS FLOAT64) valor_remun_media_nominal,
SAFE_CAST(faixa_remun_dezembro_sm AS INT64) faixa_remun_dezembro_sm,
SAFE_CAST(valor_remun_dezembro_sm AS FLOAT64) valor_remun_dezembro_sm,
SAFE_CAST(valor_remun_janeiro_nominal AS FLOAT64) valor_remun_janeiro_nominal,
SAFE_CAST(valor_remun_fevereiro_nominal AS FLOAT64) valor_remun_fevereiro_nominal,
SAFE_CAST(valor_remun_marco_nominal AS FLOAT64) valor_remun_marco_nominal,
SAFE_CAST(valor_remun_abril_nominal AS FLOAT64) valor_remun_abril_nominal,
SAFE_CAST(valor_remun_maio_nominal AS FLOAT64) valor_remun_maio_nominal,
SAFE_CAST(valor_remun_junho_nominal AS FLOAT64) valor_remun_junho_nominal,
SAFE_CAST(valor_remun_julho_nominal AS FLOAT64) valor_remun_julho_nominal,
SAFE_CAST(valor_remun_agosto_nominal AS FLOAT64) valor_remun_agosto_nominal,
SAFE_CAST(valor_remun_setembro_nominal AS FLOAT64) valor_remun_setembro_nominal,
SAFE_CAST(valor_remun_outubro_nominal AS FLOAT64) valor_remun_outubro_nominal,
SAFE_CAST(valor_remun_novembro_nominal AS FLOAT64) valor_remun_novembro_nominal,
SAFE_CAST(valor_remun_dezembro_nominal AS FLOAT64) valor_remun_dezembro_nominal,
SAFE_CAST(tipo_salario AS INT64) tipo_salario,
SAFE_CAST(valor_salario_contratual AS FLOAT64) valor_salario_contratual,
SAFE_CAST(subatividade_ibge AS STRING) subatividade_ibge,
SAFE_CAST(subsetor_ibge AS STRING) subsetor_ibge,
SAFE_CAST(cbo_1994 AS STRING) cbo_1994,
SAFE_CAST(cbo_2002 AS STRING) cbo_2002,
SAFE_CAST(cnae_1 AS STRING) cnae_1,
SAFE_CAST(cnae_2 AS STRING) cnae_2,
SAFE_CAST(cnae_2_subclasse AS STRING) cnae_2_subclasse,
SAFE_CAST(faixa_etaria AS INT64) faixa_etaria,
SAFE_CAST(idade AS INT64) idade,
SAFE_CAST(grau_instrucao_1985_2005 AS INT64) grau_instrucao_1985_2005,
SAFE_CAST(grau_instrucao_apos_2005 AS INT64) grau_instrucao_apos_2005,
SAFE_CAST(nacionalidade AS INT64) nacionalidade,
SAFE_CAST(sexo_trabalhador AS INT64) sexo_trabalhador,
SAFE_CAST(raca_cor AS INT64) raca_cor,
SAFE_CAST(indicador_portador_deficiencia AS INT64) indicador_portador_deficiencia,
SAFE_CAST(tipo_deficiencia AS INT64) tipo_deficiencia,
SAFE_CAST(ano_chegada_brasil AS INT64) ano_chegada_brasil,
SAFE_CAST(tamanho_estabelecimento AS INT64) tamanho_estabelecimento,
SAFE_CAST(tipo_estabelecimento AS STRING) tipo_estabelecimento,
SAFE_CAST(natureza_juridica AS INT64) natureza_juridica,
SAFE_CAST(indicador_simples AS INT64) indicador_simples,
SAFE_CAST(bairros_sp AS STRING) bairros_sp,
SAFE_CAST(distritos_sp AS STRING) distritos_sp,
SAFE_CAST(bairros_fortaleza AS STRING) bairros_fortaleza,
SAFE_CAST(bairros_rj AS STRING) bairros_rj,
SAFE_CAST(regioes_administrativas_df AS STRING) regioes_administrativas_df
from basedosdados-staging.br_me_rais_staging.microdados_vinculos as t