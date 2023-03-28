output "api_invoke_url" {
  description = "Deployment invoke url"
  value       = aws_api_gateway_deployment.api_deployment.invoke_url
}

output "api_gw_id" {
  description = "Deployment id"
  value       = aws_api_gateway_rest_api.todo_api.id
}
