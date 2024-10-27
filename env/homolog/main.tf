module "homolog" {
  source     = "../../infra"
  region_aws = "us-west-2"
  nome = "var.nome-s3"

  ecr_name      = "Homologacao"
  descricao     = "Aplicacao-de-Homologacao"
  ambiente      = "Ambiente-de-Homologacao"
  maquina       = "t2.micro"
  max-aplicacao = 3

  nome-s3 = "var.nome-s3"
}
