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

variable "bucket_main" {
  description = "s3 bucked containing the index file and images"
  type        = string
}

