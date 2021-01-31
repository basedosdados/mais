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

CREATE VIEW basedosdados.br_me_caged.microdados_novo_caged_movimentacoes AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(id_municipio_6 AS INT64) id_municipio_6,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(cnae_20_classe AS STRING) cnae_20_classe,
SAFE_CAST(cnae_20_subclas AS INT64) cnae_20_subclas,
SAFE_CAST(saldo_mov AS INT64) saldo_mov,
SAFE_CAST(cbo_2002_ocupacao AS INT64) cbo_2002_ocupacao,
SAFE_CAST(categoria_trabalhador AS INT64) categoria_trabalhador,
SAFE_CAST(grau_instrucao AS INT64) grau_instrucao,
SAFE_CAST(idade AS INT64) idade,
SAFE_CAST(qtd_hora_contrat AS INT64) qtd_hora_contrat,
SAFE_CAST(raca_cor AS INT64) raca_cor,
SAFE_CAST(sexo AS INT64) sexo,
SAFE_CAST(tipo_empregador AS INT64) tipo_empregador,
SAFE_CAST(tipo_estab AS INT64) tipo_estab,
SAFE_CAST(tipo_movimentacao AS INT64) tipo_movimentacao,
SAFE_CAST(tipo_defic AS INT64) tipo_defic,
SAFE_CAST(ind_trab_intermitente AS INT64) ind_trab_intermitente,
SAFE_CAST(ind_trab_parcial AS INT64) ind_trab_parcial,
SAFE_CAST(salario_mensal AS STRING) salario_mensal,
SAFE_CAST(faixa_empr_inicio_jan AS FLOAT64) faixa_empr_inicio_jan,
SAFE_CAST(ind_aprendiz AS INT64) ind_aprendiz,
SAFE_CAST(fonte_movimentacao AS INT64) fonte_movimentacao
from basedosdados-staging.br_me_caged_staging.microdados_novo_caged_movimentacoes as t
