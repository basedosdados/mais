# get_metadata_table tests

test_that("get_metadata_table sem dataset_id", {
  expect_error(
    get_table_metadata(
      table_id = "municipios"
    )
  )
})

test_that("get_metadata_table sem table_id", {
  expect_error(
    get_table_metadata(
      "br_ibge_pib"
    )
  )
})


test_that("get_metadata_table retorna invisible", {
  expect_invisible(
    get_table_metadata(
      "br_ibge_populacao",
      "municipio"
    )
  )
})

# get_dataset_metadata tests

test_that("get_dataset_metadata com dataset_id que não existe", {
  expect_error(
    get_dataset_metadata("tuturu")
  )
})


test_that("get_dataset_metadata sem dataset_id", {
  expect_error(
    get_dataset_metadata()
  )
})

test_that("get_metadata_table retorna invisible", {
  expect_invisible(
    get_dataset_metadata(
      "br_inep_ideb",
    )
  )
})


# list_datasets tests

test_that("list_datasets retorna invisible", {
  expect_invisible(
    list_datasets()
  )
})

test_that("list_datasets com param adicionais", {
  expect_error(
    list_datasets(page_size = 100000)
  )
})


# list_dataset_tables tests

test_that("list_dataset_tables sem dataset_id", {
  expect_error(
    list_dataset_tables()
  )
})

test_that("list_dataset_tables sem dataset_id", {
  expect_invisible(
    list_dataset_tables("br_ibge_inflacao")
  )
})
