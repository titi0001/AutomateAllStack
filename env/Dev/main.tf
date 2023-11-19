module "aws-dev" {
    source = "../../infra"
    instancia = "t2.micro"
    region_aws = "us-west-2"
    key = "infra-dev"
}