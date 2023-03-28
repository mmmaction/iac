module "locations" {
  source = "../../todo"

  # general
  resource_prefix = var.resource_prefix
  resource_env = "dev"

  # api
  stage_name = "dev"

  # lambda
  lambda_memory_size = 128
  lambda_runtime = "nodejs16.x"

  # db

}