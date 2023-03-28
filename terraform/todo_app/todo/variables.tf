
variable "resource_prefix" {
  description = "prefix every resource will use"
  type        = string
}

variable "resource_env" {
  type = string
}

variable "stage_name" {
  type = string
}

variable "lambda_memory_size" {
  type = number
}

variable "lambda_runtime" {
  type = string
}

