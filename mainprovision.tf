variable "access_key" {
  type = string
}

variable "secret_key" {
  type      = string
  sensitive = true
}
variable "region_name" {
  type    = string
  default = "ap-south-1"

  validation {
    condition     = can(regex("^(ap-south-1|us-east-1)$", var.region_name))
    error_message = "valid regions are Mumbai and N Virginia only"

  }

}

provider "aws" {
  region     = var.region_name
  access_key = var.access_key
  secret_key = var.secret_key

}

data "aws_vpc" "defaultvpc" {

default = true

}

resource "aws_security_group" "sgfromterra" {

vpc_id = data.aws_vpc.defaultvpc.id

name = "sgfromterra"

}

variable "portlist" {
type = set(string)
default = ["22","80"]


}

resource "aws_security_group_rule" "allingress" {

for_each = var.portlist
protocol = "tcp"
security_group_id = aws_security_group.sgfromterra.id
from_port = each.value
to_port = each.value
cidr_blocks = ["0.0.0.0/0"]
type = "ingress"

}

resource "aws_security_group_rule" "allegress" {

protocol = "-1"
security_group_id = aws_security_group.sgfromterra.id
from_port = "0"
to_port = "0"
cidr_blocks = ["0.0.0.0/0"]
type = "egress"

}

resource "aws_instance" "myec2" {

  ami           = "ami-0a0f1259dd1c90938"
  instance_type = "t2.micro"
  key_name = "MasterKey"
  vpc_security_group_ids = [ aws_security_group.sgfromterra.id ]
  provisioner "remote-exec" {
     inline = [
      "sudo yum update -y",
      "sudo yum install nginx -y",
      "sudo service nginx start"
    ]
  }

  connection {

    type        = "ssh"
    host        = aws_instance.myec2.public_ip
    user        = "ec2-user"
    private_key = file("${path.module}/MasterKey.pem")

  }

}
output "public_ip" {

  value = aws_instance.myec2.public_ip

}
