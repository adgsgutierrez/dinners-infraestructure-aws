output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.this.id
}

output "private_subnet_1_id" {
  description = "ID de la primera subnet privada"
  value       = aws_subnet.private_1.id
}
