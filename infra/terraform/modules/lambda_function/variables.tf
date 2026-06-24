variable "lambda_function_name" {
  type = string
}

variable "lambda_artifact_zip_path" {
  type = string
}

variable "lambda_runtime" {
  type    = string
  default = "nodejs20.x"
}

variable "lambda_handler_entrypoint" {
  type    = string
  default = "handler.handler"
}

variable "lambda_environment_variables" {
  type    = map(string)
  default = {}
}
