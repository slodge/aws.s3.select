# AWS S3 Select from R

R package assisting calling of `select_object` in [https://github.com/cloudyr/aws.s3/](aws.s3)

Note that this package currently calls an internal method of aws.s3

## Example Use

```
library(aws.s3.select)

s3_bucket_name <- "your bucket"
csv_path <- "your csv"

`%>%` <- magrittr::`%>%`

request <-
  s3selectRequest("SELECT * FROM s3Object s") %>%
  csvInput(fileHeaderInfo = "USE") %>%
  csvOutput()

response <- s3select(request, s3_bucket_name, csv_path)

csv <-
  response %>%
  processCSV()

json_path <- "your json"

request <-
  s3selectRequest("SELECT * FROM s3Object s") %>%
  jsonInput() %>%
  jsonOutput()

response <- s3select(request, s3_bucket_name, json_path)

json <-
  response %>%
  processJSON()
```

## Note

This package is not intended as a long lived solution... I'm hopeful this can be merged back into aws.s3 somehow

