data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid = "AllowECSAndECSTasksToPutObject"
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.image_bucket_set_new.arn}/*",
    ]
  }

  statement {
    sid = "AllowLambdaToGetAndListObjects"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.image_bucket_set_new.arn,
      "${aws_s3_bucket.image_bucket_set_new.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    sid = "AllowS3Publish"
    principals {
      identifiers = ["s3.amazonaws.com"]
      type        = "Service"
    }
    actions = [
      "SNS:Publish",
    ]
    resources = [
      aws_sns_topic.image_notification.arn
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.image_bucket_set_new.arn]
    }
  }
}

data "aws_iam_policy_document" "sqs_policy" {
  statement {
    sid = "AllowSNSSendMessages"
    principals {
      identifiers = ["sns.amazonaws.com"]
      type        = "Service"
    }
    actions = [
      "sqs:SendMessage"
    ]
    resources = [
      aws_sqs_queue.image_sqs.arn
    ]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sqs_queue.image_sqs.arn]
    }
  }
}

