output "invoke_url" {
  value       = aws_api_gateway_stage.main.invoke_url
  description = "Invoke URL of the API Gateway stage"
}