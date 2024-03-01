variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "private_security_groups" {
  type = list(string)
}

variable "public_security_groups" {
  type = list(string)
}

variable "key" {
  type = string
}

variable "apps" {
  type = list(object({
    app_name = string
    image = string
    public = bool
  }))
}