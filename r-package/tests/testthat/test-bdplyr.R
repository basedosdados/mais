# Orientações gerais ------------------------------------------------------

# Testaria todos os guardiões esperando um erro para cada exceção definida nas
# funções.
# Também adicionaria uma expectativa de erro para cada exceção definida no corpo
# da função.
# Sem definir billing_id --------------------------------------------------

set_billing_id(readline("Insira um billing project id: "))

require(magrittr)

basedosdados::bdplyr("br_tse_eleicoes.candidatos") %>%
  dplyr::filter(ano == 2014) %>%
  dplyr::select(ano, cpf, titulo_eleitoral, sigla_partido, numero, nome, genero) ->
  example_data


test_that("bd_colllect works", {

  testthat::expect_s3_class(example_data, "tbl_lazy")

  example_data %>%
    dplyr::group_by(sigla_partido, genero) %>%
    dplyr::summarise(contagem = n()) %>%
    basedosdados::bd_collect() %>%
    testthat::expect_s3_class("tbl_df")

})

# deu certo
test_that("bd_write funcionando a escrita adequadamente", {

  # TODO: gerar um dataframe com nomes e funcoes de escrita, walk2() para escrever
  # e depois purrr::every(endereços, purrr::compose())

  (bd_write_test_params <- tibble::tibble(
    extension = c("csv", "xlsx", "json", "dta"),
    write_fn = list(write.csv, writexl::write_xlsx, jsonlite::write_json, foreign::write.dta),
    paths = file.path(tempdir(), glue::glue("bd_write_fn_{extension}.{extension}"))))

  bd_write_test_params %$%
    purrr::walk2(
      .x = paths,
      .y = write_fn,
      .f =
        ~ basedosdados::bd_write(
          .lazy_tbl = example_data,
          .write_fn = .y,
          overwrite = TRUE,
          path = .x) %>%
        fs::file_exists() %>%
        testthat::expect_true())


})

# deu certo
test_that("bd_write_csv works", {

  tempfile_csv <- file.path(tempdir(), "bd_write_csv.csv")

  example_data %>%
    basedosdados::bd_write_csv(tempfile_csv, overwrite = TRUE)

  tempfile_csv %>%
    fs::file_exists() %>%
    testthat::expect_true()

})


# deu certo
test_that("bd_write_rds works normally and with compression", {

  tempfile1 <- file.path(tempdir(), "first_bdplyr_test.rds")

  example_data %>%
    basedosdados::bd_write_rds(tempfile1, overwrite = TRUE)

  tempfile1 %>%
    fs::file_exists() %>%
    testthat::expect_true()

  tempfile2 <- file.path(tempdir(), "second_bdplyr_test.rds")

  example_data %>%
    basedosdados::bd_write_rds(
      tempfile2,
      compress = 'gz')

  tempfile2 %>%
    fs::file_exists() %>%
    testthat::expect_true()

  tempfile3 <- file.path(tempdir(), "third_bdplyr_test.rds")

  example_data %>%
    basedosdados::bd_write_rds(
      tempfile3,
      compress = 'xz')

  tempfile3 %>%
    fs::file_exists() %>%
    testthat::expect_true()


})






