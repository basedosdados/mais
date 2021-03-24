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

CREATE VIEW basedosdados-dev.br_ipea_acesso_oportunidades.estatisticas_2019 AS
SELECT 
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(id_grid_h3 AS STRING) id_grid_h3,
ST_GEOGFROMTEXT(geometria) geometria,
SAFE_CAST(quantidade_pessoas AS INT64) quantidade_pessoas,
SAFE_CAST(quantidade_pessoas_brancas AS INT64) quantidade_pessoas_brancas,
SAFE_CAST(quantidade_pessoas_negras AS INT64) quantidade_pessoas_negras,
SAFE_CAST(quantidade_pessoas_indigenas AS INT64) quantidade_pessoas_indigenas,
SAFE_CAST(quantidade_pessoas_amarelas AS INT64) quantidade_pessoas_amarelas,
SAFE_CAST(renda_domiciliar_pc AS FLOAT64) renda_domiciliar_pc,
SAFE_CAST(quintil_de_renda AS INT64) quintil_de_renda,
SAFE_CAST(decil_de_renda AS INT64) decil_de_renda,
SAFE_CAST(quantidade_estabelecimentos_ensino AS INT64) quantidade_estabelecimentos_ensino,
SAFE_CAST(quantidade_estabelecimentos_ensino_infantil AS INT64) quantidade_estabelecimentos_ensino_infantil,
SAFE_CAST(quantidade_estabelecimentos_ensino_fundamental AS INT64) quantidade_estabelecimentos_ensino_fundamental,
SAFE_CAST(quantidade_estabelecimentos_ensino_medio AS INT64) quantidade_estabelecimentos_ensino_medio,
SAFE_CAST(quantidade_estabelecimentos_saude AS INT64) quantidade_estabelecimentos_saude,
SAFE_CAST(quantidade_estabelecimentos_saude_baixa_complexidade AS INT64) quantidade_estabelecimentos_saude_baixa_complexidade,
SAFE_CAST(quantidade_estabelecimentos_saude_media_coplexidade AS INT64) quantidade_estabelecimentos_saude_media_coplexidade,
SAFE_CAST(quantidade_estabelecimentos_saude_alta_coplexidade AS INT64) quantidade_estabelecimentos_saude_alta_coplexidade
from basedosdados-dev.br_ipea_acesso_oportunidades_staging.estatisticas_2019 as t