# https://docs.aws.amazon.com/AmazonS3/latest/API/API_SelectObjectContent.html
s3selectRequest <- function(sqlQuery) {
  `%>%` <- magrittr::`%>%`

  xml2::xml_new_root("SelectObjectContentRequest",
                     xmlns = "http://s3.amazonaws.com/doc/2006-03-01/") %>%
    xml2::xml_add_child("Expression", sqlQuery)  %>%
    xml2::xml_add_sibling("ExpressionType", "SQL") %>%
    xml2::xml_parent()
}

# https://docs.aws.amazon.com/AmazonS3/latest/API/API_CSVInput.html
csvInput <- function(
  request,
  compressionType = NULL,
  fileHeaderInfo =  NULL,
  allowQuotedRecordDelimiter = NULL,
  comments = NULL,
  fieldDelimiter = NULL,
  quoteCharacter = NULL,
  quoteEscapeCharacter = NULL,
  recordDelimiter = NULL) {

  `%>%` <- magrittr::`%>%`

  request %>%
    xml2::xml_add_child("InputSerialization")  %>%
    optionalAddChildWithValue("CompressionType", compressionType)  %>%
    xml2::xml_add_child("CSV")  %>%
    optionalAddChildWithValue("FileHeaderInfo", fileHeaderInfo)  %>%
    optionalAddChildWithValue("AllowQuotedRecordDelimiter", allowQuotedRecordDelimiter)  %>%
    optionalAddChildWithValue("Comments", comments)  %>%
    optionalAddChildWithValue("FieldDelimiter", fieldDelimiter)  %>%
    optionalAddChildWithValue("QuoteCharacter", quoteCharacter)  %>%
    optionalAddChildWithValue("QuoteEscapeCharacter", quoteEscapeCharacter)  %>%
    optionalAddChildWithValue("RecordDelimiter", recordDelimiter)  %>%
    xml2::xml_parent() %>%
    xml2::xml_parent()
}

# https://docs.aws.amazon.com/AmazonS3/latest/API/API_CSVOutput.html
csvOutput <- function(
  request,
  allowQuotedRecordDelimiter = NULL,
  fieldDelimiter = NULL,
  quoteCharacter = NULL,
  quoteEscapeCharacter = NULL,
  recordDelimiter = NULL) {

  `%>%` <- magrittr::`%>%`

  request %>%
    xml2::xml_add_child("OutputSerialization")  %>%
    xml2::xml_add_child("CSV")  %>%
    optionalAddChildWithValue("AllowQuotedRecordDelimiter", allowQuotedRecordDelimiter)  %>%
    optionalAddChildWithValue("FieldDelimiter", fieldDelimiter)  %>%
    optionalAddChildWithValue("QuoteCharacter", quoteCharacter)  %>%
    optionalAddChildWithValue("QuoteEscapeCharacter", quoteEscapeCharacter)  %>%
    optionalAddChildWithValue("RecordDelimiter", recordDelimiter)  %>%
    xml2::xml_parent() %>%
    xml2::xml_parent()
}

# https://docs.aws.amazon.com/AmazonS3/latest/API/API_JSONInput.html
jsonInput <- function(
  request,
  compressionType = NULL,
  type =  NULL) {

  `%>%` <- magrittr::`%>%`

  request %>%
    xml2::xml_add_child("InputSerialization")  %>%
    optionalAddChildWithValue("CompressionType", compressionType)  %>%
    xml2::xml_add_child("JSON")  %>%
    optionalAddChildWithValue("Type", type)
  xml2::xml_parent() %>%
    xml2::xml_parent()
}

# https://docs.aws.amazon.com/AmazonS3/latest/API/API_JSONOutput.html
jsonOutput <- function(
  request,
  recordDelimiter = NULL) {

  `%>%` <- magrittr::`%>%`

  request %>%
    xml2::xml_add_child("OutputSerialization")  %>%
    xml2::xml_add_child("JSON")  %>%
    optionalAddChildWithValue("RecordDelimiter", recordDelimiter) %>%
    xml2::xml_parent() %>%
    xml2::xml_parent()
}


# https://docs.aws.amazon.com/AmazonS3/latest/API/API_ParquetInput.html
parquetInput <- function(
  request,
  compressionType = NULL) {

  `%>%` <- magrittr::`%>%`

  request %>%
    xml2::xml_add_child("InputSerialization")  %>%
    optionalAddChildWithValue("CompressionType", compressionType)  %>%
    xml2::xml_add_child("Parquet")  %>%
    xml2::xml_parent() %>%
    xml2::xml_parent()
}

# https://docs.aws.amazon.com/AmazonS3/latest/API/API_RequestProgress.html
requestProgress <- function(request, enabled = TRUE) {
  `%>%` <- magrittr::`%>%`

  request %>%
    xml2::xml_add_child("RequestProgress")  %>%
    optionalAddChildWithValue("Enabled", enabled) %>%
    xml2::xml_parent()
}

# https://docs.aws.amazon.com/AmazonS3/latest/API/API_ScanRange.html
scanRange <- function(request, start = NULL, end = NULL) {
  `%>%` <- magrittr::`%>%`

  request %>%
    xml2::xml_add_child("ScanRange")  %>%
    optionalAddChildWithValue("Start", start) %>%
    optionalAddChildWithValue("End", end) %>%
    xml2::xml_parent()
}

optionalAddChildWithValue <- function(request, name, value)  {
  if (is.null(value)) return(request)

  `%>%` <- magrittr::`%>%`

  request %>%
    xml2::xml_add_child(name, value)  %>%
    xml2::xml_parent()
}


