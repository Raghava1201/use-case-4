resource "aws_api_gateway_rest_api" "main" {
  name        = var.api_name
  description = "API Gateway for User Data Management"
}
 
resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
 
 
  depends_on = [
    aws_api_gateway_integration.add_user,
    aws_api_gateway_integration.retrieve_user
  ]
}
 
resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = "prod"
}
 
resource "aws_api_gateway_resource" "users" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "users"
}
 
resource "aws_api_gateway_method" "post_users" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "POST"
  authorization = "NONE"
}
 
resource "aws_api_gateway_integration" "add_user" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.users.id
  http_method             = aws_api_gateway_method.post_users.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.routes[0].integration.uri
  passthrough_behavior    = "WHEN_NO_MATCH"
  content_handling        = "CONVERT_TO_TEXT"
}
 
resource "aws_lambda_permission" "add_user" {
  statement_id  = "AllowAPIGatewayInvoke-AddUser"
  action        = "lambda:InvokeFunction"
  function_name = element(split(":", var.routes[0].integration.uri), 6)
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}
 
resource "aws_api_gateway_resource" "user_id" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.users.id
  path_part   = "{user_id}"
}
 
resource "aws_api_gateway_method" "get_user" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.user_id.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.user_id" = true
  }
}
 
resource "aws_api_gateway_integration" "retrieve_user" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.user_id.id
  http_method             = aws_api_gateway_method.get_user.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.routes[1].integration.uri
  passthrough_behavior    = "WHEN_NO_MATCH"
  content_handling        = "CONVERT_TO_TEXT"
}
 
resource "aws_lambda_permission" "retrieve_user" {
  statement_id  = "AllowAPIGatewayInvoke-RetrieveUser"
  action        = "lambda:InvokeFunction"
  function_name = element(split(":", var.routes[1].integration.uri), 6)
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}
 
 
data "aws_region" "current" {
 
}