resource "aws_dynamodb_table" "main" {
  name         = "${var.environment}-WebsiteVisitors"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "visitors"

  attribute {
    name = "visitors"
    type = "S"
  }

  tags = merge(var.general_tags, {
    Name = "${var.environment}-WebsiteVisitors"
  })
}