
variable "subnet_1_cidr" {
  default = "10.0.1.0/24"
  description = "Your AZ"
}

variable "subnet_2_cidr" {
  default = "10.0.2.0/24"
  description = "Your AZ"
}

variable "az_1" {
  default = "eu-west-1a"
  description = "Your Az1, use AWS CLI to find your account specific"
}

variable "az_2" {
  default = "eu-west-1b"
  description = "Your Az2, use AWS CLI to find your account specific"
}

variable "vpc_id" {
  description = "Your VPC ID"
}

resource "aws_subnet" "subnet_1" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "${var.subnet_1_cidr}"
  availability_zone = "${var.az_1}"

  tags {
    Name = "main_subnet1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "${var.subnet_2_cidr}"
  availability_zone = "${var.az_2}"

  tags {
    Name = "main_subnet2"
  }
}
