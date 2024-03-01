variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "app_name" {
  type = string
}

variable "ami_to_use" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "key" {
  type = string
}

variable "public" {
  type = bool
}