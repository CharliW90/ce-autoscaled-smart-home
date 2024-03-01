terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.22.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_ami_from_instance" "smart-status-app-instance" {
  name = "smart-status-app"
  source_instance_id = "i-05126f7e6e53ffe65"
}

output "smart_status_ami" {
  value = aws_ami_from_instance.smart-status-app-instance.id
}

resource "aws_ami_from_instance" "smart-lighting-app-instance" {
  name = "smart-lighting-app"
  source_instance_id = "i-0ae34968abc1c0d34"
}

output "smart_lighting_ami" {
  value = aws_ami_from_instance.smart-lighting-app-instance.id
}

resource "aws_ami_from_instance" "smart-heating-app-instance" {
  name = "smart-heating-app"
  source_instance_id = "i-088a89122c9bc0c3d"
}

output "smart_heating_ami" {
  value = aws_ami_from_instance.smart-heating-app-instance.id
}

resource "aws_ami_from_instance" "smart-auth-app-instance" {
  name = "smart-auth-app"
  source_instance_id = "i-094e7e24c3b28a9d9"
}

output "smart_auth_ami" {
  value = aws_ami_from_instance.smart-auth-app-instance.id
}
