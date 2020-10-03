variable "env" {}
variable "public_subnets" {
  type = list(object({
    id = string
    arn = string
  }))
}
variable "private_subnets" {
  type = list(object({
    id = string
    arn = string
  }))
}
variable "vpc_id" {}

variable "app_name" {
  type = string
  description = "Name of App"
}

variable "app_cpu" {
  description = "Assigned CPU to Fargate tasks"
  default     = "256"
}

variable "app_memory" {
  description = "Assigned Memory to Fargate tasks"
  default     = "512"
}

variable "app_port" {
  description = "Port where docker expose application"
  default     = 3000
}

variable "app_count" {
  description = "Number of fargate tasks"
  default     = 2
}

variable "min_capacity" {
  description = "Min number of task running"
  default     = 1
}

variable "max_capacity" {
  description = "Max number of tasks running"
  default     = 4
}

locals {
  suffix_name="_${var.app_name}_${var.env}"

}
variable "region" {
  type = string
  description = "Region to create the resources"
  default     = "us-east-1"
}
