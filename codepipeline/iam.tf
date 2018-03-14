resource "aws_iam_role" "codebuild_role" {
  name = "tf_CodeBuildRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "tf_CodeBuildPolicy"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect":"Allow",
      "Action": [
        "codecommit:GitPull"
      ],
      "Resource": "arn:aws:codecommit:us-east-1:487312177614:*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "packer_policy" {
  name        = "tf_PackerBuilder"
  description = "Minimal Packer policy for building AMIs"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CopyImage",
                "ec2:CreateImage",
                "ec2:CreateKeypair",
                "ec2:CreateSecurityGroup",
                "ec2:CreateSnapshot",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:DeleteKeypair",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteSnapshot",
                "ec2:DeleteVolume",
                "ec2:DeregisterImage",
                "ec2:DescribeImageAttribute",
                "ec2:DescribeImages",
                "ec2:DescribeInstances",
                "ec2:DescribeRegions",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSnapshots",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVolumes",
                "ec2:DetachVolume",
                "ec2:GetPasswordData",
                "ec2:ModifyImageAttribute",
                "ec2:ModifyInstanceAttribute",
                "ec2:ModifySnapshotAttribute",
                "ec2:RegisterImage",
                "ec2:RunInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  #   name       = "tf_codebuild-policy-attachment"
  policy_arn = "${aws_iam_policy.codebuild_policy.arn}"
  role       = "${aws_iam_role.codebuild_role.id}"
}

resource "aws_iam_role_policy_attachment" "packer_policy_attachment" {
  #   name       = "tf_packer-policy-attachment"
  policy_arn = "${aws_iam_policy.packer_policy.arn}"
  role       = "${aws_iam_role.codebuild_role.id}"
}
