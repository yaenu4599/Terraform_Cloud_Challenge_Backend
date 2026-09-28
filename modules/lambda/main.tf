data "archive_file" "main" {
  type        = "zip"
  source_file = "${path.module}/src/lambda_function.py"
  output_path = "${path.module}/build/lambda_function.zip"
}

resource "aws_lambda_function" "main" {
  function_name = "${var.environment}-visitor-counter"
  role          = var.lambda_execution_role_arn
  runtime       = "python3.13"
  handler       = "lambda_function.lambda_handler"

  filename         = data.archive_file.main.output_path
  source_code_hash = data.archive_file.main.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = var.dynamodb_table_name
    }
  }

  tags = merge(var.general_tags, {
    Name = "${var.environment}-visitor-counter"
  })
}
