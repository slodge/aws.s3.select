# Example Use...

devtools::load_all()

s3_bucket_name <- "your bucket"
csv_path <- "your csv"

`%>%` <- magrittr::`%>%`

request <-
  s3selectRequest("SELECT * FROM s3Object s WHERE CAST(num_comments AS FLOAT)>1000") %>%
  csvInput(fileHeaderInfo = "USE") %>%
  csvOutput()

response <- s3select(request  %>% as.character(), s3_bucket_name, csv_path)

csv <-
  response %>%
  processCSV()

request <-
  s3selectRequest("SELECT * FROM s3Object s") %>%
  csvInput(fileHeaderInfo = "USE") %>%
  jsonOutput()

response <- s3select(request  %>% as.character(), s3_bucket_name, csv_path)

json <-
  response %>%
  processJSON()
