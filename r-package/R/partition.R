

#' Slice a big data frame into smaller csv files by grouping variables
#'
#' @param .data a tibble.
#' @param path directory where to write the csv files. Must exist before function call.
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
#'   partition_table("simulated_data/")
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
#'

partition_table <- function(.data, path, ...) {

  .data %>%
    dplyr::group_by(...) %>%
    dplyr::group_split() ->
    split_data

  if(!fs::is_dir(path)) {

    rlang::abort("Argument `path` must be a directory")

  }

  purrr::walk2(
    .x = split_data,
    .y = paste0(1:length(split_data), ".csv"),
    function(x) {

      readr::write_csv(
        x = .x,
        file = file.path(path, .y))

    }
  )

  purrr::map_chr(
    data_names,
    ~ glue::glue("{path}/{.x}.csv")) %>%
  invisible()

}

