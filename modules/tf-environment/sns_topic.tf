resource "aws_sns_topic" "image_notification" {
  name = var.sns_name
}

resource "aws_s3_bucket_notification" "s3_image_notification" {
  bucket = aws_s3_bucket.image_bucket_set_new.id

  topic {
    topic_arn = aws_sns_topic.image_notification.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

resource "aws_sns_topic_policy" "sns_topic_policy" {
  arn    = aws_sns_topic.image_notification.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}


resource "aws_s3_bucket_notification" "sqs_image" {
  bucket = aws_s3_bucket.image_bucket_set_new.id

  topic {
    topic_arn = aws_sns_topic.image_notification.arn
    events    = ["s3:ObjectCreated:*"]
  }
}
