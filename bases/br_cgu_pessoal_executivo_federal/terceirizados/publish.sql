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

CREATE VIEW basedosdados-dev.br_cgu_pessoal_executivo_federal.terceirizados AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(id_terceirizado AS STRING) id_terceirizado,
SAFE_CAST(sigla_orgao_superior_unidade_gestora AS STRING) sigla_orgao_superior_unidade_gestora,
SAFE_CAST(codigo_unidade_gestora AS STRING) codigo_unidade_gestora,
SAFE_CAST(unidade_gestora AS STRING) unidade_gestora,
SAFE_CAST(sigla_unidade_gestora AS STRING) sigla_unidade_gestora,
SAFE_CAST(contrato_empresa AS STRING) contrato_empresa,
SAFE_CAST(cnpj_empresa AS STRING) cnpj_empresa,
SAFE_CAST(razao_social_empresa AS STRING) razao_social_empresa,
SAFE_CAST(cpf AS STRING) cpf,
SAFE_CAST(nome AS STRING) nome,
SAFE_CAST(categoria_profissional AS STRING) categoria_profissional,
SAFE_CAST(nivel_escolaridade AS STRING) nivel_escolaridade,
SAFE_CAST(quantidade_horas_trabalhadas_semanais AS STRING) quantidade_horas_trabalhadas_semanais,
SAFE_CAST(unidade_trabalho AS STRING) unidade_trabalho,
SAFE_CAST(valor_mensal AS STRING) valor_mensal,
SAFE_CAST(custo_mensal AS STRING) custo_mensal,
SAFE_CAST(sigla_orgao_trabalho AS STRING) sigla_orgao_trabalho,
SAFE_CAST(nome_orgao_trabalho AS STRING) nome_orgao_trabalho,
SAFE_CAST(codigo_siafi_trabalho AS STRING) codigo_siafi_trabalho,
SAFE_CAST(codigo_siape_trabalho AS STRING) codigo_siape_trabalho
from basedosdados-dev.br_cgu_pessoal_executivo_federal_staging.terceirizados as t