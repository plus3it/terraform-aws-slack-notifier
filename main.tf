terraform {
  required_version = ">= 0.12"
}

data "aws_iam_policy" "cloudwatch_readonly" {
  arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

module "lambda" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-lambda?ref=v7.2.6"

  function_name            = var.name
  description              = "Post messages from AWS to Slack"
  handler                  = "aws-to-slack/src/index.handler"
  artifacts_dir            = var.lambda.artifacts_dir
  build_in_docker          = var.lambda.build_in_docker
  create_package           = var.lambda.create_package
  ephemeral_storage_size   = var.lambda.ephemeral_storage_size
  ignore_source_code_hash  = var.lambda.ignore_source_code_hash
  local_existing_package   = var.lambda.local_existing_package
  memory_size              = var.lambda.memory_size
  recreate_missing_package = var.lambda.recreate_missing_package
  runtime                  = var.lambda.runtime
  s3_bucket                = var.lambda.s3_bucket
  s3_existing_package      = var.lambda.s3_existing_package
  s3_prefix                = var.lambda.s3_prefix
  store_on_s3              = var.lambda.store_on_s3
  timeout                  = var.lambda.timeout

  source_path = [
    {
      path             = "${path.module}/vendor"
      pip_requirements = true
      patterns         = ["!\\.terragrunt-source-manifest"]
    }
  ]

  policy = data.aws_iam_policy.cloudwatch_readonly.policy

  environment_variables = {
    SLACK_HOOK_URL = var.hook_url
  }
}

resource "aws_cloudwatch_event_rule" "this" {
  count = length(var.event_rules)

  name = lookup(
    var.event_rules[count.index],
    "name",
    "${var.name}_${count.index}",
  )
  description = lookup(
    var.event_rules[count.index],
    "description",
    "Managed by Terraform",
  )
  event_pattern = var.event_rules[count.index]["pattern"]
}

resource "aws_cloudwatch_event_target" "this" {
  count = length(var.event_rules)

  rule = aws_cloudwatch_event_rule.this[count.index].name
  arn  = module.lambda.lambda_function_arn
}

resource "aws_lambda_permission" "lambda" {
  count = length(var.event_rules)

  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this[count.index].arn
}

resource "aws_sns_topic" "this" {
  count = var.create_sns_topic ? 1 : 0

  name = var.name
}

resource "aws_sns_topic_subscription" "this" {
  for_each = var.create_sns_topic ? { "arn" : aws_sns_topic.this[0].arn } : { for arn in var.sns_topics : arn => arn }

  topic_arn = each.value
  protocol  = "lambda"
  endpoint  = module.lambda.lambda_function_arn
}

resource "aws_lambda_permission" "sns" {
  for_each = var.create_sns_topic ? { "arn" : aws_sns_topic.this[0].arn } : { for arn in var.sns_topics : arn => arn }

  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_function_name
  principal     = "sns.amazonaws.com"
  source_arn    = each.value
}
