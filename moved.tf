moved {
  from = module.lambda.aws_lambda_function.lambda
  to   = module.lambda.aws_lambda_function.this[0]
}