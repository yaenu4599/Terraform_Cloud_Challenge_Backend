output "cloudfront_arn" {
  description = "arn of the cloufront, used currently for the origin policy in the s3 module"
  value = aws_cloudfront_distribution.s3_distribution.arn
}