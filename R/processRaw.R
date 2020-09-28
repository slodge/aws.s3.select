# parses according to spec on https://docs.aws.amazon.com/AmazonS3/latest/API/RESTSelectObjectAppendix.html
processRaw <- function(response, quiet = T) {
  if (!quiet) message("Parsing response")

  totalLength <- length(response)
  connection <- rawConnection(response, "r")

  on.exit({
    close.connection(connection)
  }, add=TRUE)

  messages <- list()

  while(seek(connection) < totalLength) {
    messageStart <- seek(connection)
    fullSize <- readBin(connection, "integer", size=4, endian = "big")
    headerSize <- readBin(connection, "integer", size=4, endian = "big")
    ignoredCrc <- readBin(connection, "integer", size=4, endian = "big")
    payloadSize <- fullSize - headerSize - 16
    if (!quiet) message("New message, fullSize:", fullSize, " including header: ", headerSize, " and payload: ", payloadSize)

    message <- list()

    while (seek(connection) < messageStart + headerSize + 12) {
      if (seek(connection) >= totalLength) {
        stop("Parse error - we have exceed the total response body length while parsing headers")
      }

      headerNameLen <- readBin(connection, "integer", size=1, endian = "big")
      headerName <- readChar(connection, headerNameLen)
      headerValueType <- readBin(connection, "integer", size=1, endian = "big")
      headerValueLen <-  readBin(connection, "integer", size=2, endian = "big")
      headerValue <- readChar(connection, headerValueLen)
      if (!quiet) message("New header: '", headerName, "'. Value: '", headerValue, "'")

      if (headerName == "payload") {
        stop("Unexpected headerName - header cannot be called 'payload'")
      }

      message[headerName] <- headerValue
    }

    message$payload <- readBin(connection, "raw", n=payloadSize)
    ignoredCrc2 <- readBin(connection, "integer", size=4, endian = "big")

    messages <- c(messages, list(message))

    if (seek(connection) > totalLength) {
      stop("Parse error - we have exceed the total response body length while reading the body")
    }
  }
  if (seek(connection) < totalLength) {
    stop("Parse error - we stopped parsing early - current position ", seek(connection), " total length ", totalLength)
  }
  if (seek(connection) > totalLength) {
    stop("Parse error - we overran during parsing - current position ", seek(connection), " total length ", totalLength)
  }
  if (!quiet) message("Parsing complete")
  messages
}
