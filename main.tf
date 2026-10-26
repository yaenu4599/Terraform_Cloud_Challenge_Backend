#------------------------------
# preperation
#------------------------------

locals {

  hosted_zone_root = data.aws_route53_zone.hosted_zone_root.zone_id

  general_tags = {
    ManagedBy   = var.managedby
    Environment = var.environment
    Project     = "Terraform-Resume-Challange"
  }
}

# my hosted zone for the record and validation
data "aws_route53_zone" "hosted_zone_root" {
  name = var.root_domain
}

#------------------------------
# modules
#------------------------------

module "s3" {
  source = "./modules/s3"

  general_tags = local.general_tags
  environment  = var.environment

  bucket_main    = var.bucket_main
  cloudfront_arn = module.cloudfront.cloudfront_arn
}

module "cloudfront" {
  source = "./modules/cloudfront"

  general_tags = local.general_tags
  environment  = var.environment

  main_bucket_regional_domain_name = module.s3.main_bucket_regional_domain_name

  hosted_zone_root = local.hosted_zone_root
  root_domain      = var.root_domain
  sub_domain       = var.sub_domain

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

  hosted_zone_root     = local.hosted_zone_root
  lambda_invoke_arn    = module.lambda.lambda_invoke_arn
  lambda_function_name = module.lambda.lambda_function_name
  allowed_origins      = ["https://${var.sub_domain}"]
  api_sub_domain       = var.api_sub_domain
}