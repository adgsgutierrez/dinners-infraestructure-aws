output "api_gateway_id" {
  description = "ID del API Gateway"
  value       = length(aws_api_gateway_rest_api.api) > 0 ? aws_api_gateway_rest_api.api[0].id : null
}

output "api_gateway_invoke_url" {
  description = "URL base del API Gateway"
  value       = aws_api_gateway_stage.stage.invoke_url
}
