provider "aws" {
  region = "us-east-1"
}

resource "aws_codecommit_repository" "terraform" {
  repository_name = "terraform"
  description     = "TF monorepo"
}

terraform {
  backend "s3" {
    bucket = "chlmes.terraform"
    key    = "tf_state/codecommit"
    region = "us-east-1"
  }
}

output "address" {
  value = "${aws_codecommit_repository.terraform.clone_url_http}"
}
