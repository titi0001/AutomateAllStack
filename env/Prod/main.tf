module "aws-prod" {
    source = "../../infra"
    instancia = "t2.micro"
    region_aws = "us-east-2"
    key = "infra-prod"
    grup_sec = "producao"
    minimo = 1
    maximo = 10
    nomeGrupo = "Prod"
}

output "IP_public_prod" {
  value = module.aws-prod.IP_public
}