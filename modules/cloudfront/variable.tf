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

variable "main_bucket_regional_domain_name" {
  description = "regional domain name used as cloudfront origin"
  type        = string
}

variable "root_domain" {
  description = "root domain of the private hosted zone"
  type        = string
}
variable "sub_domain" {
  description = "currently for testing, to see if the creat process works"
  type        = string
}





