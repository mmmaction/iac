
data "archive_file" "lambda_src_archive" {
  type        = "zip"
  #source_file = "../../get_todos.js"
  source_dir = "../../src"
  output_path = "../../src.zip"
  #output_path = "../../get_todos.zip"
}

# data "archive_file" "create_lambda_archive" {
#   type        = "zip"
#   #source_file = "../../create_todos.js"
#   output_path = "../../create_todos.zip"
# }

resource "aws_lambda_function" "get_todos_lambda" {
  function_name    = local.get_todos_lambda_name
  role             = aws_iam_role.lambda_execution_role.arn
  memory_size      = var.memory_size
  timeout          = 5
  runtime          = var.runtime
  filename         = "../../src.zip"
  handler          = "get_todos.handler"
  source_code_hash = data.archive_file.lambda_src_archive.output_base64sha256

  environment {
    variables = {
      DEPLOYMENT_NAME = var.resource_prefix
      TABLE_NAME      = var.table_name
    }
  }
}

resource "aws_lambda_function" "create_todos_lambda" {
  function_name    = local.create_todos_lambda_name
  role             = aws_iam_role.lambda_execution_role.arn
  memory_size      = var.memory_size
  timeout          = 5
  runtime          = var.runtime
  filename         = "../../src.zip"
  handler          = "create_todos.handler"
  source_code_hash = data.archive_file.lambda_src_archive.output_base64sha256

  environment {
    variables = {
      DEPLOYMENT_NAME = var.resource_prefix
      TABLE_NAME      = var.table_name
    }
  }
}


resource "aws_iam_role" "lambda_execution_role" {
  name = "todos-lambda-execution-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "todos-lambda-dynamodb_policy"
  description = "IAM policy for accessing dynamodb table from a lambda"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Action" : [
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
      ],
      "Resource" : var.table_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}


resource "aws_cloudwatch_log_group" "get_lambda_log_group" {
  name              = "/aws/lambda/${local.get_todos_lambda_name}"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "create_lambda_log_group" {
  name              = "/aws/lambda/${local.create_todos_lambda_name}"
  retention_in_days = 1
}

resource "aws_iam_policy" "lambda_logging_policy" {
  name        = "${var.resource_prefix}-lambda-logging-policy"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents"
        ],
        "Resource" : [
          "${aws_cloudwatch_log_group.get_lambda_log_group.arn}:*",
          "${aws_cloudwatch_log_group.create_lambda_log_group.arn}:*"
        ]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
}
