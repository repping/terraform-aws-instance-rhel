terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}


data "aws_ami" "latest_rhel8" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-8.6.*_HVM-*-x86_64-2-Hourly2-GP2"]
  }

  owners = ["309956199498"]
}


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_subnet" "main" {
  cidr_block = "10.0.0.0/24"
  vpc_id     = aws_vpc.main.id
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}


resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
}


resource "aws_route" "egress_all" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
  route_table_id         = aws_route_table.main.id
}


resource "aws_route_table_association" "egress_all" {
  route_table_id = aws_route_table.main.id
  subnet_id      = aws_subnet.main.id
}


resource "aws_instance" "main" {
  ami                         = data.aws_ami.latest_rhel8.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.ssh_pubkey.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.main.id, ]

  tags = {
    Name = "richarde"
  }
}


resource "aws_key_pair" "ssh_pubkey" {
  key_name   = "test ssh pubkey"
  public_key = file("test-key.pub")
}

resource "aws_security_group" "main" {
  name        = "OneHitWonder"
  description = "Main SG to allow ssh in"
  vpc_id      = aws_vpc.main.id
}


resource "aws_security_group_rule" "ingress_ssh" {
  type              = "ingress"
  description       = "allow inbound ssh"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
}


resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  description       = "allow all outbound"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
}


output "zz_easy_connect" {
  value = <<-EOF

--------
How to connect:
ssh -i <your_private_key> ec2-user@${aws_instance.main.public_ip}
--------
EOF
}
