module "homolog" {
  source = "../../infra"
  region_aws = "us-west-2"
  
  ecr_name = "Homologacao"
  descricao = "Aplicacao-de-Homologacao"
  ambiente = "Ambiante-de-Homologacao"
  maquina = "t2.micro"
  max-aplicacao = 3
}
