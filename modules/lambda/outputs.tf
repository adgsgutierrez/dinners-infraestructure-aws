output "lambda_function_arn" {
  description = "ARN de la función Lambda"
  value       = aws_lambda_function.lambda_function.arn
}

output "lambda_security_group_id" {
  description = "Security Group asignado a la Lambda"
  value       = aws_security_group.lambda_sg.id
}