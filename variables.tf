variable "access_key" {
}
variable "secret_key" {
}

variable "vpc_cidr" {

  default = "10.0.0.0/16"
}

variable "pubsub_cidr" {
  type    = list(string)
  default = ["10.0.0.0/20", "10.0.16.0/20"]
}

variable "pvtsub_cidr" {
  type    = list(string)
  default = ["10.0.32.0/20", "10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
}

variable "public_cidr" {
  default = "0.0.0.0/0"
}

data "aws_availability_zones" "azs" {}
