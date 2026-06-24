output "http_api_id" {
  value = aws_apigatewayv2_api.this.id
}

output "http_api_execution_arn" {
  value = aws_apigatewayv2_api.this.execution_arn
}

output "http_api_invoke_url" {
  value = aws_apigatewayv2_stage.default.invoke_url
}
