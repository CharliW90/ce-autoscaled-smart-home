variable "target_protocol" {
  type = string
  default = "HTTP"
}

variable "target_protocol_ver" {
  type = string
  default = "HTTP1"
}

variable "target_port" {
  type = number
  default = 3000
}

variable "vpc_id" {
  type = string
}

variable "health_check_path" {
  type = string
  default = "/health-check"
}

variable "health_check_protocol" {
  type = string
  default = "HTTP"
}

variable "security_groups" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "listen_port" {
  type = number
  default = 80
}

variable "listen_protocol" {
  type = string
  default = "HTTP"
}

variable "autoscaling_group" {
  type = string
}