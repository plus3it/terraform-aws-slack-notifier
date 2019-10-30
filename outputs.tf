output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = module.lambda.function_arn
}

output "function_name" {
  description = "The name of the Lambda function"
  value       = module.lambda.function_name
}

output "role_arn" {
  description = "The ARN of the IAM role created for the Lambda function"
  value       = module.lambda.role_arn
}

output "role_name" {
  description = "The name of the IAM role created for the Lambda function"
  value       = module.lambda.role_name
}

output "events_rule_arns" {
  description = "ARNs of the CloudWatch Event Rules"
  value       = aws_cloudwatch_event_rule.this[*].arn
}

output "sns_topic_arn" {
  description = "ARN of the SNS Topic"
  value       = length(aws_sns_topic.this) > 0 ? aws_sns_topic.this[0].arn : null
}

output "sns_topic_subscription_arns" {
  description = "ARN of the SNS Topic Subscription"
  value       = [for topic in aws_sns_topic_subscription.this : topic.arn]
}
