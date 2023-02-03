#' @export
setClass("BaseDosDadosConnection", contains = "BigQueryConnection")

#' @export
dbplyr_edition.BaseDosDadosConnection <- function(con) 2L
