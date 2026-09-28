locals {
  general_tags = {
    ManagedBy   = var.managedby
    Environment = var.environment
    Project     = "Terraform-Resume-Challange"
  }
}


module "s3" {
  source = "./modules/s3"

  general_tags = local.general_tags
  environment  = var.environment

  bucket_main = var.bucket_main

  api_gate_way_url = module.http_api_gateway.api_visitors_url
}

module "cloudfornt" {
  source = "./modules/cloudfront"

  general_tags = local.general_tags
  environment  = var.environment

  main_bucket_arn                  = module.s3.main_bucket_arn
  main_bucket_name                 = module.s3.main_bucket_name
  main_bucket_id                   = module.s3.main_bucket_id
  main_bucket_regional_domain_name = module.s3.main_bucket_regional_domain_name

  root_domain = var.root_domain
  sub_domain  = var.sub_domain

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }
}

module "dynamodb" {
  source = "./modules/dynamodb"

  general_tags = local.general_tags
  environment  = var.environment
}

module "lambda" {
  source = "./modules/lambda"

  general_tags = local.general_tags
  environment  = var.environment

  dynamodb_table_name       = module.dynamodb.dynamodb_table_name
  lambda_execution_role_arn = var.lambda_execution_role_arn
}

module "http_api_gateway" {
  source = "./modules/api_gateway"

  general_tags = local.general_tags
  environment  = var.environment

  lambda_invoke_arn    = module.lambda.lambda_invoke_arn
  lambda_function_name = module.lambda.lambda_function_name
  allowed_origins      = ["https://${var.sub_domain}"]
}