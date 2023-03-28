
data "aws_caller_identity" "current" {}

resource "aws_api_gateway_rest_api" "todo_api" {
  name = "${var.resource_prefix}-todo-api"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id

  depends_on = [
    aws_api_gateway_integration.get_request_method_integration,
    aws_api_gateway_integration.create_request_method_integration
  ] 

  lifecycle {
    create_before_destroy = true
  }  
}

resource "aws_api_gateway_stage" "api_gw_stage" {
  deployment_id        = aws_api_gateway_deployment.api_deployment.id
  rest_api_id          = aws_api_gateway_rest_api.todo_api.id
  stage_name           = var.stage_name
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  parent_id   = aws_api_gateway_rest_api.todo_api.root_resource_id
  path_part   = "todos"

}

# GET Request
resource "aws_api_gateway_method" "get_request_method" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.api_resource.id
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
}
resource "aws_api_gateway_integration" "get_request_method_integration" {
  rest_api_id             = aws_api_gateway_rest_api.todo_api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.get_request_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.get_lambda_arn}/invocations"
}
resource "aws_api_gateway_method_response" "get_response_method" {
  http_method = aws_api_gateway_integration.get_request_method_integration.http_method
  resource_id = aws_api_gateway_resource.api_resource.id
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

# POST Request
resource "aws_api_gateway_method" "create_request_method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.api_resource.id
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
}
resource "aws_api_gateway_integration" "create_request_method_integration" {
  rest_api_id             = aws_api_gateway_rest_api.todo_api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.create_request_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.create_lambda_arn}/invocations"
}
resource "aws_api_gateway_method_response" "create_response_method" {
  http_method = aws_api_gateway_integration.get_request_method_integration.http_method
  resource_id = aws_api_gateway_resource.api_resource.id
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  status_code = "201"
  response_models = {
    "application/json" = "Empty"
  }
}


resource "aws_lambda_permission" "apigw-get-lambda-allow" {
  action        = "lambda:InvokeFunction"
  function_name = var.get_lambda_name
  principal     = "apigateway.amazonaws.com"
  statement_id  = "AllowExecutionFromApiGateway"
  depends_on    = [aws_api_gateway_rest_api.todo_api, aws_api_gateway_resource.api_resource]
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.todo_api.id}/*/*"
}

resource "aws_lambda_permission" "apigw-create-lambda-allow" {
  action        = "lambda:InvokeFunction"
  function_name = var.create_lambda_name
  principal     = "apigateway.amazonaws.com"
  statement_id  = "AllowExecutionFromApiGateway"
  depends_on    = [aws_api_gateway_rest_api.todo_api, aws_api_gateway_resource.api_resource]
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.todo_api.id}/*/*"
}
