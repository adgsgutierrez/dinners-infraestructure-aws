output "vpc_id" {
  description = "ID de la VPC creada"
  value       = length(aws_vpc.this) > 0 ? aws_vpc.this[0].id : null
}

output "private_subnet_1_id" {
  description = "ID de la primera subnet privada"
  value       = aws_subnet.private_1.id
}
