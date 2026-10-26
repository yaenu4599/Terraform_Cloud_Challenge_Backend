#---------------------
# api creation
#----------------------

resource "aws_apigatewayv2_api" "main_api_gateway" {
  name          = "${var.environment}-http-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = var.allowed_origins
    allow_methods = ["POST"]
  }

  tags = merge(var.general_tags, {
    Name = "${var.environment}-http-api"
  })
}

resource "aws_apigatewayv2_integration" "main_api_integration" {
  api_id                 = aws_apigatewayv2_api.main_api_gateway.id
  integration_type       = "AWS_PROXY"
  description            = "Lambda"
  integration_method     = "POST"
  integration_uri        = var.lambda_invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "main_api_route" {
  api_id    = aws_apigatewayv2_api.main_api_gateway.id
  route_key = "POST /visitors"
  target    = "integrations/${aws_apigatewayv2_integration.main_api_integration.id}"
}

resource "aws_apigatewayv2_stage" "main_api_stage" {
  api_id      = aws_apigatewayv2_api.main_api_gateway.id
  name        = "$default"
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = 10
    throttling_rate_limit  = 5
  }

  tags = merge(var.general_tags, {
    Name = "${var.environment}-http-api-stage"
  })
}

resource "aws_apigatewayv2_api_mapping" "main_api_mapping" {
  api_id      = aws_apigatewayv2_api.main_api_gateway.id
  domain_name = aws_apigatewayv2_domain_name.main_api_domain.id
  stage       = aws_apigatewayv2_stage.main_api_stage.id
}

#-----------------------------------------
# cert
#----------------------------------------

resource "aws_acm_certificate" "main_api_cert" {
  domain_name       = var.api_sub_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

    tags = merge(var.general_tags, {
    Name = "api-cert-${var.api_sub_domain}"
  })
}

resource "aws_route53_record" "main_api_cert_record" {
  for_each = {
    for dvo in aws_acm_certificate.main_api_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.hosted_zone_root
}

resource "aws_acm_certificate_validation" "main_api_cert_validation" {
  certificate_arn         = aws_acm_certificate.main_api_cert.arn
  validation_record_fqdns = [for r in aws_route53_record.main_api_cert_record : r.fqdn]
}

#---------------------
# domain 
#----------------------

resource "aws_apigatewayv2_domain_name" "main_api_domain" {
  domain_name = var.api_sub_domain

  domain_name_configuration {
    certificate_arn = aws_acm_certificate_validation.main_api_cert_validation.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = merge( var.general_tags, {
    Name = "api-domain-${var.api_sub_domain}"
  })
}

resource "aws_route53_record" "main_api_record" {
  zone_id = var.hosted_zone_root
  name    = var.api_sub_domain
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.main_api_domain.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.main_api_domain.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

#---------------------
# lambda permission
#----------------------

resource "aws_lambda_permission" "lambda_api_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main_api_gateway.execution_arn}/*/*/visitors"
}


