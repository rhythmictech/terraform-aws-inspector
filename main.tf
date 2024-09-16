data "aws_organizations_organization" "this" {}

data "aws_caller_identity" "this" {}

resource "aws_inspector2_enabler" "this" {
  for_each = toset(var.account_ids)

  account_ids    = [each.key]
  resource_types = var.resource_types
}

resource "aws_inspector2_organization_configuration" "this" {
  count = var.is_delegated_admin ? 1 : 0

  auto_enable {
    ec2         = var.auto_enable_ec2
    ecr         = var.auto_enable_ecr
    lambda      = var.auto_enable_lambda
    lambda_code = var.auto_enable_lambda_code
  }
}

resource "aws_inspector2_delegated_admin_account" "this" {
  count      = var.delegated_admin_account_id != null ? 1 : 0
  account_id = var.delegated_admin_account_id
}

resource "aws_inspector2_member_association" "this" {
  for_each = var.auto_associate_org_members ? {
    for account in data.aws_organizations_organization.this.accounts :
    account.id => account.id
    if account.id != data.aws_organizations_organization.this.master_account_id &&
    account.id != data.aws_caller_identity.this.account_id
  } : {}

  account_id = each.value
}

resource "aws_cloudwatch_event_rule" "inspector_findings" {
  count = var.create_notification_topic ? 1 : 0

  name        = "${var.inspector_name}-capture-inspector-findings"
  description = "Capture Inspector findings"
  tags        = var.tags
  event_pattern = jsonencode({
    source      = ["aws.inspector2"]
    detail-type = ["Inspector2 Finding"]
  })
}

resource "aws_cloudwatch_event_target" "send_to_sns" {
  count = var.create_notification_topic ? 1 : 0

  arn       = aws_sns_topic.inspector_findings[0].arn
  rule      = aws_cloudwatch_event_rule.inspector_findings[0].name
  target_id = "SendToSNS"
}

#trivy:ignore:AVD-AWS-0136
resource "aws_sns_topic" "inspector_findings" {
  count = var.create_notification_topic ? 1 : 0

  name              = "${var.inspector_name}-findings-topic"
  kms_master_key_id = var.sns_kms_master_key_id
  tags              = var.tags
}
