variable "app" {
  type = string
  description = "Name of application to deploy"
  default = "time-off"
}

variable "env" {
  type = string
  default = "prod"
  description = "Name of environment to deploy"
}


variable "account" {
  type = string
  default = "575158790750"
  description = "Account to create the resources"
}
