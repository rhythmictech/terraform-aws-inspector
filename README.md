# terraform-aws-inspector


[![](https://github.com/rhythmictech/terraform-aws-inspector/workflows/check/badge.svg)](https://github.com/rhythmictech/terraform-aws-inspector/actions)

Configures AWS Inspector. Optionally configures a CloudWatch scheduled event to trigger assessments based on a specified schedule.

```
module "inspector" {
  source = "git::ssh://git@github.com/rhythmictech/terraform-aws-inspector"
  match_tags = {
    "AWSInspector": "enabled"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| inspector\_cron\_schedule | Cron schedule to use \(see https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html for formatting\) | string | `"cron(0 20 23 * ? *)"` | no |
| match\_tags | Map of tags and corresponding values to match against for AWS Inspector | map(string) | n/a | yes |
| name | Name of the assessment template/targets | string | `"Inspector"` | no |
| schedule\_inspector | Indicate whether a cloudwatch rule should be created to trigger inspector automatically | bool | `"true"` | no |
| tags | Tags to apply to resources that support tagging | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| inspector\_assessment\_target\_arn |  |
| inspector\_assessment\_template\_arn |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
