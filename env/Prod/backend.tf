terraform {
  backend "s3" {
    bucket = "terraform-state-alura-thiago"
    key = "Prod/terraform.tfstate"
    region = "us-west-2"
  }
}