terraform {
  required_version = "~> 1.1"
  required_providers {
    aws = {
      version = "~> 3.27"
    }
  }
}

provider "aws" {

  region = "ap-south-1"

}

resource "aws_instance" "myec2" {
  count = 3
  ami           = "ami-0a0f1259dd1c90938"
  instance_type = "t2.micro"
tags = {
Name = "tagwala-${count.index+1}"
}
}
