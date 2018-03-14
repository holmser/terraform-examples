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

    # environment_variable {
    #   "name"  = "SOME_KEY1"
    #   "value" = "SOME_VALUE1"
    # }

    # environment_variable {
    #   "name"  = "SOME_KEY2"
    #   "value" = "SOME_VALUE2"
    # }
  }

  source {
    type     = "CODECOMMIT"
    location = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/AMIDefinitions"
  }

  #   vpc_config {
  #     vpc_id = "vpc-725fca"

  #     subnets = [
  #       "subnet-ba35d2e0",
  #       "subnet-ab129af1",
  #     ]

  #     security_group_ids = [
  #       "sg-f9f27d91",
  #       "sg-e4f48g23",
  #     ]
  #   }

  #   tags {
  #     "Environment" = "Test"
  #   }
}
