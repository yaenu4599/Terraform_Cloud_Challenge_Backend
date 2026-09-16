locals {
  general_tags = {
    ManagedBy   = var.managedby
    Environment = var.environment
  }
}


module "s3" {
  source = "./modules/s3"

  general_tags = local.general_tags
  environment  = var.environment

  bucket_main = var.bucket_main

}

module "cloudfornt" {
  source = "./modules/cloudfront"

  general_tags = local.general_tags
  environment  = var.environment

  main_bucket_arn                  = module.main_bucket_arn
  main_bucket_name                 = module.main_bucket_name
  main_bucket_id                   = module.main_bucket_id
  main_bucket_regional_domain_name = module.main_bucket_regional_domain_name

  root_domain = var.root_domain
  sub_domain  = var.sub_domain

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }
}