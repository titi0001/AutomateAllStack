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
resource "aws_instance" "app_server" {
    ami = "ami-0e83be366243f524a"
    instance_type = var.instancia
    key_name = var.key
    tags = {
      Name = "Terraform Ansible Python"
    }
}
resource "aws_key_pair" "keyssh" {
  key_name = var.key
  public_key = file("${var.key}.pub")
}
