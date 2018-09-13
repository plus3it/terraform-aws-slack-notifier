output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = "${module.lambda.function_arn}"
}

output "function_name" {
  description = "The name of the Lambda function"
  value       = "${module.lambda.function_name}"
}

output "role_arn" {
  description = "The ARN of the IAM role created for the Lambda function"
  value       = "${module.lambda.role_arn}"
}

output "role_name" {
  description = "The name of the IAM role created for the Lambda function"
  value       = "${module.lambda.role_name}"
}

output "events_rule_arns" {
  description = "ARN of the CloudWatch Event Rule"
  value       = "${aws_cloudwatch_event_rule.this.*.arn}"
}
