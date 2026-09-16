output "main_bucket_arn" {
  description = "arn for th maine bucked holding the index"
  value       = aws_s3_bucket.main.arn
}

output "main_bucket_name" {
  description = "arn for the maine bucked holding the index"
  value       = aws_s3_bucket.main.bucket
}

output "main_bucket_id" {
  description = "id of the main bucked to use for other resources"
  value       = aws_s3_bucket.main.id
}

output "main_bucket_regional_domain_name" {
  description = "regional domain name used as cloudfront origin"
  value       = aws_s3_bucket.main.bucket_regional_domain_name
}