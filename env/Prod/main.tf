module "prod" {
  source = "../../infra"
  region_aws = "us-west-2"
  
  ecr_name = "Producao"
  descricao = "Aplicacao-de-producao"
  ambiente = "Ambiante-de-producao"
  maquina = "t2.micro"
  max-aplicacao = 5
}
