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
permissions to the lambda function. See the section [Details for `event_rules`](details-for-event_rules).

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
