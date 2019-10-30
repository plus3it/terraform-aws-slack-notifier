module "test_sns" {
  source = "../../"

  hook_url = "https://hooks.slack.com/services/NOTREAL/HOOK/url"

  name = "test-sns-aws-to-slack"

  create_sns_topic = true
}
