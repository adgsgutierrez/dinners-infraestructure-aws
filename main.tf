module "vpc" {
  source                 = "./modules/vpc"
  vpc_cidr               = "10.0.0.0/16"
  private_subnet_1_cidr  = "10.0.1.0/24"
  availability_zone_1    = "us-east-1a"
}