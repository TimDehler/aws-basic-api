resource "aws_apigatewayv2_integration" "this" {
  api_id                 = var.http_api_id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.target_lambda_invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "this" {
  api_id    = var.http_api_id
  route_key = var.api_route_key
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}

resource "aws_lambda_permission" "allow_apigw" {
  statement_id  = "AllowExecutionFromApiGateway-${replace(var.api_route_key, "/[^0-9A-Za-z_-]/", "-")}"
  action        = "lambda:InvokeFunction"
  function_name = var.target_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.http_api_execution_arn}/*/*"
}
