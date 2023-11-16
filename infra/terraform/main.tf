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
   region = "us-east-2"
}

resource "aws_instance" "app_server" {
    ami = "ami-0e83be366243f524a"
    instance_type = "t2.micro"

    tags = {
      Name = "Ubuntu-server-instancia"
    }
}

