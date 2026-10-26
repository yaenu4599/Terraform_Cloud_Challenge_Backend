output "api_domain_id" {
  description = "name of the api domain, idk it so i export it"
  value = aws_apigatewayv2_domain_name.main_api_domain.id
}