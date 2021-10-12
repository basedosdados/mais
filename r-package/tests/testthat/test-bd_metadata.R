
require(typed)

test_that("bd_request works", {

  bd_request("search") %>%
    testthat::expect_s3_class("response")

})


testthat::test_that("Basic dataset search", {

  result <- search("agua")

  testthat::expect_gt(nrow(result), 0)

  result %>%
    dplyr::pull(name) %>%
    purrr::some(stringr::str_detect, pattern = "ana-atlas") %>%
    testthat::expect_true()

})

testthat::test_that("Different searches yield different results", {

  search("educação") %>%
    waldo::compare(search("educação")) %>%
    length() %>%
    testthat::expect_equal(0)

  search("educação") %>%
    waldo::compare(search("água")) %>%
    length() %>%
    testthat::expect_gt(0)

})

testthat::test_that("Basic table column description", {

  result <- get_table_columns("br_sp_alesp", "deputado")

  testthat::expect_equal(nrow(result), 12)

})



