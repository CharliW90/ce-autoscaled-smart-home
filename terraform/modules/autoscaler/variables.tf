variable "app_name" {
  type = string
}

variable "min" {
  type = number
}

variable "max" {
  type = number
}

variable "desired" {
  type = number
}

variable "template_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}