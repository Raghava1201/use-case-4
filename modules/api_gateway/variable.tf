variable "api_name" {
  type        = string
  description = "Name of the API Gateway REST API"
}
 
variable "routes" {
  type = list(object({
    path = string
    method = string
    integration = object({
      type = string
      uri = string
      integration_type = string
      method = string
    })
  }))
  description = "List of API Gateway routes"
}