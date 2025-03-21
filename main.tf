module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = "10.0.0.0/16"
  private_subnet_1_cidr = "10.0.1.0/24"
  availability_zone_1   = "us-east-1a"
}

module "ldb_notifications_function" {
  source                = "./modules/lambda"
  lambda_name           = "ldb-notifications-function"
  lambda_role_name      = "lambda-role-execution"
  environment_variables = {}
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = [module.vpc.private_subnet_1_id]
}

module "ldb_documentation_function" {
  source                = "./modules/lambda"
  lambda_name           = "ldb-documentation-function"
  lambda_role_name      = "lambda-role-execution"
  environment_variables = {}
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = [module.vpc.private_subnet_1_id]
}

module "api_gateway" {
  source          = "./modules/api_gateway"
  api_name        = "agw-integration"
  api_description = "API que maneja múltiples Lambdas"
  stage_name      = "dev"

  lambda_routes = {
    "v1/utilities/notification"  = module.ldb_notifications_function.lambda_function_arn
    "v1/utilities/documentation" = module.ldb_documentation_function.lambda_function_arn
  }
}