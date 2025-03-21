resource "aws_security_group" "lambda_sg" {
  name        = "${var.lambda_name}-sg"
  description = "Allow internal traffic for Lambda"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 🔍 Buscar Lambda existente por nombre
data "aws_lambda_function" "existing_lambda" {
  function_name = var.lambda_name
}

# 🏗️ Crear Lambda solo si NO existe
resource "aws_lambda_function" "lambda_function" {
  count             = length(data.aws_lambda_function.existing_lambda.arn) > 0 ? 0 : 1
  function_name     = var.lambda_name
  role             = length(aws_iam_role.lambda_role) > 0 ? aws_iam_role.lambda_role[0].arn : data.aws_iam_role.existing_lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  filename         = "templates/nodejs.zip"
  source_code_hash = filebase64sha256("${path.module}/../templates/nodejs.zip")
  timeout          = 450
  memory_size      = 128

  environment {
    variables = var.environment_variables
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}