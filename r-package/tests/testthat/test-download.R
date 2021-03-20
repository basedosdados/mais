
library(dotenv)

load_dot_env('keys.env') # esperando um arquivo com esse nome na pasta tests/testthat/

set_billing_id(Sys.getenv('project_id'))


test_that("download valida nomes de arquivos sem extensão", {

  expect_error(
    download(
      "select * from basedosdados.br_ibge_populacao.municipios limit 3",
      "arquivo")
    )
  })


test_that("download requer nomes de arquivos", {

  expect_error(
    download("select * from basedosdados.br_ibge_populacao.municipios limit 3"))
  })

test_that("download retorna invisivelmente nomes de arquivos", {

  expect_invisible(
    download("select * from basedosdados.br_ibge_populacao.municipios limit 1", "teste.csv"))

  unlink("teste.csv")

})

test_that("read_sql retorna um tibble", {

  query <- "SELECT
  pib.id_municipio,
  pop.ano,
  pib.PIB / pop.populacao * 1000 as pib_per_capita
  FROM `basedosdados.br_ibge_pib.municipios` as pib
  JOIN `basedosdados.br_ibge_populacao.municipios` as pop
  ON pib.id_municipio = pop.id_municipio
  LIMIT 5 "

  expect_s3_class(read_sql(query), "tbl_df")

})

test_that("read_sql retorna o número esperado de linhas", {

  query <- "SELECT
  pib.id_municipio,
  pop.ano,
  pib.PIB / pop.populacao * 1000 as pib_per_capita
  FROM `basedosdados.br_ibge_pib.municipios` as pib
  JOIN `basedosdados.br_ibge_populacao.municipios` as pop
  ON pib.id_municipio = pop.id_municipio
  LIMIT 5 "

  expect_equal(nrow(read_sql(query)), 5)

})


test_that("read_sql falha se não receber uma query apropriada", {

  load_dot_env('keys.env')

  set_billing_id(Sys.getenv('project_id'))

  expect_error(read_sql(1232314))

})

# test_that("", {
#
#   load_dot_env('keys.env')
#
#   set_billing_id(Sys.getenv('project_id'))
#
# })






