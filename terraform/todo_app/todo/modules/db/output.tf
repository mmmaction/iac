output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = aws_dynamodb_table.todo_table.name
}

output "dynamodb_table_arn" {
  description = "DynamoDB table arn"
  value       = aws_dynamodb_table.todo_table.arn
}
