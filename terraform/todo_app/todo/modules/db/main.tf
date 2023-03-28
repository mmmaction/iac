resource "aws_dynamodb_table" "todo_table" {
  name           = "${var.resource_prefix}-Todos"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 1
  hash_key       = "Id"

  attribute {
    name = "Id"
    type = "S"
  }

}
