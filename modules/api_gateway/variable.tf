#-------------------------------------------------------------
# general tags
#-------------------------------------------------------------

variable "general_tags" {
  description = "to add tags for each resource terraform manages"
  type        = map(string)
}

variable "environment" {
  description = "to tag all the resources with an environment"
  type        = string
}

#-------------------------------------------------------------
# input
#-------------------------------------------------------------

variable "hosted_zone_root" {
  description = "wich hosted zone the records should be created"
  type = string
}

variable "lambda_invoke_arn" {
  description = "invoke arn of the lambda the api forwards requests to"
  type        = string
}

variable "lambda_function_name" {
  description = "name of the lambda, needed to allow the api gateway to invoke it"
  type        = string
}

variable "allowed_origins" {
  description = "origins (website domains) allowed to call the api from the browser"
  type        = list(string)
}

variable "api_sub_domain" {
  description = "to give the api a specific domain, that it does not change everytime"
  type        = string
}

