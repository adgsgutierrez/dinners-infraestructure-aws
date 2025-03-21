# 🔹 Crear API Gateway REST
resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = var.api_description
}

# 🔹 Crear recursos y métodos para cada Lambda
resource "aws_api_gateway_resource" "lambda_resources" {
  for_each    = var.lambda_routes
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = each.key
}

resource "aws_api_gateway_method" "lambda_methods" {
  for_each      = var.lambda_routes
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.lambda_resources[each.key].id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integrations" {
  for_each                = var.lambda_routes
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.lambda_resources[each.key].id
  http_method             = aws_api_gateway_method.lambda_methods[each.key].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = each.value
}

# 🔹 Crear Deployment
resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integrations]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = var.stage_name
}

# 🔹 Permitir que API Gateway invoque cada Lambda
resource "aws_lambda_permission" "apigw_permissions" {
  for_each      = var.lambda_routes
  statement_id  = "AllowAPIGatewayInvoke-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}
