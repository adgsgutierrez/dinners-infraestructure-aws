# 🔍 Buscar API Gateway existente
data "aws_api_gateway_rest_api" "existing_api" {
  name = var.api_name
}

# 🏗️ Crear API Gateway solo si NO existe
resource "aws_api_gateway_rest_api" "api" {
  count       = length(data.aws_api_gateway_rest_api.existing_api.id) > 0 ? 0 : 1
  name        = var.api_name
  description = var.api_description
}

# 🔹 Crear recursos y métodos solo si se crea el API Gateway
resource "aws_api_gateway_resource" "lambda_resources" {
  for_each    = var.lambda_routes
  rest_api_id = coalesce(
    try(aws_api_gateway_rest_api.api[0].id, ""),
    data.aws_api_gateway_rest_api.existing_api.id
  )
  parent_id   = coalesce(
    try(aws_api_gateway_rest_api.api[0].root_resource_id, ""),
    data.aws_api_gateway_rest_api.existing_api.root_resource_id
  )
  path_part   = each.key
}

resource "aws_api_gateway_method" "lambda_methods" {
  for_each    = var.lambda_routes
  rest_api_id = aws_api_gateway_resource.lambda_resources[each.key].rest_api_id
  resource_id = aws_api_gateway_resource.lambda_resources[each.key].id
  http_method = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integrations" {
  for_each               = var.lambda_routes
  rest_api_id            = aws_api_gateway_resource.lambda_resources[each.key].rest_api_id
  resource_id            = aws_api_gateway_resource.lambda_resources[each.key].id
  http_method            = aws_api_gateway_method.lambda_methods[each.key].http_method
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = each.value
}

# 🏗️ Crear Deployment solo si el API se creó
resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integrations]
  count       = length(data.aws_api_gateway_rest_api.existing_api.id) > 0 ? 0 : 1
  rest_api_id = coalesce(
    try(aws_api_gateway_rest_api.api[0].id, ""),
    data.aws_api_gateway_rest_api.existing_api.id
  )
  description = "Deployment de API Gateway"
}

# 🔹 Crear Stage SEPARADO (Usando el API existente o el nuevo)
resource "aws_api_gateway_stage" "stage" {
  stage_name    = var.stage_name
  rest_api_id   = coalesce(
    try(aws_api_gateway_rest_api.api[0].id, ""),
    data.aws_api_gateway_rest_api.existing_api.id
  )
  deployment_id = coalesce(
    try(aws_api_gateway_deployment.deployment[0].id, ""),
    data.aws_api_gateway_rest_api.existing_api.id
  )
  description   = "Stage de API Gateway para ${var.stage_name}"
}