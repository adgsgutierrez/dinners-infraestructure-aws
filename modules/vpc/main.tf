# 🔍 Buscar VPC existente por CIDR
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "cidr-block"
    values = [var.vpc_cidr]
  }
}

# 🏗️ Crear VPC solo si NO existe
resource "aws_vpc" "this" {
  count      = length(data.aws_vpc.existing_vpc.id) > 0 ? 0 : 1
  cidr_block = var.vpc_cidr
}

# 🔹 Crear Subnet en VPC existente o recién creada
resource "aws_subnet" "private_1" {
  vpc_id            = coalesce(
    try(aws_vpc.this[0].id, ""),
    data.aws_vpc.existing_vpc.id
  )
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.availability_zone_1
}