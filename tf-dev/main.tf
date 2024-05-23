provider "aws" {
  region = "us-west-1"
}

module "environment" {
  source = "../modules/tf-environment/"

  bucket_name         = "image-bucket-dev-terra"
  sns_name            = "image-sns-dev_terra"
  sqs_name            = "image-sqs-dev_terra"
  security_group_name = "SecurityGroupForEndpointsTerra"
}

module "application" {
  source = "../modules/tf-application/"

  bucket_name   = module.environment.bucket_name
  dynamodb_name = module.environment.dynamodb_table_name
  subnet_ids    = [module.environment.subnet_id_a, module.environment.subnet_id_b]
  vpc_id        = module.environment.default_vpc_id
  region_name   = module.environment.default_region_name
  image_uri     = "211125684549.dkr.ecr.us-west-1.amazonaws.com/set.rogram/image.repository"
}
