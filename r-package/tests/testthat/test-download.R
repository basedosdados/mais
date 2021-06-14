
library(dotenv)

set_billing_id("basedd-cava")

ex_query <- "select * from `basedosdados.br_ibge_pib.municipios` LIMIT 5"


test_that("download valida nomes de arquivos sem extensão", {

  expect_error(
    download(
      "select * from basedosdados.br_ibge_populacao.municipios limit 3",
      file.path(tempdir(), "arquivo"))
    )
  })


test_that("download requer nomes de arquivos", {

  expect_error(
    download("select * from basedosdados.br_ibge_populacao.municipios limit 3"))
  })

test_that("read_sql retorna um tibble", {

  expect_s3_class(read_sql(ex_query), "tbl_df")

  expect_s3_class(read_sql(table = "br_ibge_pib.municipios"), "tbl_df")

  expect_s3_class(read_sql(table = "br_denatran_frota.uf_tipo"), "tbl_df")

})

test_that("read_sql passa a query com limite corretamente", {

  expect_equal(
    nrow(
      read_sql(
        query = ex_query)),
    5)

})

test_that("read_sql falha se não receber uma query apropriada", {

  expect_error(read_sql(1232314))
  expect_error(read_sql(TRUE))
  expect_error(read_sql(query = NA))
  expect_error(read_sql())

})



# test_that("", {
#
#   load_dot_env('keys.env')
#
#   set_billing_id(Sys.getenv('project_id'))
#
# })






