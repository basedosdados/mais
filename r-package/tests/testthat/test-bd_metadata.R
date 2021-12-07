
require(typed)

test_that("bd_request works", {

  bd_request("search") %>%
    testthat::expect_s3_class("response")

})


testthat::test_that("Basic dataset search", {

  result <- dataset_search("agua")

  testthat::expect_gt(nrow(result), 0)

  # busca por água encontra o ana-atlas?
  result %>%
    dplyr::pull(dataset_name) %>%
    purrr::some(stringr::str_detect, pattern = "ana_atlas") %>%
    testthat::expect_true()

})

testthat::test_that("Different searches yield different results", {

  dataset_search("educação") %>%
    waldo::compare(dataset_search("educação")) %>%
    length() %>%
    testthat::expect_equal(0)

  dataset_search("educação") %>%
    waldo::compare(dataset_search("água")) %>%
    length() %>%
    testthat::expect_gt(0)

})

testthat::test_that("Basic table column description works", {

  result <- basedosdados::get_table_columns("br_sp_alesp", "deputado")

  testthat::expect_equal(nrow(result), 12)

})

testthat::test_that("List tables of a dataset works", {

  result <- list_dataset_tables("br_sp_alesp")

  result %>%
    tibble::is_tibble() %>%
    testthat::expect_true()

})

testthat::test_that("Dataset description works", {

  description <- get_dataset_description("br_sp_alesp")

  testthat::expect_s3_class(description, "tbl")

  description %>%
    nrow() %>%
    testthat::expect_gt(0)


})

testthat::test_that("Table description works", {

  description <- get_table_description("br_sp_alesp", "deputado")

  testthat::expect_s3_class(description, "tbl")

  description %>%
    nrow() %>%
    testthat::expect_gt(0)

})



