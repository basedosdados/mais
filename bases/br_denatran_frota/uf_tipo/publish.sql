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

CREATE VIEW basedosdados-312117.br_denatran_frota.uf_tipo AS
SELECT 
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(automovel AS INT64) automovel,
SAFE_CAST(bonde AS INT64) bonde,
SAFE_CAST(caminhao AS INT64) caminhao,
SAFE_CAST(caminhaotrator AS INT64) caminhaotrator,
SAFE_CAST(caminhonete AS INT64) caminhonete,
SAFE_CAST(camioneta AS INT64) camioneta,
SAFE_CAST(chassiplataforma AS INT64) chassiplataforma,
SAFE_CAST(ciclomotor AS INT64) ciclomotor,
SAFE_CAST(microonibus AS INT64) microonibus,
SAFE_CAST(motocicleta AS INT64) motocicleta,
SAFE_CAST(motoneta AS INT64) motoneta,
SAFE_CAST(onibus AS INT64) onibus,
SAFE_CAST(quadriciclo AS INT64) quadriciclo,
SAFE_CAST(reboque AS INT64) reboque,
SAFE_CAST(semireboque AS INT64) semireboque,
SAFE_CAST(sidecar AS INT64) sidecar,
SAFE_CAST(outros AS INT64) outros,
SAFE_CAST(tratoresteira AS INT64) tratoresteira,
SAFE_CAST(tratorrodas AS INT64) tratorrodas,
SAFE_CAST(triciclo AS INT64) triciclo,
SAFE_CAST(utilitario AS INT64) utilitario,
SAFE_CAST(total AS INT64) total
from basedosdados-312117.br_denatran_frota_staging.uf_tipo as t
