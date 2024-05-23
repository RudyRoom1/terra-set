variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "dynamodb_name" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "subnet_ids" {
  description = "The list of IDs for the subnets"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "region_name" {
  description = "The name of the region"
  type        = string
}

variable "image_uri" {
  description = "URI of the Docker image"
  type        = string
}

variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "us-west-1"
}