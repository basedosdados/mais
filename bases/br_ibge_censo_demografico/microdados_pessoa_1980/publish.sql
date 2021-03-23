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
    - Para modificar tipos de colunas, basta substituir INT64 por outro tipo válido.
    - Exemplo: `SAFE_CAST(column_name AS NUMERIC) column_name`
    - Mais detalhes: https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types

*/
CREATE VIEW basedosdados-dev.br_ibge_censo_demografico.microdados_pessoa_1980 AS
SELECT 
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(numero_ordem AS INT64) numero_ordem,
SAFE_CAST(v211 AS INT64) v211,
SAFE_CAST(v604 AS INT64) v604,
SAFE_CAST(v598 AS INT64) v598,
SAFE_CAST(v501 AS INT64) v501,
SAFE_CAST(v503 AS INT64) v503,
SAFE_CAST(v504 AS INT64) v504,
SAFE_CAST(v505 AS INT64) v505,
SAFE_CAST(v605 AS INT64) v605,
SAFE_CAST(v606 AS INT64) v606,
SAFE_CAST(v508 AS INT64) v508,
SAFE_CAST(v509 AS INT64) v509,
SAFE_CAST(v510 AS INT64) v510,
SAFE_CAST(v511 AS INT64) v511,
SAFE_CAST(v512 AS INT64) v512,
SAFE_CAST(v513 AS INT64) v513,
SAFE_CAST(v514 AS INT64) v514,
SAFE_CAST(v515 AS INT64) v515,
SAFE_CAST(v516 AS INT64) v516,
SAFE_CAST(v517 AS INT64) v517,
SAFE_CAST(v518 AS INT64) v518,
SAFE_CAST(v519 AS INT64) v519,
SAFE_CAST(v520 AS INT64) v520,
SAFE_CAST(v521 AS INT64) v521,
SAFE_CAST(v522 AS INT64) v522,
SAFE_CAST(v523 AS INT64) v523,
SAFE_CAST(v524 AS INT64) v524,
SAFE_CAST(v525 AS INT64) v525,
SAFE_CAST(v526 AS INT64) v526,
SAFE_CAST(v527 AS INT64) v527,
SAFE_CAST(v528 AS INT64) v528,
SAFE_CAST(v529 AS INT64) v529,
SAFE_CAST(v681 AS INT64) v681,
SAFE_CAST(v530 AS INT64) v530,
SAFE_CAST(v532 AS INT64) v532,
SAFE_CAST(v533 AS INT64) v533,
SAFE_CAST(v534 AS INT64) v534,
SAFE_CAST(v535 AS INT64) v535,
SAFE_CAST(v680 AS INT64) v680,
SAFE_CAST(v607 AS INT64) v607,
SAFE_CAST(v608 AS INT64) v608,
SAFE_CAST(v540 AS INT64) v540,
SAFE_CAST(v541 AS INT64) v541,
SAFE_CAST(v682 AS INT64) v682,
SAFE_CAST(v536 AS INT64) v536,
SAFE_CAST(v609 AS INT64) v609,
SAFE_CAST(v542 AS INT64) v542,
SAFE_CAST(v544 AS INT64) v544,
SAFE_CAST(v545 AS INT64) v545,
SAFE_CAST(v610 AS INT64) v610,
SAFE_CAST(v611 AS INT64) v611,
SAFE_CAST(v612 AS INT64) v612,
SAFE_CAST(v613 AS INT64) v613,
SAFE_CAST(v550 AS INT64) v550,
SAFE_CAST(v551 AS INT64) v551,
SAFE_CAST(v552 AS INT64) v552,
SAFE_CAST(v553 AS INT64) v553,
SAFE_CAST(v554 AS INT64) v554,
SAFE_CAST(v555 AS INT64) v555,
SAFE_CAST(v556 AS INT64) v556,
SAFE_CAST(v557 AS INT64) v557,
SAFE_CAST(v570 AS INT64) v570
FROM basedosdados-dev.br_ibge_censo_demografico_staging.microdados_pessoa_1980 AS t