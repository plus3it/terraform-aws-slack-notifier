module "test_events" {
  source = "../../"

  hook_url = "https://hooks.slack.com/services/NOTREAL/HOOK/url"

  name = "test-events-aws-to-slack"

  event_rules = [
    {
      name    = "test-event-name"
      pattern = <<-PATTERN
        {
          "detail-type": [
            "CodeBuild Build State Change",
            "CodeCommit Pull Request State Change"
          ],
          "source": ["aws.codecommit", "aws.codebuild"]
        }
        PATTERN
    },
    {
      pattern = <<-PATTERN
        {
          "detail-type": [
            "CodeCommit Repository State Change"
          ],
          "source": ["aws.codecommit"],
          "detail": {
            "event": [
                "referenceCreated",
                "referenceUpdated"
            ],
            "referenceType": ["tag"]
          }
        }
        PATTERN
    }
  ]
}
