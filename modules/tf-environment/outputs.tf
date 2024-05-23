output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.image_bucket_set_new.bucket
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  value       = aws_dynamodb_table.recognition_results.name
}

output "subnet_id_a" {
  description = "The ID of the default subnet a"
  value       = aws_default_subnet.default_subnet_a.id
}

output "subnet_id_b" {
  description = "The ID of the default subnet b"
  value       = aws_default_subnet.default_subnet_b.id
}

output "default_vpc_id" {
  description = "The ID of the default VPC"
  value       = data.aws_vpc.default.id
}

output "default_region_name" {
  description = "The name of the default region"
  value       = data.aws_region.current.name
}

output "sns" {
  description = "The name of the default region"
  value       = var.sns_name
}

output "sqs" {
  description = "The name of the default region"
  value       = var.sqs_name
}

output "security" {
  description = "The name of the default region"
  value       = var.security_group_name
}