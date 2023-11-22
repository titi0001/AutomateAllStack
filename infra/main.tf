terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}
provider "aws" {
   profile = "default"
   region = var.region_aws
}

resource "aws_launch_template" "app_template" {
    image_id = "ami-0e83be366243f524a"
    instance_type = var.instancia
    key_name = var.key
    tags = {
      Name = "Terraform Ansible Python"
    }
    security_group_names = [ var.grup_sec ]
    user_data = filebase64("ansible.sh")
}
resource "aws_key_pair" "keyssh" {
  key_name = var.key
  public_key = file("${var.key}.pub")
}

resource "aws_autoscaling_group" "grupo" {
  availability_zones = [ "${var.region_aws}a", "${var.region_aws}b" ]
  name = var.nomeGrupo
  max_size = var.maximo
  min_size = var.minimo
  launch_template {
    id = aws_launch_template.app_template.id
    version = "$Latest"
  }
}

resource "aws_default_subnet" "subnet_1" {
  availability_zone = "${var.region_aws}a"

  
}

resource "aws_default_subnet" "subnet_2" {
  availability_zone = "${var.region_aws}b"
  
  
}

