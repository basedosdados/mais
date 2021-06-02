# Orientações gerais ------------------------------------------------------

# Testaria todos os guardiões esperando um erro para cada exceção definida nas
# funções.
# Também adicionaria uma expectativa de erro para cada exceção definida no corpo
# da função.
# Sem definir billing_id --------------------------------------------------

# bdplyr

test_that("bdplyr sem definir o billing_id", {

  bigrquery::bq_deauth()

  expect_error(
    bdplyr("br_ms_sim.municipio_causa_idade"),
    "haven't set a Project Billing Id")

})

# bdplyr ------------------------------------------------------------------

test_that(desc = "bdplyr - guardiões", {

  bigrquery::bq_auth(email = "rodornelles@gmail.com")
  basedosdados::set_billing_id("nimble-root-312115")

  # table em formato errado - sem pontos
  expect_error(bdplyr(table = "tabelasempontos"), "`table` is invalid.")

  # table em formato errado - > 2 pontos
  expect_error(bdplyr(table = "tabela.com.muitos.pontos"), "`table` is invalid.")

  # query_project_id não é string
  expect_error(bdplyr(table = "tabela.valida", query_project_id = 00000), "`query_project_id` must be a string.")
  expect_error(bdplyr(table = "tabela.valida", query_project_id = mtcars), "`query_project_id` must be a string.")
  expect_error(bdplyr(table = "tabela.valida", query_project_id = NA), "`query_project_id` must be a string.")

  # tabela inválida no bigquery
  expect_error(bdplyr("tabelaquenao.existe"), "was not found at basedosdados")

})

test_that("conexão que não pode ser feita", {

  bigrquery::bq_deauth()
  basedosdados::set_billing_id("billingbizarroquenaoexistepqpmetiradaqui")

  # não consegui achar nenhuma tabela que eu não tivesse autorização pra ler
  # e que passasse no teste do bq_exists()

  expect_error({
    bdplyr("br_ms_sim.municipio_causa_idade") %>%
      head() %>%
      bd_collect()})
})

test_that("bdplyr deu certo", {
  # deu certo - definindo project
  bigrquery::bq_auth(email = "rodornelles@gmail.com")
  basedosdados::set_billing_id("nimble-root-312115")

  expect_s3_class(bdplyr("basedosdados.br_ms_sim.municipio_causa_idade"),
                  class = "tbl_lazy")

  # deu certo sem definir query_project_id
  expect_s3_class(bdplyr("br_ms_sim.municipio_causa_idade",
                         query_project_id = "basedosdados"),
                  class = "tbl_lazy")

  # deu certo definindo project diferente de basedosdados
  expect_s3_class(bdplyr("baseball.games_post_wide",
                         query_project_id = "bigquery-public-data"),
                  class = "tbl_lazy")
})


# bd_collect ---------------------------------------------------------------

test_that("bdcollect - testando guardiões", {

  Sys.setenv(billing_project_id = FALSE)

  # sem project_id
  expect_error(bd_collect())

  expect_error(
    bd_collect(
      .lazy_tbl = {bdplyr("br_ms_sim.municipio_causa_idade") %>%  head()}
      ),
      regexp = "haven't set a Project Billing Id"
  )

  bigrquery::bq_auth(email = "rodornelles@gmail.com")
  basedosdados::set_billing_id("nimble-root-312115")

  # não é lazy tibble
  expect_error(bd_collect(mtcars), " should be a lazy tibble.")

  # tibble sem colunas ou sem linhas
  tabela_remota <- bdplyr("basedosdados.br_sp_gov_ssp.produtividade_policial")

  tabela_remota_sem_linhas <- tabela_remota %>%
    dplyr::filter(ano > 2999)

  expect_warning(bd_collect(tabela_remota_sem_linhas), "no rows or no cols")

  tabela_remota_poucas_linhas <- tabela_remota %>%
    head(1)

  expect_message(bd_collect(tabela_remota_poucas_linhas))

})

# Testaria a bd_collect usando os exemplos e validando que os retornos batem
# com o esperado, tipo expect_true(is_tibble(resultado_do_exemplo)).

test_that("bd_coollect - exemplos funcionando", {

  bigrquery::bq_auth(email = "rodornelles@gmail.com")
  basedosdados::set_billing_id("nimble-root-312115")

  bd_table <- basedosdados::bdplyr(
    "basedosdados.br_sp_gov_ssp.ocorrencias_registradas")

  expect_s3_class(bd_table, "tbl_lazy")

   # filter, select and group the remote data
  bd_ssp <-  bd_table %>%
    dplyr::filter(ano >= 2019) %>%
    dplyr::select(ano, mes, homicidio_doloso) %>%
    dplyr::group_by(ano, mes) %>%
    # collect the data to continue the analisis
    basedosdados::bd_collect()

 expect_s3_class(bd_ssp, "tbl_df")

   # make some plots
  library(ggplot2)

 expect_s3_class({bd_ssp %>%
     dplyr::summarise(homicidios_sum = sum(homicidio_doloso,
                                           na.rm = TRUE)) %>%
     ggplot(aes(x = mes, y = homicidios_sum, fill = ano)) +
     geom_col(position = "dodge")},
     "ggplot")

})


# bd_write ----------------------------------------------------------------

test_that("bd_write - guardiões", {

  bigrquery::bq_auth(email = "rodornelles@gmail.com")
  basedosdados::set_billing_id("nimble-root-312115")

  tabela_remota <- bdplyr("basedosdados.br_sp_gov_ssp.produtividade_policial")

  # .write_fn não é função
  expect_error(bd_write())
  expect_error(bd_write(tabela_remota), "must be informed")
  expect_error(bd_write(tabela_remota, .write_fn = mtcars))

  # a tabela é tibble, não é lazy
  expect_error(bd_write(.lazy_tbl = tibble::as_tibble(mtcars),
                        .write_fn = write.csv,
                        path = ".",
                        overwrite = TRUE), "need to be collected")

  # a tabela nem tibble é
  expect_error(bd_write(.lazy_tbl = 2344443,
                        .write_fn = write.csv,
                        path = ".",
                        overwrite = TRUE), "not possible to collect")

  # função que não é de escrita
  expect_error(bd_write(.lazy_tbl = tabela_remota,
                        .write_fn = summary,
                        path = "data-raw/teste_tabela_remota.csv",
                        overwrite = TRUE), "Failed to save the file")

})

# deu certo
test_that("bd_write funcionando a escrita adequadamente", {

  # criar pasta de teste vazia
  fs::dir_create("data-raw/arquivos_teste")

  # limpar arquivos
  fs::file_delete(fs::dir_info("data-raw/arquivos_teste")$path)

  # reproduzir os exemplos
  bigrquery::bq_auth(email = "rodornelles@gmail.com")
  basedosdados::set_billing_id("nimble-root-312115")

  cool_db_ssp <- basedosdados::bdplyr(
   "basedosdados.br_sp_gov_ssp.ocorrencias_registradas")

    my_subset <- cool_db_ssp %>%
   dplyr::filter(ano == 2021, mes == 04)

## começando as expect_

    # write it in csv - generic function
    expect_true(fs::file_exists(
      basedosdados::bd_write(
        .lazy_tbl = my_subset,
        .write_fn = write.csv,
        "data-raw/arquivos_teste/ssp_subset.csv"
      )
    ))

    # write in .xlsx
    expect_true(fs::file_exists(
      basedosdados::bd_write(
        .lazy_tbl = my_subset,
        .write_fn = writexl::write_xlsx,
        "data-raw/arquivos_teste/ssp_subset.xlsx"
      )
    ))

    ## using other write functions

    # json
    expect_true(fs::file_exists(
      basedosdados::bd_write(
        .lazy_tbl = my_subset,
        .write_fn = jsonlite::write_json,
        "data-raw/arquivos_teste/ssp_subset.json"
      )
    ))

    # dta -
    expect_true(fs::file_exists(
      basedosdados::bd_write(
        .lazy_tbl = my_subset,
        .write_fn = foreign::write.dta,
        "data-raw/arquivos_teste/ssp_subset.dta"
      )
    ))

# feather
expect_true(fs::file_exists(
  basedosdados::bd_write(
    .lazy_tbl = my_subset,
    .write_fn = arrow::write_feather,
    "data-raw/arquivos_teste/ssp_subset.feather"
  )
))

})


# bd_write_csv ------------------------------------------------------------

test_that("bd_write_csv - guardiões", {

  bigrquery::bq_auth(email = "rodornelles@gmail.com")
  basedosdados::set_billing_id("nimble-root-312115")

  cool_db_ssp <- basedosdados::bdplyr(
    "basedosdados.br_sp_gov_ssp.ocorrencias_registradas")

  my_subset <- cool_db_ssp %>%
    dplyr::filter(ano == 2021, mes == 04)

  # parametros não informados
    expect_error(bd_write_csv(), "must be informed")
    expect_error(bd_write_csv("a"), "must be informed")

  # o path do arquivo não termina com .csv

    expect_error(bd_write_csv(cool_db_ssp, path = "caminho/bizarro"),
                 "Pass a valid file name")

  # arquivo de saída existe e overwrite = FALSE
  readr::write_csv(mtcars, "data-raw/arquivos_teste/csvjaexiste.csv")
    expect_error(bd_write_csv(cool_db_ssp,
                              path = "data-raw/arquivos_teste/csvjaexiste.csv"),
                 "overwrite")

  # não é uma lazy_tbl
    expect_error(bd_write_csv(mtcars,
                              path = "data-raw/arquivos_teste/mtcars.csv"),
                 "should be a lazy tibble")

  })

# deu certo
test_that("bd_write_csv - deu certo", {

  bigrquery::bq_auth(email = "rodornelles@gmail.com")
  basedosdados::set_billing_id("nimble-root-312115")

  cool_db_ssp <- basedosdados::bdplyr(
    "basedosdados.br_sp_gov_ssp.ocorrencias_registradas")

  my_subset <- cool_db_ssp %>%
    dplyr::filter(ano == 2021, mes == 04)

# using the derivatives functions
# to csv
expect_true(fs::file_exists(
  basedosdados::bd_write_csv(.lazy_tbl = my_subset,
                             "data-raw/arquivos_teste/ssp_subset2.csv")
))

})

# bd_write_rds ------------------------------------------------------------

test_that("bd_write_rds - guardiões", {

  bigrquery::bq_auth(email = "rodornelles@gmail.com")
  basedosdados::set_billing_id("nimble-root-312115")

  cool_db_ssp <- basedosdados::bdplyr(
    "basedosdados.br_sp_gov_ssp.ocorrencias_registradas")

  my_subset <- cool_db_ssp %>%
    dplyr::filter(ano == 2021, mes == 04)

  # parametros não informados
  expect_error(bd_write_rds(), "must be informed")
  expect_error(bd_write_rds("abc"), "must be informed")

  # o path do arquivo não termina com .rds

  expect_error(bd_write_rds(cool_db_ssp, path = "caminho/bizarro"),
               "Pass a valid file name")

  # arquivo de saída existe e overwrite = FALSE
  readr::write_rds(mtcars, "data-raw/arquivos_teste/rdsjaexiste.rds")

  expect_error(bd_write_rds(cool_db_ssp,
                            path = "data-raw/arquivos_teste/rdsjaexiste.rds"),
               "overwrite")

  # não é uma lazy_tbl
  expect_error(bd_write_rds(mtcars,
                            path = "data-raw/arquivos_teste/mtcars.rds"),
               "should be a lazy tibble")

})

# deu certo
test_that("bd_write_rds - deu certo", {

  bigrquery::bq_auth(email = "rodornelles@gmail.com")
  basedosdados::set_billing_id("nimble-root-312115")

  cool_db_ssp <- basedosdados::bdplyr(
    "basedosdados.br_sp_gov_ssp.ocorrencias_registradas")

  my_subset <- cool_db_ssp %>%
    dplyr::filter(ano == 2021, mes == 04)

  # to rds
  expect_true(fs::file_exists(
    basedosdados::bd_write_rds(.lazy_tbl = my_subset,
                               "data-raw/arquivos_teste/ssp_subset.rds")
  ))

  # to rds - with compression
  expect_true(fs::file_exists(
    basedosdados::bd_write_rds(
      .lazy_tbl = my_subset,
      "data-raw/arquivos_teste/ssp_subset2.rds",
      compress = "gz"
    )
  ))

  # to rds - with HARD compression
  expect_true(fs::file_exists(
    basedosdados::bd_write_rds(
      .lazy_tbl = my_subset,
      "data-raw/arquivos_teste/ssp_subset3.rds",
      compress = "xz"
    )
  ))


})






