

#' Slice a big data frame into smaller csv files by grouping variables
#' Still in development
#'
#' @description `partition_table` populates a folder
#'
#' @param .data a tibble.
#' @param dir directory where to write the csv files. Must exist before function call.
#' @param ... comma-separated variables used to define groupings.
#'
#' @return invisibly returns all written files' addresses.
#'
#' @examples
#'
#' \dontrun{
#'
#' tibble(
#'   x = rnorm(1000),
#'   y = runif(1000) + x,
#'   group = sample(letters, 1000, replace = TRUE)) %>%
#'   partition_table(tempdir())
#'
#'
#' }
#'
#'
#' @importFrom dplyr group_by group_split
#' @importFrom purrr walk2 map_chr
#' @importFrom rlang abort
#' @importFrom fs is_dir
#' @importFrom readr write_csv
#' @importFrom magrittr %>%
#'

partition_table <- function(.data, dir, ...) {

  if(!fs::is_dir(dir)) {

    rlang::abort("Argument `dir` must be a directory")

  }

  .data %>%
    dplyr::group_by(...) %>%
    dplyr::group_split() ->
    split_data

  purrr::walk2(
    .x = split_data,
    .y = paste0(1:length(split_data), ".csv"),
    function(.x, .y) {

      readr::write_csv(
        x = .x,
        file = file.path(dir, .y))

    }
  )

  invisible(fs::dir_ls(dir))

}

