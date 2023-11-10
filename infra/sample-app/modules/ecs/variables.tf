variable "redis_url" {
  description = "Redis URL that will be used by the sample app task definition!"
  type        = string
}

variable "target_group_arn" {
  description = "Target group that will be attached to the ecs service that will be created!"
  type        = string
}
