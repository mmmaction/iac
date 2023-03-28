locals {

  resource_env = "dev"

  tag_owner       = "team x"
  tag_project     = "todo"
}

variable "resource_prefix" {
  type = string
  default = "todo-dev"
}