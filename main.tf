data "aws_iam_policy" "cloudwatch_readonly" {
  arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

module "lambda" {
  source = "git::https://github.com/plus3it/terraform-aws-lambda.git?ref=v0.11.4"

  function_name = "${var.name}"
  description   = "Post messages from AWS to Slack"
  handler       = "aws-to-slack/src/index.handler"
  runtime       = "nodejs6.10"
  timeout       = 10

  source_path = "${path.module}/node_modules"

  attach_policy = "true"
  policy        = "${data.aws_iam_policy.cloudwatch_readonly.policy}"

  environment = {
    variables = {
      SLACK_HOOK_URL = "${var.hook_url}"
    }
  }
}

resource "aws_cloudwatch_event_rule" "this" {
  count = "${length(var.event_rules)}"

  name          = "${lookup(var.event_rules[count.index], "name", "${var.name}_${count.index}")}"
  description   = "${lookup(var.event_rules[count.index], "description", "Managed by Terraform")}"
  event_pattern = "${lookup(var.event_rules[count.index], "pattern")}"
}

resource "aws_cloudwatch_event_target" "this" {
  count = "${length(var.event_rules)}"

  rule = "${aws_cloudwatch_event_rule.this.*.name[count.index]}"
  arn  = "${module.lambda.function_arn}"
}

resource "aws_lambda_permission" "this" {
  count = "${length(var.event_rules)}"

  action        = "lambda:InvokeFunction"
  function_name = "${module.lambda.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.this.*.arn[count.index]}"
}
