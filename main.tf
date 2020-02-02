resource "aws_inspector_resource_group" "resource_group" {
  tags = var.match_tags
}

resource "aws_inspector_assessment_target" "target" {
  name               = var.name
  resource_group_arn = aws_inspector_resource_group.resource_group.arn
}

resource "aws_inspector_assessment_template" "template" {
  name       = var.name
  target_arn = aws_inspector_assessment_target.target.arn
  duration   = 3600

  # TODO don't hardcode this
  rules_package_arns = [
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gEjTy7T7",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-rExsr2X8",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-R01qwB5Q",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gBONHN9h",
  ]
}

resource "aws_cloudwatch_event_rule" "inspector_trigger" {
  count               = var.schedule_inspector ? 1 : 0
  name                = "${var.name}-Scheduler"
  description         = "Schedules AWS Inspector runs"
  schedule_expression = var.inspector_cron_schedule
  tags                = var.tags
}

data "aws_iam_policy_document" "cw_inspector_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cw_inspector_iam_role" {
  count              = var.schedule_inspector ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.cw_inspector_assume_role.json
  name_prefix        = "${var.name}-cw-role-"
  tags               = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "cw_inspector_policy_doc" {
  statement {
    actions   = ["inspector:StartAssessmentRun"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "cw_inspector_policy" {
  count       = var.schedule_inspector ? 1 : 0
  name_prefix = "${var.name}-cwinspector-"
  role        = aws_iam_role.cw_inspector_iam_role[0].id
  policy      = data.aws_iam_policy_document.cw_inspector_policy_doc.json
}

resource "aws_cloudwatch_event_target" "inspector_target" {
  count     = var.schedule_inspector ? 1 : 0
  arn       = aws_inspector_assessment_template.template.arn
  role_arn  = aws_iam_role.cw_inspector_iam_role[0].arn
  rule      = aws_cloudwatch_event_rule.inspector_trigger[0].name
  target_id = "${var.name}-Scheduler"
}
