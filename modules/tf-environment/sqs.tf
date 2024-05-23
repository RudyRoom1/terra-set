resource "aws_sqs_queue" "image_sqs" {
  name       = var.sqs_name
  fifo_queue = false
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.image_sqs.id
  policy    = data.aws_iam_policy_document.sqs_policy.json
}

resource "aws_sns_topic_subscription" "subscription_name" {
  topic_arn = aws_sns_topic.image_notification.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.image_sqs.arn
}
