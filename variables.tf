variable "hook_url" {
  description = "Slack webhook URL; see <https://api.slack.com/incoming-webhooks>"
  type        = string
}

variable "name" {
  default     = "aws-to-slack"
  description = "(Optional) Name to associate with the lambda function"
  type        = string
}

variable "event_rules" {
  description = "(Optional) List of config maps of CloudWatch Event Rules that will trigger notifications"
  type        = list(map(string))
  default     = []
}

variable "create_sns_topic" {
  description = "(Optional) Creates an SNS topic and subscribes the lambda function; conflicts with `sns_topics`"
  type        = bool
  default     = false
}

variable "sns_topics" {
  description = "(Optional) List of SNS ARNs the lambda function will be subscribed to; conflicts with `create_sns_topic`"
  type        = list(string)
  default     = []
}
