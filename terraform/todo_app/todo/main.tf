module "api" {
  source = "./modules/api"

  resource_prefix = var.resource_prefix

  get_lambda_name    = module.lambda.get_lambda_name
  get_lambda_arn     = module.lambda.get_lambda_arn
  create_lambda_name = module.lambda.create_lambda_name
  create_lambda_arn  = module.lambda.create_lambda_arn
}

module "lambda" {
  source = "./modules/lambda"

  resource_prefix = var.resource_prefix
  memory_size     = var.lambda_memory_size
  runtime         = var.lambda_runtime
  table_name      = module.db.dynamodb_table_name
  table_arn       = module.db.dynamodb_table_arn
}

module "db" {
  source = "./modules/db"

  resource_prefix = var.resource_prefix
}
