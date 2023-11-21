module "aws-prod" {
    source = "../../infra"
    instancia = "t2.micro"
    region_aws = "us-eastb;-2"
    key = "infra-prod"
}