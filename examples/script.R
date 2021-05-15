
library(tidyverse)
library(basedosdados)

basedosdados::set_billing_id("workshop-basedosdados")
# uma query de exemplo

"
SELECT *

FROM `basedosdados.br_inep_ideb.escola`

WHERE

  id_municipio = \'asydfgiuaysgf\'
"

## basedosdados

read_sql(
  "SELECT * FROM `basedosdados.br_inep_ideb.escola`", 
  page_size = 100000)

download(
  "SELECT * FROM `basedosdados.br_inep_ideb.escola`",
  path = "data/ideb.csv",
  page_size = 100000)


# uma pergunta

# map()
# reduce()


(tibble(
  query = c(
    "SELECT * FROM `basedosdados.br_inep_ideb.escola`",
    "SELECT ana.id_municipio, ana.indice_sem_atend
     FROM `basedosdados.br_ana_atlas_esgotos.municipios` as ana",
    "SELECT * FROM `basedosdados.br_ibge_pib.municipios`")) %>%
  mutate(resultados = map(query, read_sql, page_size = 100000)) ->
  queries)

(queries %>%
  pull(resultados) %>%
  reduce(left_join) ->
  painel)


