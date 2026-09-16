#-------------------------------------------------------------
# general tags
#-------------------------------------------------------------

variable "environment" {
  description = "to tag all the resources with an environment"
  type = string
  default = "dev"
}

variable "managedby" {
  description = "to tag resources add with terraform"
  type = string
  default = "terraform"
}

#-------------------------------------------------------------
# s3
#-------------------------------------------------------------

variable "bucket_main" {
  description = "s3 bucked containing the index file and images"
  type = string
}

#-------------------------------------------------------------
# cloudfront
#-------------------------------------------------------------

variable "root_domain" {
  description = "root domain of the private hosted zone"
  type = string
  default = "resume-challange-yannik-hofer.com"
}
variable "sub_domain" {
  description = "currently for testing, to see if the creat process works"
  type = string
  default = "test/resume-challange-yannik-hofer.com"
}