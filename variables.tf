variable "name" {
  default     = "Inspector"
  description = "Name of the assessment template/targets"
  type        = string
}

variable "match_tags" {
  description = "Map of tags and corresponding values to match against for AWS Inspector"
  type        = map(string)
}

variable "schedule_inspector" {
  default     = true
  description = "Indicate whether a cloudwatch rule should be created to trigger inspector automatically"
  type        = bool
}

variable "inspector_cron_schedule" {
  default     = "cron(0 20 23 * ? *)"
  description = "Cron schedule to use (see https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html for formatting)"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags to apply to resources that support tagging"
  type        = map(string)
}
