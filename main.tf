
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.69.0"
    }
  }
  required_version = ">= 1.9.5"
}

provider "aws" {
  region = "eu-west-2"
}

#Create Security Group for web servers  
resource "aws_security_group" "ansible_sg" {
  name        = "ANSIBLE-SG"
  description = "Security Group for web server 1"
  # ... other configuration ...
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#ami-05c172c7f0d3aed00

#Create AWS EC2 Instance (Web Servers)

resource "aws_instance" "node1" {
  ami                    = "ami-0c76bd4bd302b30ec" 
  instance_type          = "t2.micro"              
  key_name               = "ANSIBLE-SSH-KEY"          
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]
  tags = {
    Name = var.node1
  }
}

#Create AWS EC2 Instance (Backend Node)

resource "aws_instance" "node2" {
  ami                    = "ami-0c76bd4bd302b30ec" 
  instance_type          = "t2.micro"              
  key_name               = "ANSIBLE-SSH-KEY"         
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]
  tags = {
    Name = var.node2
  }
}

resource "aws_instance" "ansible_node" {
  ami           = "ami-0c76bd4bd302b30ec"
  instance_type = "t2.micro"
  key_name      = "SSH-KEY"
  tags = {
    Name = "ANSIBLE NODE"
  }

  provisioner "remote-exec" {
    inline = [
      "ssh -i SSH-KEY.pem ec2-user@ec2-13-43-137-91.eu-west-2.compute.amazonaws.com 'ansible-playbook -i inventory.ini playbook.yml'"
    ]
  }
}


variable "node1" {}
variable "node2" {}