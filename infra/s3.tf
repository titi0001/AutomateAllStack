resource "aws_s3_bucket" "beanstalk_deploys" {
  bucket = "${var.nome-s3}-deploys"
}

resource "aws_s3_bucket_object" "docker" {
  depends_on = [
    aws_s3_bucket.aws_s3_bucket.beanstalk_deploys
  ]
  bucket = "${var.nome-s3}-deploys"
  key    = "${var.nome-s3}.zip"
  source = "${var.nome-s3}.zip"

  etag = filemd5("${var.nome-s3}.zip")
}