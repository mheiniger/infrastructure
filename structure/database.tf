variable "rancher_db_instance_name" {
  type = "string"
}

variable "rancher_db_port" {
  type = "string"
  default = "3306"
}

variable "rancher_db_name" {
  type = "string"
}

variable "rancher_db_username" {
  type = "string"
}

variable "rancher_db_password" {
  type = "string"
}

variable "rancher_db_zone" {
  type = "string"
}

variable "rancher_db_instance_class" {
  type = "string"
}

variable "rancher_db_monitoring_interval" {
  type = "string"
  default = "0"
}

resource "aws_security_group" "mysql_public" {
  name = "mysql_public"
  description = "Make mysql accessible from everywhere"

  egress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "rancher" {
  # Instance config
  identifier = "${var.rancher_db_instance_name}"
  availability_zone    = "${var.rancher_db_zone}"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.6.27"
  parameter_group_name = "default.mysql5.6"
  instance_class       = "${var.rancher_db_instance_class}"
  publicly_accessible  = true
  vpc_security_group_ids = ["${aws_security_group.mysql_public.id}"]

  # not supported for db.t1.micro instance
  monitoring_interval = "${var.rancher_db_monitoring_interval}"

  # Database config
  port                 = "${var.rancher_db_port}"
  name                 = "${var.rancher_db_name}"
  username             = "${var.rancher_db_username}"
  password             = "${var.rancher_db_password}"
}


output "database_host" {
  value = "${aws_db_instance.rancher.endpoint}"
}

output "database_name" {
  value = "${aws_db_instance.rancher.name}"
}

output "database_username" {
  value = "${aws_db_instance.rancher.username}"
}
