

test_that("partition_table retorna um erro caso o endereço não seja uma pasta", {

  expect_error(
    partition_table(
      .data = mtcars,
      path = file.path(tempdir(), "arquivo"),
      cyl)
  )
})
