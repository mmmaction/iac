variable "resource_prefix" {
  type = string
}


variable "stage_name" {
  type    = string
  default = "dev"
}

variable "region" {
  description = "The AWS region"
  default     = "eu-west-1"
}

variable "get_lambda_arn" {
  description = "The ARN of the get todos Lambda to invoke"
}

variable "get_lambda_name" {
  description = "The name of the get todos Lambda to invoke"
}

variable "create_lambda_arn" {
  description = "The ARN of the create todos Lambda to invoke"
}

variable "create_lambda_name" {
  description = "The name of the create todos Lambda to invoke"
}

