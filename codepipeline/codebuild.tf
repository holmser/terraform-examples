terraform {
  required_version = ">= 0.10.0, <0.12.3"
}

resource "aws_codebuild_project" "ami_builder" {
  name          = "tf_AMIBuilder"
  description   = "Terraformed AMI Builder"
  build_timeout = "5"
  service_role  = "${aws_iam_role.codebuild_role.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/ubuntu-base:14.04"
    type         = "LINUX_CONTAINER"
  }

  source {
    type     = "CODECOMMIT"
    location = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/AMIDefinitions"
  }
}
