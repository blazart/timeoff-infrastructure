variable "aws_region" {
  type = string
  description = "Region to create the resources"
  default     = "us-east-1"
}

variable "zones_number" {
  type = number
  description = "How many AZ are gonna be covered"
  default     = 2
}


variable "aws_account_id" {
  type = string
  description = "Number Account to create the resources"
}

variable "app_name" {
  type = string
  description = "Name of App"
}

variable "env" {
  type = string
  description = "Environment related with the configuration"
}

locals {
  suffix_name="_${var.app_name}_${var.env}"
}

