# note maxToReturn is only 500 by default...
processJSON <- function(raw, collapse="\n", quiet=T, errorOnNoRecords = F, maxToReturn = 500, ...) {

  `%>%` <- magrittr::`%>%`

  text <-
    raw %>%
    processRaw() %>%
    messages2text(quiet = quiet, collapse=collapse, errorOnNoRecords = errorOnNoRecords)

  if (is.null(text)) {
    if (errorOnNoRecords) {
      stop("Unexpected NULL returned from messages2text - was expecting it to error in this case")
    }
    if (!quiet) message("No text. Returning empty list")
    return(tibble::tibble())
  }

  textConnect <- textConnection(text, encoding = "UTF-8")
  on.exit({close.connection(textConnect)})
  jsonContent <-
    textConnect %>%
    jsonlite::stream_in(pagesize = maxToReturn)

  jsonContent
}
