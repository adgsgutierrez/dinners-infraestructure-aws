variable "iam_role_name" {
  description = "Nombre del IAM Role para la Lambda"
  type        = string
}

variable "lambda_name" {
  description = "Nombre de la función Lambda"
  type        = string
}

variable "environment_variables" {
  description = "Variables de entorno para la Lambda"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID de la VPC donde se desplegará la Lambda"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de Subnets privadas donde se ejecutará la Lambda"
  type        = list(string)
}