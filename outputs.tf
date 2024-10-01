output "sns_topic_arn" {
  value       = try(aws_sns_topic.inspector_findings[0].arn, null)
  description = "ARN of the SNS topic for Inspector findings"
}
