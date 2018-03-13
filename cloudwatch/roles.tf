# We need to define which region to create the roles
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_instance_profile" "cloudwatch_agent_server_profile" {
  name = "tf_CloudWatchAgentServerProfile"
  role = "${aws_iam_role.cloudwatch_agent_server_role.name}"
}

resource "aws_iam_instance_profile" "cloudwatch_agent_admin_profile" {
  name = "tf_CloudWatchAgentAdminProfile"
  role = "${aws_iam_role.cloudwatch_agent_admin_role.name}"
}

resource "aws_iam_role" "cloudwatch_agent_server_role" {
  name = "tf_CloudWatchAgentServerRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch_agent_server_policy" {
  name = "tf_CloudWatchAgentServerPolicy"
  role = "${aws_iam_role.cloudwatch_agent_server_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CloudWatchAgentServerPolicy",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "cloudwatch:PutMetricData",
                "ec2:DescribeTags",
                "logs:DescribeLogStreams",
                "logs:CreateLogGroup",
                "logs:PutLogEvents",
                "ssm:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "ssm_agent_policy" {
  name = "tf_SSMAgentPolicy"
  role = "${aws_iam_role.cloudwatch_agent_server_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SSMAgentPolicy",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "cloudwatch:PutMetricData",
                "ec2:DescribeTags",
                "logs:DescribeLogStreams",
                "logs:CreateLogGroup",
                "logs:PutLogEvents"

            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch_agent_admin_policy" {
  name = "tf_CloudWatchAgentServerPolicy"
  role = "${aws_iam_role.cloudwatch_agent_admin_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CloudWatchAgentAdminPolicy",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "cloudwatch:PutMetricData",
                "ec2:DescribeTags",
                "ec2messages:*",
                "ssm:UpdateInstanceInformation",
                "ssm:ListAssociations",
                "logs:DescribeLogStreams",
                "logs:CreateLogGroup",
                "logs:PutLogEvents",
                "ssm:*",
                "ssm:PutParameter"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "cloudwatch_agent_admin_role" {
  name = "tf_CloudWatchAgentAdminRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
