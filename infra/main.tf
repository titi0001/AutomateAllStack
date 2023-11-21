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
}
resource "aws_key_pair" "keyssh" {
  key_name = var.key
  public_key = file("${var.key}.pub")
}

output "IP_public" {
  value = aws_instance.app_server.public_ip
}

resource "aws_autoscaling_group" "grupo" {
  name = var.nomeGrupo
  max_size = var.maximo
  min_size = var.minimo
  launch_template {
    id = aws_launch_template.app_template.id
    version = "$Latest"
  }
}
