resource "aws_iam_role" "this" {
  name = "${var.lambda_function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "this" {
  function_name    = var.lambda_function_name
  role             = aws_iam_role.this.arn
  runtime          = var.lambda_runtime
  handler          = var.lambda_handler_entrypoint
  filename         = var.lambda_artifact_zip_path
  source_code_hash = filebase64sha256(var.lambda_artifact_zip_path)

  environment {
    variables = var.lambda_environment_variables
  }

  depends_on = [aws_iam_role_policy_attachment.basic]
}
