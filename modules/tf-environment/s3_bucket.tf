resource "aws_s3_bucket" "image_bucket_set_new" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.image_bucket_set_new.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.image_bucket_set_new.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_acl" "set_program_bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership_controls,
    aws_s3_bucket_public_access_block.public_access
  ]

  bucket = aws_s3_bucket.image_bucket_set_new.id
  acl    = "public-read-write"

}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.image_bucket_set_new.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

