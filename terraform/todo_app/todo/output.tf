# API Gateway
output "api_gw_invoke_url" {
  value = module.api.api_invoke_url
}

output "api_gw_id" {
  value = module.api.api_gw_id
}


#Lambda
output "get_lambda_name" {
  value = module.lambda.get_lambda_name
}

