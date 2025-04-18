resource "aws_iam_role" "lambda_role" {
  name_prefix = "${var.function_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}
 
resource "aws_iam_policy" "lambda_policy" {
  name_prefix = "${var.function_name}-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "dynamodb:PutItem",
          "dynamodb:GetItem"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.function_name}:*",
          "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.environment_variables.DYNAMODB_TABLE_NAME}"
        ]
      }
    ]
  })
}
 
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
 
resource "aws_lambda_function" "main" {
  function_name    = var.function_name
  runtime          = var.runtime
  handler          = var.handler
  memory_size      = var.memory_size
  timeout          = var.timeout
  filename         = var.filename
  source_code_hash = (var.filename)
  role             = aws_iam_role.lambda_role.arn
  environment {
    variables = var.environment_variables
  }
 
  depends_on = [aws_iam_role_policy_attachment.lambda_policy_attachment]
}
 
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}