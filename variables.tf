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

variable "lambda" {
  description = "Object of optional attributes passed on to the lambda module"
  type = object({
    artifacts_dir            = optional(string, "builds")
    build_in_docker          = optional(bool, false)
    create_package           = optional(bool, true)
    ephemeral_storage_size   = optional(number)
    ignore_source_code_hash  = optional(bool, true)
    local_existing_package   = optional(string)
    memory_size              = optional(number, 128)
    recreate_missing_package = optional(bool, false)
    runtime                  = optional(string, "nodejs22.x")
    s3_bucket                = optional(string)
    s3_existing_package      = optional(map(string))
    s3_prefix                = optional(string)
    store_on_s3              = optional(bool, false)
    timeout                  = optional(number, 300)
  })
  nullable = false
  default  = {}
}
