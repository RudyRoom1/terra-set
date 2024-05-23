resource "aws_dynamodb_table" "recognition_results" {
  name           = "image_table_set_terra"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "ImageName"
  range_key      = "LabelValue"

  attribute {
    name = "ImageName"
    type = "S"
  }

  attribute {
    name = "LabelValue"
    type = "S"
  }

  depends_on = [aws_s3_bucket.image_bucket_set_new]
}