# Code in this file is based on code from https://github.com/cloudyr/aws.s3/
# All code in this file should be considered subject to GPL2 - see https://github.com/cloudyr/aws.s3/

# not so simple pass through to aws.s3::select_object
s3select <- function(request, bucket, object, headers = list()) {
  `%>%` <- magrittr::`%>%`

  request_body <- request %>% as.character()

  # aws.s3::select_object(
  #   bucket = bucket,
  #   object = object,
  #   request_body = request_body,
  #   parse_response = parse_response,
  #   ...
  # )

  if (missing(bucket)) {
    bucket <- aws.s3::get_bucketname(object)
  }

  object <- aws.s3::get_objectkey(object)

  r <- aws.s3:::s3HTTP(
    verb = "POST",
    bucket = bucket,
    path = paste0("/", object),
    headers = headers,
    query = list(select = "", `select-type` = "2"),
    request_body = request_body,
    parse_response = FALSE)

  detect_response_error(r)

  cont <- httr::content(r, as = "raw")

  return(cont)
}

# error detection pulled out of parse_aws_s3_reponse
detect_response_error <- function(httrResponse) {
  if (!httr::http_error(httrResponse) &
      (httr::http_status(httrResponse)[["category"]] != "Redirection")) {
    return(NULL)
  }

  h <- httr::headers(httrResponse)
  ctype <- h[["content-type"]]
  if (is.null(ctype) || ctype == "application/xml") {
    content <- httr::content(httrResponse, as = "text", encoding = "UTF-8")
    if (content != "") {
      response_contents <- xml2::as_list(xml2::read_xml(content))
      response <- aws.s3:::flatten_list(response_contents)
    }
    else {
      response <- NULL
    }
  }
  else {
    response <- httrResponse
  }
  out <- structure(response, headers = h, class = "aws_error")
  # commented out as Sig is not available in this call scope
  # attr(out, "request_canonical") <- Sig$CanonicalRequest
  # attr(out, "request_string_to_sign") <- Sig$StringToSign
  # attr(out, "request_signature") <- Sig$SignatureHeader
  print(out)
  httr::stop_for_status(httrResponse)
}
