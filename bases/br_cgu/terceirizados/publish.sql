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

CREATE VIEW basedosdados-dev.br_cgu.terceirizados AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(id_terceirizado AS STRING) id_terceirizado,
SAFE_CAST(sigla_orgao_superior_unidade_gestora AS STRING) sigla_orgao_superior_unidade_gestora,
SAFE_CAST(codigo_unidade_gestora AS STRING) codigo_unidade_gestora,
SAFE_CAST(unidade_gestora AS STRING) unidade_gestora,
SAFE_CAST(sigla_unidade_gestora_terceirizado AS STRING) sigla_unidade_gestora_terceirizado,
SAFE_CAST(contrato_empresa AS STRING) contrato_empresa,
SAFE_CAST(cnpj_empresa AS STRING) cnpj_empresa,
SAFE_CAST(razao_social_empresa AS STRING) razao_social_empresa,
SAFE_CAST(cpf_terceirizado AS STRING) cpf_terceirizado,
SAFE_CAST(nome_terceirizado AS STRING) nome_terceirizado,
SAFE_CAST(categoria_profissional AS STRING) categoria_profissional,
SAFE_CAST(nivel_escolaridade AS STRING) nivel_escolaridade,
SAFE_CAST(quantidade_horas_trabalhadas_semanais AS INT64) quantidade_horas_trabalhadas_semanais,
SAFE_CAST(unidade_trabalho_terceirizado AS STRING) unidade_trabalho_terceirizado,
SAFE_CAST(valor_terceirizado_mensal AS FLOAT64) valor_terceirizado_mensal,
SAFE_CAST(custo_terceirizado_mensal AS FLOAT64) custo_terceirizado_mensal,
SAFE_CAST(sigla_orgao_trabalho_terceirizado AS STRING) sigla_orgao_trabalho_terceirizado,
SAFE_CAST(nome_orgao_trabalho_terceirizado AS STRING) nome_orgao_trabalho_terceirizado,
SAFE_CAST(codigo_siafi_trabalho_terceirizado AS STRING) codigo_siafi_trabalho_terceirizado,
SAFE_CAST(codigo_siape_trabalho_terceirizado AS STRING) codigo_siape_trabalho_terceirizado
from basedosdados-dev.br_cgu_staging.terceirizados as t