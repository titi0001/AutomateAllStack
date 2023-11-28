module "prod" {
  source = "../../infra"
  region_aws = "us-west-2"
  
  ecr_name = "producao"
  descricao = "aplicacao-de-producao"
  ambiente = "ambiante-de-producao"
  maquina = "t2.micro"
  max-aplicacao = 5
}
