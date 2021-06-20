
set_billing_id(readline("Insira um billing project id: "))

ex_query <- function(n) {

  glue::glue("select * from `basedosdados.br_ibge_pib.municipios` LIMIT {n}")

}

test_that("download escreve arquivos recebendo uma query ou nome de tabela", {

  path <- file.path(tempdir(), "arquivo.csv")

    download(
      "select * from basedosdados.br_ibge_populacao.municipio limit 3",
      path = path)

  path %>%
    fs::is_file() %>%
    expect_true()

  path2 <- file.path(tempdir(), "arquivo2.csv")

  download(
    table = "br_ibge_populacao.municipio",
    path = path,
    page_size = 123432,
    .na = "999999999999")

  path %>%
    fs::is_file() %>%
    expect_true()

})

test_that("download permite escolher o conteúdo de NAs", {

  path3 <- file.path(tempdir(), "arquivo3.csv")

  download(
    "select * from basedosdados.br_ibge_populacao.municipio limit 3",
    path = path3,
    .na = "999999")

  path3 %>%
    fs::is_file() %>%
    expect_true()

  download(
    "select * from basedosdados.br_ibge_populacao.municipio limit 3",
    path = path3,
    .na = "AUSENTE")

  path3 %>%
    fs::is_file() %>%
    expect_true()

  download(
    "select * from basedosdados.br_ibge_populacao.municipio limit 3",
    path = path3,
    .na = " -- ")

  path3 %>%
    fs::is_file() %>%
    expect_true()

})

test_that("download permite escolher tamanho de página", {

  path4 <- file.path(tempdir(), "arquivo4.csv")

  download(
    "select * from basedosdados.br_ibge_populacao.municipio limit 3",
    path = path4,
    page_size = 123432)

  path4 %>%
    fs::is_file() %>%
    expect_true()

})

test_that("download valida nomes de arquivos sem extensão", {

  expect_error(
    download(
      "select * from basedosdados.br_ibge_populacao.municipio limit 3",
      file.path(tempdir(), "arquivo")))

  })


test_that("read_sql e read_table retornam um tibble com as propriedades esperadas", {

  expect_s3_class(read_sql(ex_query(1)), "tbl_df")

  expect_equal(nrow(read_sql(ex_query(5))), 5)

  expect_s3_class(read_sql(ex_query(1000)), "tbl_df")

  expect_s3_class(read_table(table = "br_ibge_pib.municipios"), "tbl_df")

  expect_s3_class(read_table(table = "br_denatran_frota.uf_tipo"), "tbl_df")

})

test_that("read_sql e read_table falham com input inapropriado", {

  expect_error(read_table(table = 123))
  expect_error(read_table(table = TRUE))
  expect_error(read_table(table = "sodfungosd"))
  expect_error(read_table(table = letters))
  expect_error(read_table())

  expect_error(read_table(table = 123))
  expect_error(read_table(table = TRUE))
  expect_error(read_table(table = "sodfungosd"))
  expect_error(read_table(table = letters))
  expect_error(read_table())



})






