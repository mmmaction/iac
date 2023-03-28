output "get_lambda_name" {
  description = "The name of the get todos Lambda function"
  value       = aws_lambda_function.get_todos_lambda.function_name
}

output "get_lambda_arn" {
  description = "The arn of the get todos Lambda function"
  value       = aws_lambda_function.get_todos_lambda.arn
}

output "create_lambda_name" {
  description = "The name of the create todos Lambda function"
  value       = aws_lambda_function.create_todos_lambda.function_name
}

output "create_lambda_arn" {
  description = "The arn of the create todos Lambda function"
  value       = aws_lambda_function.create_todos_lambda.arn
}
