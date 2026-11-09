variable "ecr_repository_url" {
  type = string
}

variable "private_subnet_app_ids" {
  type = map(string)
}

variable "ecs_security_group_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}