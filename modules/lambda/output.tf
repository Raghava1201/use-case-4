output "arn" {
  value       = aws_lambda_function.main.arn
  description = "ARN of the Lambda function"
}
 
output "invoke_arn" {
  value       = aws_lambda_function.main.invoke_arn
  description = "Invoke ARN of the Lambda function"
}