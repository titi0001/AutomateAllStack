module "aws-dev" {
    source = "../../infra"
    instancia = "t2.micro"
    region_aws = "us-east-2"
    key = "infra-dev"
    grup_sec = "acesso-geral-dev"
}

output "IP_public_dev" {
  value = module.aws-dev.IP_public
}