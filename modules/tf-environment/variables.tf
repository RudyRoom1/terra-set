variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket to create"
}

variable "sns_name" {
  type        = string
  description = "Name of the SNS topic to create"
}

variable "sqs_name" {
  type        = string
  description = "Name of the SNS topic to create"
}

variable "security_group_name" {
  type        = string
  description = "Name of the SECURITY GROUP to create"
}
