variable "function_name" {
  type        = string
  description = "Name of the Lambda function"
}
 
variable "runtime" {
  type        = string
  description = "Runtime environment for the Lambda function"
}
 
variable "handler" {
  type        = string
  description = "Handler function for the Lambda function"
}
 
variable "memory_size" {
  type        = number
  description = "Memory allocation for the Lambda function (in MB)"
}
 
variable "timeout" {
  type        = number
  description = "Execution timeout for the Lambda function (in seconds)"
}
 
variable "filename" {
  type        = string
  description = "Path to the Lambda function deployment package (.zip file)"
}
 
variable "environment_variables" {
  type        = map(string)
  description = "Environment variables for the Lambda function"
  default     = {}
}