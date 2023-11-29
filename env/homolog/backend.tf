terraform {
  backend "s3" {
    bucket = "terraform-state-alura-thiago"
    key = "homolog/terraform.tfstate"
    region = "us-west-2"
  }
}