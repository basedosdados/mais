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
CREATE VIEW basedosdados-dev.br_ibge_censo_demografico.microdados_pessoa_2000 AS
SELECT 
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_mesorregiao AS STRING) id_mesorregiao,
SAFE_CAST(id_microrregiao AS STRING) id_microrregiao,
SAFE_CAST(id_regiao_metropolitana AS STRING) id_regiao_metropolitana,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_distrito AS STRING) id_distrito,
SAFE_CAST(id_subdistrito AS STRING) id_subdistrito,
SAFE_CAST(controle AS INT64) controle,
SAFE_CAST(serie AS INT64) serie,
SAFE_CAST(area_ponderacao AS INT64) area_ponderacao,
SAFE_CAST(v1001 AS INT64) v1001,
SAFE_CAST(v1005 AS INT64) v1005,
SAFE_CAST(v1006 AS INT64) v1006,
SAFE_CAST(v1007 AS INT64) v1007,
SAFE_CAST(MARCA AS INT64) marca,
SAFE_CAST(v0401 AS INT64) v0401,
SAFE_CAST(v0402 AS INT64) v0402,
SAFE_CAST(v0403 AS INT64) v0403,
SAFE_CAST(v0404 AS INT64) v0404,
SAFE_CAST(v4752 AS INT64) v4752,
SAFE_CAST(v4754 AS INT64) v4754,
SAFE_CAST(v4070 AS INT64) v4070,
SAFE_CAST(v0408 AS INT64) v0408,
SAFE_CAST(v4090 AS INT64) v4090,
SAFE_CAST(v0410 AS INT64) v0410,
SAFE_CAST(v0411 AS INT64) v0411,
SAFE_CAST(v0412 AS INT64) v0412,
SAFE_CAST(v0413 AS INT64) v0413,
SAFE_CAST(v0414 AS INT64) v0414,
SAFE_CAST(v0415 AS INT64) v0415,
SAFE_CAST(v0416 AS INT64) v0416,
SAFE_CAST(v0417 AS INT64) v0417,
SAFE_CAST(v0418 AS INT64) v0418,
SAFE_CAST(v0419 AS INT64) v0419,
SAFE_CAST(v0420 AS INT64) v0420,
SAFE_CAST(v4210 AS INT64) v4210,
SAFE_CAST(v0422 AS INT64) v0422,
SAFE_CAST(v4230 AS INT64) v4230,
SAFE_CAST(v0424 AS INT64) v0424,
SAFE_CAST(v4250 AS INT64) v4250,
SAFE_CAST(v4260 AS INT64) v4260,
SAFE_CAST(v4276 AS INT64) v4276,
SAFE_CAST(v0428 AS INT64) v0428,
SAFE_CAST(v0429 AS INT64) v0429,
SAFE_CAST(v0430 AS INT64) v0430,
SAFE_CAST(v0431 AS INT64) v0431,
SAFE_CAST(v0432 AS INT64) v0432,
SAFE_CAST(v0433 AS INT64) v0433,
SAFE_CAST(v0434 AS INT64) v0434,
SAFE_CAST(v4355 AS INT64) v4355,
SAFE_CAST(v4300 AS INT64) v4300,
SAFE_CAST(v0436 AS INT64) v0436,
SAFE_CAST(v0437 AS INT64) v0437,
SAFE_CAST(v0438 AS INT64) v0438,
SAFE_CAST(v0439 AS INT64) v0439,
SAFE_CAST(v0440 AS INT64) v0440,
SAFE_CAST(v0441 AS INT64) v0441,
SAFE_CAST(v0442 AS INT64) v0442,
SAFE_CAST(v0443 AS INT64) v0443,
SAFE_CAST(v0444 AS INT64) v0444,
SAFE_CAST(v4452 AS INT64) v4452,
SAFE_CAST(v4462 AS INT64) v4462,
SAFE_CAST(v0447 AS INT64) v0447,
SAFE_CAST(v0448 AS INT64) v0448,
SAFE_CAST(v0449 AS INT64) v0449,
SAFE_CAST(v0450 AS INT64) v0450,
SAFE_CAST(v4511 AS INT64) v4511,
SAFE_CAST(v4512 AS INT64) v4512,
SAFE_CAST(v4513 AS INT64) v4513,
SAFE_CAST(v4514 AS FLOAT64) v4514,
SAFE_CAST(v4521 AS INT64) v4521,
SAFE_CAST(v4522 AS INT64) v4522,
SAFE_CAST(v4523 AS INT64) v4523,
SAFE_CAST(v4524 AS FLOAT64) v4524,
SAFE_CAST(v4525 AS INT64) v4525,
SAFE_CAST(v4526 AS FLOAT64) v4526,
SAFE_CAST(v0453 AS INT64) v0453,
SAFE_CAST(v0454 AS INT64) v0454,
SAFE_CAST(v4534 AS INT64) v4534,
SAFE_CAST(v0455 AS INT64) v0455,
SAFE_CAST(v0456 AS INT64) v0456,
SAFE_CAST(v4573 AS INT64) v4573,
SAFE_CAST(v4583 AS INT64) v4583,
SAFE_CAST(v4593 AS INT64) v4593,
SAFE_CAST(v4603 AS INT64) v4603,
SAFE_CAST(v4613 AS INT64) v4613,
SAFE_CAST(v4614 AS INT64) v4614,
SAFE_CAST(v4615 AS FLOAT64) v4615,
SAFE_CAST(v4620 AS INT64) v4620,
SAFE_CAST(v0463 AS INT64) v0463,
SAFE_CAST(v4654 AS INT64) v4654,
SAFE_CAST(v4670 AS INT64) v4670,
SAFE_CAST(v4690 AS INT64) v4690,
SAFE_CAST(P001 AS FLOAT64) p001,
SAFE_CAST(ESTR AS INT64) estr,
SAFE_CAST(ESTRP AS INT64) estrp,
SAFE_CAST(v4621 AS INT64) v4621,
SAFE_CAST(v4622 AS INT64) v4622,
SAFE_CAST(v4631 AS INT64) v4631,
SAFE_CAST(v4632 AS INT64) v4632,
SAFE_CAST(v0464 AS INT64) v0464,
SAFE_CAST(v4671 AS INT64) v4671,
SAFE_CAST(v4672 AS INT64) v4672,
SAFE_CAST(v4354 AS INT64) v4354,
SAFE_CAST(v4219 AS INT64) v4219,
SAFE_CAST(v4239 AS INT64) v4239,
SAFE_CAST(v4269 AS INT64) v4269,
SAFE_CAST(v4279 AS INT64) v4279,
SAFE_CAST(v4451 AS INT64) v4451,
SAFE_CAST(v4461 AS INT64) v4461
from basedosdados-dev.br_ibge_censo_demografico_staging.microdados_pessoa_2000 as t