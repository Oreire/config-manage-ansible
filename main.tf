
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

#Create AWS EC2 Instance (Web Servers)

resource "aws_instance" "web_nodes" {
  count                  = 2
  ami                    = "ami-0c76bd4bd302b30ec"
  instance_type          = "t2.micro"
  key_name               = "ANSIBLE-SSH-KEY"
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]
  tags = {
    Name         = " Web-Node-${count.index + 1} "
    Time-Created = formatdate("MM DD YYYY hh:mm ZZZ", timestamp())
    Department   = "DevOps"
  }

}
resource "null_resource" "generate_inventory" {
  depends_on = [aws_instance.web_nodes]

  provisioner "local-exec" {
    command = <<EOF
      # Retrieve instance IPs from Terraform output
      web_nodes_ips=$(terraform output -json web_nodes_ips | jq -r '.[]')

      # Create Ansible inventory file
      inventory_file="inventory.ini"
      echo "[web_nodes]" > $inventory_file

      # Append each IP address to the inventory file
      for ip in $web_nodes_ips; do
        echo $ip >> $inventory_file
      done
    EOF
  }
}

/* resource "aws_instance" "ansible_node" {
  ami           = "ami-0c76bd4bd302b30ec"
  instance_type = "t2.micro"
  key_name      = "SSH-KEY"
  tags = {
    Name = "ANSIBLE NODE"
  }
 */

