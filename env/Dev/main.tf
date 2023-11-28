module "aws-dev" {
    source = "../../infra"
    instancia = "t2.micro"
    region_aws = "us-east-2"
    key = "infra-dev"
    grup_sec = "dev"
    minimo = 0
    maximo = 1
    nomeGrupo = "Dev"
    producao = false
}