terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
 
provider "aws" {
  region = var.region
}
 
# Module for DynamoDB Table
module "dynamodb_table" {
  source      = "./modules/dynamodb"
  table_name  = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  attributes = [
    {
      name = "UserID"
      type = "S"
    }
  ]
  hash_key = "UserID"
}
 
 
module "lambda_add" {
  source          = "./modules/lambda"
  function_name   = "${var.lambda_function_name_prefix}-add"
  runtime         = "python3.12"
  handler         = "main.handler"
  memory_size     = 128
  timeout         = 30
  environment_variables = {
    DYNAMODB_TABLE_NAME = module.dynamodb_table.table_name
  }
 
  filename      = "./modules/lambda/add_user.zip"
  depends_on    = [module.dynamodb_table]
}
 
# Module for Lambda Functions (Retrieve Data)
module "lambda_retrieve" {
  source          = "./modules/lambda"
  function_name   = "${var.lambda_function_name_prefix}-retrieve"
  runtime         = "python3.12"
  handler         = "main.handler"
  memory_size     = 128
  timeout         = 30
  environment_variables = {
    DYNAMODB_TABLE_NAME = module.dynamodb_table.table_name
  }
 
  filename      = "./modules/lambda/get_user.zip"
  depends_on    = [module.dynamodb_table]
}
 
 
module "api_gateway" {
  source      = "./modules/api_gateway"
  api_name    = var.api_gateway_name
 
  routes = [
    {
      path   = "/users"
      method = "POST"
      integration = {
        type            = "AWS_PROXY"
        uri             = module.lambda_add.invoke_arn
        integration_type = "AWS_PROXY"
        method          = "POST"
      }
    },
    {
      path   = "/users/{user_id}"
      method = "GET"
      integration = {
        type            = "AWS_PROXY"
        uri             = module.lambda_retrieve.invoke_arn
        integration_type = "AWS_PROXY"
        method          = "POST"
      }
    }
  ]
 
  depends_on = [module.lambda_add, module.lambda_retrieve]
}