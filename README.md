[![pullreminders](https://pullreminders.com/badge.svg)](https://pullreminders.com?ref=badge)

# terraform-aws-slack-notifier

Terraform module that builds and deploys a lamdbda function for the
[`aws-to-slack`][aws-to-slack] package.

[aws-to-slack]: https://github.com/arabold/aws-to-slack

## Usage

This module supports a couple use cases:

* Create the `aws-to-slack` lambda function
* Create triggers for the lambda function

### Just the aws-to-slack Lambda Function

To create just the lambda function, use only the variable `hook_url`.

```hcl
module "aws-to-slack" {
  source = "git::https://github.com/plus3it/terraform-aws-slack-notifier.git"

  hook_url = "https://hooks.slack.com/services/your/hook/id"
}
```

### Trigger Notifications from CloudWatch Event Rules

To trigger notifications from CloudWatch Event Rules, use the variable
`event_rules`. This will create the `aws-to-slack` lambda function, the
specified event rule(s), and the trigger, and it will add the necessary
permissions to the lambda function. See the section [Details for `event_rules`](#details-for-event_rules).

```hcl
module "aws-to-slack" {
  source = "git::https://github.com/plus3it/terraform-aws-slack-notifier.git"

  hook_url = "https://hooks.slack.com/services/your/hook/id"

  event_rules = [
    {
      pattern = <<-PATTERN
        {
          "detail-type": ["CodeBuild Build State Change"]
          "source": ["aws.codebuild"]
        }
        PATTERN
    }
  ]
}
```

## Variables

| Name | Description | Type | Default |
|------|-------------|:----:|:-------:|
| `hook_url` | Slack webhook URL; see <https://api.slack.com/incoming-webhooks> | string | - |
| `name` | (Optional) Name to associate with the lambda function | string | `"aws-to-slack"` |
| `event_rules` | (Optional) List of config maps of CloudWatch Event Rules that will trigger notifications | string | `[]` |
| `sns_trigger` | (Optional) Toggle to control whether to create an SNS topic and subscription for the lambda function | bool | `false` |

### Details for `event_rules`

The `event_rules` variable is a list of config maps. Each map describes an
event rule that will be created. The supported structure is depicted below.
Only the `pattern` key is required. More information on the supported JSON
for the pattern is available in the [Amazon CloudWatch Events documentation][cloudwatch-docs].

[cloudwatch-docs]: https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/CloudWatchEventsandEventPatterns.html

```hcl
  event_rules = [
    {
      name        = ""  // Optional. Name for the CloudWatch Event rule. Defaults to var.name_<index>
      description = ""  // Optional. Description for the CloudWatch Event rule. Defaults to "Managed by Terraform"
      pattern     = ""  // Required. JSON object describing events the rule will match.
    }
  ]
```

## Authors

This module is maintained by [Plus3 IT Systems](https://github.com/plus3it).

## License

Apache 2 licensed. See the [LICENSE.md](LICENSE.md) file for details.

<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hook_url"></a> [hook\_url](#input\_hook\_url) | Slack webhook URL; see <https://api.slack.com/incoming-webhooks> | `string` | n/a | yes |
| <a name="input_create_sns_topic"></a> [create\_sns\_topic](#input\_create\_sns\_topic) | (Optional) Creates an SNS topic and subscribes the lambda function; conflicts with `sns_topics` | `bool` | `false` | no |
| <a name="input_event_rules"></a> [event\_rules](#input\_event\_rules) | (Optional) List of config maps of CloudWatch Event Rules that will trigger notifications | `list(map(string))` | `[]` | no |
| <a name="input_lambda"></a> [lambda](#input\_lambda) | Object of optional attributes passed on to the lambda module | <pre>object({<br/>    artifacts_dir            = optional(string, "builds")<br/>    build_in_docker          = optional(bool, false)<br/>    create_package           = optional(bool, true)<br/>    ephemeral_storage_size   = optional(number)<br/>    ignore_source_code_hash  = optional(bool, true)<br/>    local_existing_package   = optional(string)<br/>    memory_size              = optional(number, 128)<br/>    recreate_missing_package = optional(bool, false)<br/>    runtime                  = optional(string, "nodejs14.x")<br/>    s3_bucket                = optional(string)<br/>    s3_existing_package      = optional(map(string))<br/>    s3_prefix                = optional(string)<br/>    store_on_s3              = optional(bool, false)<br/>    timeout                  = optional(number, 300)<br/>  })</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional) Name to associate with the lambda function | `string` | `"aws-to-slack"` | no |
| <a name="input_sns_topics"></a> [sns\_topics](#input\_sns\_topics) | (Optional) List of SNS ARNs the lambda function will be subscribed to; conflicts with `create_sns_topic` | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_events_rule_arns"></a> [events\_rule\_arns](#output\_events\_rule\_arns) | ARNs of the CloudWatch Event Rules |
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | The ARN of the Lambda function |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | The name of the Lambda function |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the IAM role created for the Lambda function |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | The name of the IAM role created for the Lambda function |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | ARN of the SNS Topic |
| <a name="output_sns_topic_subscription_arns"></a> [sns\_topic\_subscription\_arns](#output\_sns\_topic\_subscription\_arns) | ARN of the SNS Topic Subscription |

<!-- END TFDOCS -->
