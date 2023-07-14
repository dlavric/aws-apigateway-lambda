data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda_dani"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_lambda_function" "runner_lambda_function" {
  count         = var.create_function ? 1 : 0
  function_name = "myDanielaFunction2"
  role          = aws_iam_role.iam_for_lambda.arn
  filename      = "function_lambda_2.zip"
  runtime       = "nodejs18.x"
  handler       = "index.handler"
  publish       = true

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }
}

resource "aws_lambda_permission" "lambda_permission" {
  #statement_id  = "AllowMyDemoAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.runner_lambda_function[0].function_name
  principal     = "apigateway.amazonaws.com"

  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
   source_arn = "${aws_api_gateway_rest_api.example.execution_arn}*"
}