variable "rancher_os_ami" {
  type = "string"
}

variable "rancher_instance_type" {
  type = "string"
}

variable "rancher_docker_image" {
  type = "string"
}

variable "new_relic_license_key" {
  type = "string"
}

variable "rancher_public_key" {
  type = "string"
}

variable "cloudwatch_aws_region" {
  type = "string"
}

variable "cloudwatch_aws_access_key" {
  type = "string"
}

variable "cloudwatch_aws_secret_key" {
  type = "string"
}

resource "aws_key_pair" "rancher_key" {
  key_name = "rancher"
  public_key = "${var.rancher_public_key}"
}

resource "aws_instance" "rancher_master" {
  ami           = "${var.rancher_os_ami}"
  instance_type = "${var.rancher_instance_type}"
  monitoring    = true
  user_data     = "${template_file.cloud_init.rendered}"
  key_name      = "${aws_key_pair.rancher_key.key_name}"
  security_groups = ["${aws_security_group.rancher_master.name}"]
  associate_public_ip_address = true
}

resource "aws_eip" "rancher_master" {
  instance = "${aws_instance.rancher_master.id}"
  vpc      = false
}


resource "aws_security_group" "rancher_master" {
  name = "rancher_master"
  description = "Allow ports needed for rancher"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 4500
    to_port = 4500
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 500
    to_port = 500
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


variable "rancher_domain" {
  type = "string"
}

variable "letsencrypt" {
  type = "string"
  default = ""
}

# User-data template
resource "template_file" "cloud_init" {
    template = "${file("${path.module}/files/rancher.bootstrap.template")}"

    vars {
      # Setup
      rancher_docker_image = "${var.rancher_docker_image}"
      ssh_authorized_key = "${aws_key_pair.rancher_key.public_key}"

      # Database
      database_host = "${aws_db_instance.rancher.address}"
      database_port = "${var.rancher_db_port}"
      database_name = "${var.rancher_db_name}"
      database_username = "${var.rancher_db_username}"
      database_password = "${var.rancher_db_password}"

      # Monitoring
      cloudwatch_aws_region = "${var.cloudwatch_aws_region}"
      cloudwatch_aws_access_key = "${var.cloudwatch_aws_access_key}"
      cloudwatch_aws_secret_key = "${var.cloudwatch_aws_secret_key}"
      new_relic_license_key = "${var.new_relic_license_key}"

      # Frontend
      rancher_domain = "${var.rancher_domain}"
      letsencrypt = "${var.letsencrypt}"
    }
}


output "host" {
  value = "${aws_eip.rancher_master.public_ip}"
}
