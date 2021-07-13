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

CREATE VIEW basedosdados-dev.br_sp_seduc_fluxo_escolar.escola AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(diretoria AS STRING) diretoria,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_escola AS STRING) id_escola,
SAFE_CAST(id_escola_sp AS STRING) id_escola_sp,
SAFE_CAST(codigo_tipo_escola AS STRING) codigo_tipo_escola,
SAFE_CAST(prop_aprovados_anos_inciais_ef AS FLOAT64) prop_aprovados_anos_inciais_ef,
SAFE_CAST(prop_reprovados_anos_iniciais_ef AS FLOAT64) prop_reprovados_anos_iniciais_ef,
SAFE_CAST(prop_abandono_anos_iniciais_ef AS FLOAT64) prop_abandono_anos_iniciais_ef,
SAFE_CAST(prop_aprovados_anos_finais_ef AS FLOAT64) prop_aprovados_anos_finais_ef,
SAFE_CAST(prop_reprovados_anos_finais_ef AS FLOAT64) prop_reprovados_anos_finais_ef,
SAFE_CAST(prop_abandono_anos_finais_ef AS FLOAT64) prop_abandono_anos_finais_ef,
SAFE_CAST(prop_aprovados_em AS FLOAT64) prop_aprovados_em,
SAFE_CAST(prop_reprovados_em AS FLOAT64) prop_reprovados_em,
SAFE_CAST(prop_abandono_em AS FLOAT64) prop_abandono_em
from basedosdados-dev.br_sp_seduc_fluxo_escolar_staging.escola as t