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

CREATE VIEW basedosdados-dev.br_ibge_pnad.microdados_compatibilizados_pessoa AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(id_uf AS STRING) id_uf,
SAFE_CAST(id_regiao AS STRING) id_regiao,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_regiao_metropolitana AS STRING) id_regiao_metropolitana,
SAFE_CAST(id_domicilio AS STRING) id_domicilio,
SAFE_CAST(numero_familia AS INT64) numero_familia,
SAFE_CAST(ordem AS INT64) ordem,
SAFE_CAST(condicao_domicilio AS STRING) condicao_domicilio,
SAFE_CAST(condicao_familia AS STRING) condicao_familia,
SAFE_CAST(numero_membros_familia AS INT64) numero_membros_familia,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(dia_nascimento AS INT64) dia_nascimento,
SAFE_CAST(mes_nascimento AS INT64) mes_nascimento,
SAFE_CAST(ano_nascimento AS INT64) ano_nascimento,
SAFE_CAST(idade AS INT64) idade,
SAFE_CAST(raca_cor AS STRING) raca_cor,
SAFE_CAST(sabe_ler_escrever AS STRING) sabe_ler_escrever,
SAFE_CAST(frequenta_escola AS STRING) frequenta_escola,
SAFE_CAST(serie_frequentada AS STRING) serie_frequentada,
SAFE_CAST(grau_frequentado AS STRING) grau_frequentado,
SAFE_CAST(ultima_serie_frequentada AS INT64) ultima_serie_frequentada,
SAFE_CAST(ultimo_grau_frequentado AS STRING) ultimo_grau_frequentado,
SAFE_CAST(anos_estudo AS INT64) anos_estudo,
SAFE_CAST(trabalhou_semana AS STRING) trabalhou_semana,
SAFE_CAST(tinha_trabalhado_semana AS STRING) tinha_trabalhado_semana,
SAFE_CAST(tinha_outro_trabalho AS STRING) tinha_outro_trabalho,
SAFE_CAST(ocupacao_semana AS INT64) ocupacao_semana,
SAFE_CAST(atividade_ramo_negocio_semana AS INT64) atividade_ramo_negocio_semana,
SAFE_CAST(atividade_ramo_negocio_anterior AS STRING) atividade_ramo_negocio_anterior,
SAFE_CAST(possui_carteira_assinada AS STRING) possui_carteira_assinada,
SAFE_CAST(renda_mensal_dinheiro AS FLOAT64) renda_mensal_dinheiro,
SAFE_CAST(renda_mensal_produto_mercadoria AS FLOAT64) renda_mensal_produto_mercadoria,
SAFE_CAST(horas_trabalhadas_semana AS INT64) horas_trabalhadas_semana,
SAFE_CAST(renda_mensal_dinheiro_outra AS FLOAT64) renda_mensal_dinheiro_outra,
SAFE_CAST(renda_mensal_produto_outra AS FLOAT64) renda_mensal_produto_outra,
SAFE_CAST(horas_trabalhadas_outros_trabalhos AS INT64) horas_trabalhadas_outros_trabalhos,
SAFE_CAST(contribui_previdencia AS STRING) contribui_previdencia,
SAFE_CAST(tipo_instituto_previdencia AS STRING) tipo_instituto_previdencia,
SAFE_CAST(tomou_providencia_conseguir_trabalho_semana AS STRING) tomou_providencia_conseguir_trabalho_semana,
SAFE_CAST(tomou_providencia_ultimos_2_meses AS STRING) tomou_providencia_ultimos_2_meses,
SAFE_CAST(qual_providencia_tomou AS STRING) qual_providencia_tomou,
SAFE_CAST(tinha_carteira_assinada_ultimo_emprego AS STRING) tinha_carteira_assinada_ultimo_emprego,
SAFE_CAST(renda_aposentadoria AS FLOAT64) renda_aposentadoria,
SAFE_CAST(renda_pensao AS FLOAT64) renda_pensao,
SAFE_CAST(renda_abono_permanente AS FLOAT64) renda_abono_permanente,
SAFE_CAST(renda_aluguel AS FLOAT64) renda_aluguel,
SAFE_CAST(renda_outras AS FLOAT64) renda_outras,
SAFE_CAST(renda_mensal_ocupacao_principal AS FLOAT64) renda_mensal_ocupacao_principal,
SAFE_CAST(renda_mensal_todos_trabalhos AS FLOAT64) renda_mensal_todos_trabalhos,
SAFE_CAST(renda_mensal_todas_fontes AS FLOAT64) renda_mensal_todas_fontes,
SAFE_CAST(atividade_ramo_negocio_agregado AS STRING) atividade_ramo_negocio_agregado,
SAFE_CAST(horas_trabalhadas_todos_trabalhos AS INT64) horas_trabalhadas_todos_trabalhos,
SAFE_CAST(posicao_ocupacao AS STRING) posicao_ocupacao,
SAFE_CAST(grupos_ocupacao AS STRING) grupos_ocupacao,
SAFE_CAST(renda_mensal_familia AS FLOAT64) renda_mensal_familia,
SAFE_CAST(ocupacao_ano_anterior AS STRING) ocupacao_ano_anterior,
SAFE_CAST(renda_mensal_dinheiro_deflacionado AS FLOAT64) renda_mensal_dinheiro_deflacionado,
SAFE_CAST(renda_mensal_produto_mercadoria_deflacionado AS FLOAT64) renda_mensal_produto_mercadoria_deflacionado,
SAFE_CAST(renda_mensal_dinheiro_outra_deflacionado AS FLOAT64) renda_mensal_dinheiro_outra_deflacionado,
SAFE_CAST(renda_mensal_produto_mercadoria_outra_deflacionado AS FLOAT64) renda_mensal_produto_mercadoria_outra_deflacionado,
SAFE_CAST(renda_mensal_ocupacao_principal_deflacionado AS FLOAT64) renda_mensal_ocupacao_principal_deflacionado,
SAFE_CAST(renda_mensal_todos_trabalhos_deflacionado AS FLOAT64) renda_mensal_todos_trabalhos_deflacionado,
SAFE_CAST(renda_mensal_todas_fontes_deflacionado AS FLOAT64) renda_mensal_todas_fontes_deflacionado,
SAFE_CAST(renda_mensal_familia_deflacionado AS FLOAT64) renda_mensal_familia_deflacionado,
SAFE_CAST(renda_aposentadoria_deflacionado AS FLOAT64) renda_aposentadoria_deflacionado,
SAFE_CAST(renda_pensao_deflacionado AS FLOAT64) renda_pensao_deflacionado,
SAFE_CAST(renda_abono_deflacionado AS FLOAT64) renda_abono_deflacionado,
SAFE_CAST(renda_aluguel_deflacionado AS FLOAT64) renda_aluguel_deflacionado,
SAFE_CAST(renda_outras_deflacionado AS FLOAT64) renda_outras_deflacionado
FROM basedosdados-dev.br_ibge_pnad_staging.microdados_compatibilizados_pessoa AS t