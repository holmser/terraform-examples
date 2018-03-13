provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "b" {
  bucket = "chlmes.terraform"
  acl    = "private"

  tags {
    Name = "Terraform State"
  }
}
