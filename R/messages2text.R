messages2text <- function(messages, quiet=T, errorOnNoRecords = F, collapse="\n", ...) {

  `%>%` <- magrittr::`%>%`

  records <-
    messages %>%
    messages2records(quiet = quiet)

  # we might need to do some other handling here... e.g returning an empty tibble?
  if (length(records) == 0) {
    if (errorOnNoRecords) {
      stop("No payload records seen")
    }
    if (!quiet) message("Returning NULL")
    return(NULL)
  }

  # TODO: is readChar good enough for what I assume is "UTF-8"encoded text?
  text_records <-
    records  %>%
    purrr::map_chr(~ readChar(.x, n = length(.x))) %>%
    paste(collapse=collapse)

  text_records
}
