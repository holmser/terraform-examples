provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "chlmes.terraform"
    key    = "tf_state/codecommit"
    region = "us-east-1"
  }
}

variable "repos" {
  default = ["terraform", "go-codecommit"]
}

resource "aws_codecommit_repository" "terraform" {
  count           = "${length(var.repos)}"
  repository_name = "${var.repos[count.index]}"
}

output "http" {
  value = "${aws_codecommit_repository.terraform.*.clone_url_http}"
}

output "ssh" {
  value = "${aws_codecommit_repository.terraform.*.clone_url_ssh}"
}
