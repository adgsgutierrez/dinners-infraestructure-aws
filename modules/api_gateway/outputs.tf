output "api_gateway_id" {
  description = "ID del API Gateway"
  value       = aws_api_gateway_rest_api.api.id
}

output "api_gateway_invoke_url" {
  description = "URL base del API Gateway"
  value       = aws_api_gateway_deployment.deployment.invoke_url
}
