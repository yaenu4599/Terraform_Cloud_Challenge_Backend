output "lambda_function_name" {
  description = "name of the lambda function, used for the api gateway invoke permission"
  value       = aws_lambda_function.main.function_name
}

output "lambda_invoke_arn" {
  description = "invoke arn used by the api gateway integration"
  value       = aws_lambda_function.main.invoke_arn
}
