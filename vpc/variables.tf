variable "vpc_cidr" {
  description = "CIDR block de la VPC"
  type        = string
}

variable "private_subnet_1_cidr" {
  description = "CIDR block para la primera subnet privada"
  type        = string
}

variable "availability_zone_1" {
  description = "Zona de disponibilidad para la primera subnet"
  type        = string
}
