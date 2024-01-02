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
    condition      = can(regex("^(ap-south-1|us-east-1)$", var.region_name))
    error_message = "valid regions are Mumbai and N Virginia only"

  }

}

provider "aws" {
  region     = var.region_name
  access_key = var.access_key
  secret_key = var.secret_key

}

resource "aws_instance" "myec2" {

  ami           = "ami-0a0f1259dd1c90938"
  instance_type = "t2.micro"
}
 
 output "public_ip" {

value= aws_instance.myec2.public_ip

}
