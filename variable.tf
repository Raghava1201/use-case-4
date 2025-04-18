variable "region" {
  type        = string
  description = "AWS region to deploy resources in"
  default     = "us-east-1" #
}
 
variable "dynamodb_table_name" {
  type        = string
  description = "Name of the DynamoDB table for user data"
  default     = "UserDataTable"
}
 
variable "lambda_function_name_prefix" {
  type        = string
  description = "Prefix for the Lambda function names"
  default     = "user-data"
}
 
variable "api_gateway_name" {
  type        = string
  description = "Name of the API Gateway REST API"
  default     = "UserDataAPI"
}