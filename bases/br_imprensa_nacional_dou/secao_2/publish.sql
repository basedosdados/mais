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

PS: Essa é uma view que busca dados do projeto `gabinete-compartilhado`. Os dados não estão 
armazenados no storage do basedosdados.
*/
CREATE VIEW basedosdados.br_imprensa_nacional_dou.secao_2 AS
SELECT 
  identifica AS titulo,
  orgao,
  ementa,
  resumo AS excerto,
  clean_text AS texto_principal,
  fulltext AS texto_completo,
  assina AS assinatura,
  cargo,
  secao,
  edicao,
  tipo_edicao,
  pagina,
  data_pub AS data_publicacao,
  url,
  url_certificado AS url_versao_certificada,
  capture_date AS data_captura,
  part_data_pub AS data_publicacao_particao
FROM `gabinete-compartilhado.views_publicos.br_imprensa_oficial_dou_2` AS t
