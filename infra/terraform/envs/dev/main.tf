terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_deployment_region
}

module "api" {
  source = "../../modules/api_http"
  http_api_name                        = "basic-api-dev"
  http_api_stage_name                  = "prod"
  http_stage_throttle_rate_limit       = 0.00003
  http_stage_throttle_burst_limit      = 1
}

module "hello_lambda" {
  source        = "../../modules/lambda_function"
  lambda_function_name      = "basic-api-hello-dev"
  lambda_artifact_zip_path  = "../../../../apps/hello/dist/function.zip"
  lambda_runtime            = "nodejs20.x"
  lambda_handler_entrypoint = "handler.handler"
  lambda_reserved_concurrent_executions = -1

  lambda_environment_variables = {
    STAGE = "dev"
  }
}

module "hello_route" {
  source               = "../../modules/api_route_lambda"
  http_api_id               = module.api.http_api_id
  http_api_execution_arn    = module.api.http_api_execution_arn
  api_route_key             = "GET /hello"
  target_lambda_invoke_arn  = module.hello_lambda.lambda_invoke_arn
  target_lambda_function_name = module.hello_lambda.lambda_function_name
}

output "api_invoke_url" {
  value = module.api.http_api_invoke_url
}

output "hello_url" {
  value = "${trimsuffix(module.api.http_api_invoke_url, "/")}/hello"
}
