data "aws_iam_role" "existing_lambda_role" {
  name = var.iam_role_name
}

resource "aws_iam_role" "lambda_role" {
  count = length(data.aws_iam_role.existing_lambda_role.arn) > 0 ? 0 : 1
  name  = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

data "aws_iam_policy" "existing_lambda_policy" {
  name = "${var.iam_role_name}-policy"
}

resource "aws_iam_policy" "lambda_policy" {
  count = length(data.aws_iam_policy.existing_lambda_policy.arn) > 0 ? 0 : 1
  name  = "${var.iam_role_name}-policy"
  description = "Permisos para Lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}