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

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "init-machines-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  public_subnets  = ["10.0.1.0/24"]
  private_subnets = ["10.0.101.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
  
}

data "http" "my-ipv4" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "main" {
  name = "allow ssh in and http out"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ssh_in" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["${chomp(data.http.my-ipv4.response_body)}/32"]
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "outbound" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
}

resource "aws_instance" "init-machine" {
  count = length(var.app_names)
  
  subnet_id = module.vpc.public_subnets[0]
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id, aws_security_group.main.id]
  ami = "ami-0f1c8774a3b5cd465"
  associate_public_ip_address = true
  key_name = "init-machine-key"
  tags = {
    Name = var.app_names[count.index]
  }
}

output "ssh_in" {
  value = [
    for machine in aws_instance.init-machine[*] : "${machine.tags.Name}: ssh -i ./init-machine-key.pem ubuntu@${machine.public_dns}"
  ]
}

output "id" {
  value = [
    for machine in aws_instance.init-machine[*] : "${machine.tags.Name}: ${machine.id}"
  ]
}
