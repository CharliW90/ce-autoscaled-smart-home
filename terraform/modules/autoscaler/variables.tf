variable "min" {
  type = number
}

variable "max" {
  type = number
}

variable "desired" {
  type = number
}

variable "templates" {
  type = list(object({
    template_app = string
    template_id = string
    public = bool
  }))
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}