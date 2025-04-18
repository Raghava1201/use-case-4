variable "table_name" {
  type        = string
  description = "Name of the DynamoDB table"
}
 
variable "billing_mode" {
  type        = string
  description = "Billing mode for the DynamoDB table (PROVISIONED or PAY_PER_REQUEST)"
}
 
variable "hash_key" {
  type        = string
  description = "Name of the hash key attribute"
}
 
variable "range_key" {
  type        = string
  description = "Name of the range key attribute (optional)"
  default     = null
}
 
variable "attributes" {
  type = list(object({
    name = string
    type = string
  }))
  description = "List of attribute definitions"
  default     = []
}