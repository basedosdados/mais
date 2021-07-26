
set_billing_id(readline("Insira um billing project id: "))

ex_query <- function(n = 5) {

  glue::glue("select * from `basedosdados.br_ibge_pib.municipio` LIMIT {n}")

}

test_that("download escreve arquivos recebendo uma query ou nome de tabela", {

  path <- file.path(tempdir(), "arquivo.csv")

    download(
      ex_query(),
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
    ex_query(),
    path = path3,
    .na = "999999")

  path3 %>%
    fs::is_file() %>%
    expect_true()

  download(
    ex_query(),
    path = path3,
    .na = "AUSENTE")

  path3 %>%
    fs::is_file() %>%
    expect_true()

})

test_that("download permite escolher tamanho de página", {

  path4 <- file.path(tempdir(), "arquivo4.csv")

  download(
    ex_query(),
    path = path4,
    page_size = 123432)

  path4 %>%
    fs::is_file() %>%
    expect_true()

})

test_that("download valida nomes de arquivos sem extensão", {

  expect_error(
    download(
      ex_query(),
      file.path(tempdir(), "arquivo")))

  })


test_that("read_sql e read_table retornam um tibble com as propriedades esperadas", {

  testthat::expect_s3_class(read_sql(ex_query(1)), "tbl_df")

  read_sql(ex_query(5)) %>%
    nrow() %>%
    testthat::expect_gt(0)

  # read_table(table = "br_denatran_frota.uf_tipo") %>%
  #   nrow() %>%
  #   testthat::expect_gt(0)
  #
  # testthat::expect_s3_class(read_table(table = "br_denatran_frota.uf_tipo"), "tbl_df")

})

test_that("read_sql e read_table falham com input inapropriado", {

  expect_error(read_sql(query = 123))
  expect_error(read_sql(query = TRUE))
  expect_error(read_sql(query = "sodfungosd"))
  expect_error(read_sql(query = letters))
  expect_error(read_sql())

})






