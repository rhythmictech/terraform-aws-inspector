# terraform-aws-inspector
Configures AWS Inspector. Optionally creates an SNS topic for Inspector findings notifications.

[![tflint](https://github.com/rhythmictech/terraform-aws-inspector/workflows/tflint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-inspector/actions?query=workflow%3Atflint+event%3Apush+branch%3Amaster)
[![trivy](https://github.com/rhythmictech/terraform-aws-inspector/workflows/trivy/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-inspector/actions?query=workflow%3Atrivy+event%3Apush+branch%3Amaster)
[![yamllint](https://github.com/rhythmictech/terraform-aws-inspector/workflows/yamllint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-inspector/actions?query=workflow%3Ayamllint+event%3Apush+branch%3Amaster)
[![misspell](https://github.com/rhythmictech/terraform-aws-inspector/workflows/misspell/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-inspector/actions?query=workflow%3Amisspell+event%3Apush+branch%3Amaster)
[![pre-commit-check](https://github.com/rhythmictech/terraform-aws-inspector/workflows/pre-commit-check/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-inspector/actions?query=workflow%3Apre-commit-check+event%3Apush+branch%3Amaster)
<a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=twitter" alt="follow on Twitter"></a>


## Overview

This module provides flexible configuration options for AWS Inspector, catering to different account types and organizational structures. It can be used in various scenarios, from simple single-account setups to complex multi-account organizations.

## Usage Scenarios

### 1. Single Account (Ad Hoc) Setup

For a simple setup in a single AWS account:

```hcl
module "inspector" {
  source = "rhythmictech/inspector/aws"
  create_notification_topic = true
  auto_enable_ec2 = true
  auto_enable_ecr = true
  auto_enable_lambda = true
}
```

This configuration enables Inspector for the current account, sets up automatic scanning for EC2, ECR, and Lambda resources, and creates an SNS topic for notifications.

### 2. Management Account in an AWS Organization

When deploying from the management account of an AWS Organization:

```hcl
module "inspector" {
  source                     = "rhythmictech/inspector/aws"
  
  delegated_admin_account_id = "123456789012"
  enable_inspector           = false
}
```

This setup designates a delegated administrator account, allowing the delegated admin account to manage Inspector settings for the organization.

### 3. Delegated Administrator Account

For deployment in a delegated administrator account:

```hcl
module "inspector" {
  source                             = "rhythmictech/inspector/aws"
  is_delegated_admin                 = true
  auto_enable_ec2                    = true
  auto_enable_ecr                    = true
  auto_enable_lambda                 = true
  enable_inspector_for_all_accounts  = true
  create_notification_topic          = true
}
```

This configuration sets up the account as the delegated administrator, enables automatic scanning for all supported resource types, associates all member accounts, and creates a notification topic.

### 4. Member Account

For individual member accounts (if needed):

```hcl
module "inspector" {
  source = "rhythmictech/inspector/aws"
  create_notification_topic = true
}
```

This minimal setup enables Inspector for the member account and creates a local notification topic. Note that in most cases, member accounts are managed through the delegated administrator account.

## Features

- Enables AWS Inspector for specified accounts
- Configures organization-wide settings if the account is a delegated administrator
- Optionally sets up a delegated administrator account
- Can automatically associate all member accounts in the organization with Inspector
- Creates an SNS topic for Inspector findings notifications (optional)
- Supports various resource types for scanning (EC2, ECR, Lambda)

## Example

```hcl
module "inspector" {
  source                            = "rhythmictech/inspector/aws"
  is_delegated_admin                = true
  auto_enable_ec2                   = true
  auto_enable_ecr                   = true
  auto_enable_lambda                = true
  create_notification_topic         = true
  enable_inspector_for_all_accounts = true
  exclude_account_ids               = ["123456789012", "210987654321"]
}
```

This example sets up a comprehensive Inspector configuration for an AWS Organization, including delegated administration, automatic scanning for multiple resource types, and member account association.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.66.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.inspector_findings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.send_to_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_inspector2_delegated_admin_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector2_delegated_admin_account) | resource |
| [aws_inspector2_enabler.enable_for_all_accounts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector2_enabler) | resource |
| [aws_inspector2_enabler.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector2_enabler) | resource |
| [aws_inspector2_member_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector2_member_association) | resource |
| [aws_inspector2_organization_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector2_organization_configuration) | resource |
| [aws_sns_topic.inspector_findings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_organizations_organization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accounts_to_associate_with_inspector"></a> [accounts\_to\_associate\_with\_inspector](#input\_accounts\_to\_associate\_with\_inspector) | List of AWS account IDs to associate with Inspector (used for more granular control over which accounts are associated with Inspector; see README for more details) | `list(string)` | `[]` | no |
| <a name="input_auto_enable_ec2"></a> [auto\_enable\_ec2](#input\_auto\_enable\_ec2) | Auto-enable EC2 scanning | `bool` | `false` | no |
| <a name="input_auto_enable_ecr"></a> [auto\_enable\_ecr](#input\_auto\_enable\_ecr) | Auto-enable ECR scanning | `bool` | `false` | no |
| <a name="input_auto_enable_lambda"></a> [auto\_enable\_lambda](#input\_auto\_enable\_lambda) | Auto-enable Lambda function scanning | `bool` | `false` | no |
| <a name="input_auto_enable_lambda_code"></a> [auto\_enable\_lambda\_code](#input\_auto\_enable\_lambda\_code) | Auto-enable Lambda function code scanning (only if auto\_enable\_lambda is true) | `bool` | `false` | no |
| <a name="input_create_notification_topic"></a> [create\_notification\_topic](#input\_create\_notification\_topic) | Whether to create SNS topic for Inspector findings notifications | `bool` | `true` | no |
| <a name="input_delegated_admin_account_id"></a> [delegated\_admin\_account\_id](#input\_delegated\_admin\_account\_id) | The AWS account ID to be set as a delegated administrator for Inspector | `string` | `null` | no |
| <a name="input_enable_inspector"></a> [enable\_inspector](#input\_enable\_inspector) | Whether to enable Inspector for the current account | `bool` | `true` | no |
| <a name="input_enable_inspector_for_all_accounts"></a> [enable\_inspector\_for\_all\_accounts](#input\_enable\_inspector\_for\_all\_accounts) | Whether to enable Inspector for all accounts in the organization (see README for more details) | `bool` | `false` | no |
| <a name="input_excluded_account_ids"></a> [excluded\_account\_ids](#input\_excluded\_account\_ids) | List of account IDs to exclude from Inspector enablement when enable\_inspector\_for\_all\_accounts is true | `list(string)` | `[]` | no |
| <a name="input_inspector_name"></a> [inspector\_name](#input\_inspector\_name) | Name prefix for Inspector-related resources | `string` | `"inspector"` | no |
| <a name="input_is_delegated_admin"></a> [is\_delegated\_admin](#input\_is\_delegated\_admin) | Whether this account is a delegated administrator | `bool` | `false` | no |
| <a name="input_resource_types"></a> [resource\_types](#input\_resource\_types) | List of resource types to be scanned | `list(string)` | <pre>[<br>  "EC2",<br>  "ECR",<br>  "LAMBDA"<br>]</pre> | no |
| <a name="input_sns_kms_master_key_id"></a> [sns\_kms\_master\_key\_id](#input\_sns\_kms\_master\_key\_id) | The ID of the AWS KMS key to use for SNS topic encryption | `string` | `"alias/aws/sns"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources that support tagging | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | ARN of the SNS topic for Inspector findings |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
