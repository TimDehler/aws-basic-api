resource "aws_apigatewayv2_api" "this" {
  name          = var.http_api_name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.http_api_stage_name
  auto_deploy = true

  default_route_settings {
    throttling_rate_limit  = var.http_stage_throttle_rate_limit
    throttling_burst_limit = var.http_stage_throttle_burst_limit
  }
}
