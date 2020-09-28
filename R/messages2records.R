messages2records <- function(messages, quiet=T) {
  if (length(messages) == 0) {
    stop("No messages seen")
  }

  `%>%` <- magrittr::`%>%`

  lastMessage <-
    messages %>%
    utils::tail(1) %>%
    unlist()

  if (lastMessage[[":message-type"]] != "event"
      || lastMessage[[":event-type"]] != "End") {
    stop("Our stream did not end with and End event, instead it ended with ", lastMessage)
  }

  records <-
    messages %>%
    purrr::keep(~ .x[":message-type"] == "event") %>%
    purrr::keep(~ .x[":event-type"] == "Records") %>%
    purrr::map("payload")

  if (!quiet) message(length(records), " payload records seen")
  records
}
