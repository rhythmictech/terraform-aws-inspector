variable "account_ids" {
  default     = []
  description = "List of AWS account IDs to enable Inspector for (the current account is used if not specified)"
  type        = list(string)
}

variable "auto_enable_ec2" {
  default     = false
  description = "Auto-enable EC2 scanning"
  type        = bool
}

variable "auto_enable_ecr" {
  default     = false
  description = "Auto-enable ECR scanning"
  type        = bool
}

variable "auto_enable_lambda" {
  default     = false
  description = "Auto-enable Lambda function scanning"
  type        = bool
}

variable "auto_enable_lambda_code" {
  default     = false
  description = "Auto-enable Lambda function code scanning (only if auto_enable_lambda is true)"
  type        = bool
}

variable "create_notification_topic" {
  default     = true
  description = "Whether to create SNS topic for Inspector findings notifications"
  type        = bool
}

variable "inspector_name" {
  default     = "inspector"
  description = "Name prefix for Inspector-related resources"
  type        = string
}

variable "is_delegated_admin" {
  default     = false
  description = "Whether this account is a delegated administrator"
  type        = bool
}

variable "resource_types" {
  default     = ["EC2", "ECR", "LAMBDA"]
  description = "List of resource types to be scanned"
  type        = list(string)
}

variable "sns_kms_master_key_id" {
  default     = "alias/aws/sns"
  description = "The ID of the AWS KMS key to use for SNS topic encryption"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags to apply to resources that support tagging"
  type        = map(string)
}

variable "delegated_admin_account_id" {
  default     = null
  description = "The AWS account ID to be set as a delegated administrator for Inspector"
  type        = string
}

variable "auto_associate_org_members" {
  default     = false
  description = "Automatically associate all member accounts in the organization with Inspector"
  type        = bool
}
