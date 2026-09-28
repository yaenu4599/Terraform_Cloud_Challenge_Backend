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

variable "dynamodb_table_name" {
  description = "Name of the dynamodb table"
  type        = string
}

variable "lambda_execution_role_arn" {
  type        = string
  description = "arn of the manually created iam role for the lambda function"
}