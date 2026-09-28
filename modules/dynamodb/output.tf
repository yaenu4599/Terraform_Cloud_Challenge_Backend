output "dynamodb_table_name" {
  description = "name of the table holding the visitor count"
  value       = aws_dynamodb_table.main.name
}

output "dynamodb_table_arn" {
  description = "arn of the table, needed for the lambda iam policy"
  value       = aws_dynamodb_table.main.arn
}
