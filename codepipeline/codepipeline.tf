// choose our region
provider "aws" {
  region = "us-east-1"
}

// define s3 remote state
terraform {
  backend "s3" {
    bucket = "chlmes.terraform"
    key    = "tf_state/codepipeline"
    region = "us-east-1"
  }
}

resource "aws_s3_bucket" "pipeline_bucket" {
  bucket = "chlmes.pipeline"
  acl    = "private"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "tf_CodePipelineAdmin"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "tf_CodePipelinePolicy"
  role = "${aws_iam_role.codepipeline_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning"
      ],
      "Resource": [
        "${aws_s3_bucket.pipeline_bucket.arn}",
        "${aws_s3_bucket.pipeline_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
      "Effect":"Allow",
      "Action": [
        "codecommit:GetBranch",
        "codecommit:GetCommit",
        "codecommit:UploadArchive",
        "codecommit:GetUploadArchiveStatus"
      ],
      "Resource": "arn:aws:codecommit:us-east-1:487312177614:AMIDefinitions"
    }
  ]
}
EOF
}

# data "aws_kms_alias" "s3kmskey" {
#   name = "alias/myKmsKey"
# }

resource "aws_codepipeline" "ami_builder" {
  name     = "AMIBuilder"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.pipeline_bucket.bucket}"
    type     = "S3"

    # encryption_key {
    #   id   = "${data.aws_kms_alias.s3kmskey.arn}"
    #   type = "KMS"
    # }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["MyApp"]

      configuration {
        BranchName           = "master"
        PollForSourceChanges = "false"
        RepositoryName       = "AMIDefinitions"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name     = "CodeBuild"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"

      input_artifacts = ["MyApp"]
      version         = "1"

      # output_artifacts = ["MyAppBuild"]

      configuration {
        ProjectName = "AMI_Builder"
      }
    }
  }
}

// CloudWatch Event Rules

resource "aws_cloudwatch_event_rule" "code_pipeline" {
  # id          = "CodePipeLine"
  name        = "CodePipeline"
  description = "Notify of CodePipeline events"

  event_pattern = <<PATTERN
  {
    "detail-type": [
      "CodePipeline Stage Execution State Change"],
    "source":[
    "aws.codepipeline"
    ]
  }
  PATTERN
}

//SNS notification

resource "aws_sns_topic" "code_pipeline" {
  name         = "PipelineNotificationTopic"
  display_name = "CodePipe"
}
