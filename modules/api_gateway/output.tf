output "api_visitors_url" {
  description = "full url the website calls to increase the visitor count"
  value       = "${aws_apigatewayv2_stage.main.invoke_url}visitors"
}
