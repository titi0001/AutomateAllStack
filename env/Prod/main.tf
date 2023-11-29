module "prod" {
  source = "../../infra"
  region_aws = "us-west-2"
  nome = "producao"
  nome-s3 = "producao"
  ecr_name = "producao"
  descricao = "aplicacao-de-producao"
  ambiente = "ambiente-de-producao"
  maquina = "t2.micro"
  max-aplicacao = 5

}
