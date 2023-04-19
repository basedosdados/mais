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

CREATE VIEW basedosdados-dev.br_me_caged.microdados_movimentacao_excluida AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(cnae_2_secao AS STRING) cnae_2_secao,
SAFE_CAST(cnae_2_subclasse AS STRING) cnae_2_subclasse,
SAFE_CAST(cbo_2002 AS STRING) cbo_2002,
SAFE_CAST(saldo_movimentacao AS INT64) saldo_movimentacao,
SAFE_CAST(categoria AS STRING) categoria,
SAFE_CAST(grau_instrucao AS STRING) grau_instrucao,
SAFE_CAST(REPLACE(idade,'.0','') AS INT64) idade,
SAFE_CAST(REPLACE(horas_contratuais,',00','') AS INT64) horas_contratuais,
SAFE_CAST(raca_cor AS STRING) raca_cor,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(REPLACE(salario_mensal,',','.') AS FLOAT64) salario_mensal,
SAFE_CAST(tipo_empregador AS STRING) tipo_empregador,
SAFE_CAST(tipo_estabelecimento AS STRING) tipo_estabelecimento,
SAFE_CAST(tipo_movimentacao AS STRING) tipo_movimentacao,
SAFE_CAST(tipo_deficiencia AS STRING) tipo_deficiencia,
SAFE_CAST(indicador_trabalho_intermitente AS STRING) indicador_trabalho_intermitente,
SAFE_CAST(indicador_trabalho_parcial AS STRING) indicador_trabalho_parcial,
SAFE_CAST(tamanho_estabelecimento_janeiro AS STRING) tamanho_estabelecimento_janeiro,
SAFE_CAST(indicador_aprendiz AS STRING) indicador_aprendiz,
SAFE_CAST(origem_informacao AS STRING) origem_informacao,
SAFE_CAST(indicador_fora_prazo AS INT64) indicador_fora_prazo
FROM basedosdados-dev.br_me_caged_staging.microdados_movimentacao_excluida AS t