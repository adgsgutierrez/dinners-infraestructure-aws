variable "api_name" {
  description = "Nombre del API Gateway"
  type        = string
}

variable "api_description" {
  description = "Descripción del API Gateway"
  type        = string
  default     = "API Gateway generado con Terraform"
}

variable "stage_name" {
  description = "Nombre del stage del API Gateway"
  type        = string
  default     = "dev"
}

variable "lambda_routes" {
  description = "Mapa de rutas y ARN de las Lambdas"
  type        = map(string)
}
