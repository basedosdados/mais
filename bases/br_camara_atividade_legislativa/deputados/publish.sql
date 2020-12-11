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
CREATE VIEW basedosdados.br_camara_atividade_legislativa.deputados AS
SELECT 
SAFE_CAST(id AS NUMERIC) id_deputado,
SAFE_CAST(cpf AS NUMERIC) cpf,
SAFE_CAST(nomeCivil AS STRING) nome_civil,
SAFE_CAST(nome_civil AS STRING) nome_civil_upper,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(municipioNascimento AS STRING) municipio_nascimento,
SAFE_CAST(ufNascimento AS STRING) estado_abrev_nascimento,
SAFE_CAST(data_nascimento AS DATE) data_nascimento,
SAFE_CAST(escolaridade AS STRING) escolaridade,
SAFE_CAST(escolaridade_nova AS STRING) escolaridade_nova,
SAFE_CAST(ultimoStatus_nome AS STRING) ultimo_status_nome,
SAFE_CAST(ultimoStatus_nome_eleitoral AS STRING) ultimo_status_nome_eleitoral,
SAFE_CAST(sigla_partido_original AS STRING) sigla_partido_original,
SAFE_CAST(sigla_partido AS STRING) sigla_partido,
SAFE_CAST(uf AS STRING) estado_abrev,
SAFE_CAST(ultimoStatus_data AS DATETIME) ultimo_status_data,
SAFE_CAST(ultima_legislatura AS NUMERIC) ultima_legislatura,
SAFE_CAST(ultimoStatus_condicao_eleitoral AS STRING) ultimo_status_condicao_eleitoral,
SAFE_CAST(ultimoStatus_situacao AS STRING) ultimo_status_situacao,
SAFE_CAST(gabinete_predio AS NUMERIC) gabinete_predio,
SAFE_CAST(gabinete_andar AS NUMERIC) gabinete_andar,
SAFE_CAST(gabinete_sala AS NUMERIC) gabinete_sala,
SAFE_CAST(gabinete_telefone AS STRING) gabinete_telefone,
SAFE_CAST(email AS STRING) email,
SAFE_CAST(gabinete_nome AS NUMERIC) gabinete_nome,
SAFE_CAST(url_partido AS STRING) url_partido,
SAFE_CAST(url_foto AS STRING) url_foto,
SAFE_CAST(capture_date AS DATETIME) capture_date,
SAFE_CAST(api_url AS STRING) api_url
from `gabinete-compartilhado.views_publicos.br_legislativo_camara_deputados`  as t