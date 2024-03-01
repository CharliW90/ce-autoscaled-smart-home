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

resource "aws_ami_from_instance" "base_machine" {
  name = "base-machine-no-app"
  source_instance_id = "i-01acec00fc5a831b2"
}

output "ami" {
  value = aws_ami_from_instance.base_machine.id
}