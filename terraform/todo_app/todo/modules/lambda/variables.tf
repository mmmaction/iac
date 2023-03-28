
# get information about currently used AWS account
data "aws_partition" "current" {}

locals {
  get_todos_lambda_name    = "${var.resource_prefix}-get-todos"
  create_todos_lambda_name = "${var.resource_prefix}-create-todos"
}


variable "resource_prefix" {
  type = string
}

variable "memory_size" {
  description = "Amount of memory in MB lambdas can use at runtime"
  type        = number
}

variable "runtime" {
  description = "runtime of the lambda functions"
  type        = string
}

variable "table_name" {
  description = "The name of the db table to use"
}

variable "table_arn" {
  description = "The arn of the db table to use"
}

