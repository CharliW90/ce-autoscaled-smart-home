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

  name = "init-vpc"
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

data "aws_ami" "ubuntu" {
  // Gets the latest ubuntu AMI ID
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's ID - creators of the Ubuntu AMI
}

resource "aws_instance" "init-machine" {
  subnet_id = module.vpc.public_subnets[0]
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id, aws_security_group.main.id]
  ami = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  key_name = "init-machine-key"
  tags = {
    Name = "init"
  }
}

output "ssh_in" {
  value = "ssh -i ./init-machine-key.pem ubuntu@${aws_instance.init-machine.public_dns}"
}

output "id" {
  value = aws_instance.init-machine.id
}