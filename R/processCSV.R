processCSV <- function(raw, collapse="\n", quiet=T, errorOnNoRecords = F, col_names = F, ...) {

  `%>%` <- magrittr::`%>%`

  text <-
    raw %>%
    processRaw() %>%
    messages2text(quiet = quiet, collapse=collapse, errorOnNoRecords = errorOnNoRecords)

  if (is.null(text)) {
    if (errorOnNoRecords) {
      stop("Unexpected NULL returned from messages2text - was expecting it to error in this case")
    }
    if (!quiet) message("No text. Returning empty tibble")
    return(tibble::tibble())
  }

  csvContent <-
    text %>%
    readr::read_csv(col_names = col_names, ...)

  csvContent
}
