# Why we need ECS instance policies http://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html
# ECS roles explained here http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_managed_policies.html
# Some other ECS policy examples http://docs.aws.amazon.com/AmazonECS/latest/developerguide/IAMPolicyExamples.html 

resource "aws_iam_role" "ecs_instance_role" {
  name        = "ecs-role-${var.name}-${var.environment}"
  description = "Managed by Terraform"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ecs_ec2_custom_policy" {
  name        = "ecs-role-${var.name}-${var.environment}"
  description = "Managed by Terraform"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": "ec2:DescribeVolumes",
        "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_attach_custom_policy" {
  role       = "${aws_iam_role.ecs_instance_role.id}"
  policy_arn = "${aws_iam_policy.ecs_ec2_custom_policy.arn}"
}

resource "aws_iam_instance_profile" "ecs" {
  name = "ecs-instance-profile-${var.name}-${var.environment}"
  path = "/"
  role = "${aws_iam_role.ecs_instance_role.name}"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  role       = "${aws_iam_role.ecs_instance_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
  role       = "${aws_iam_role.ecs_instance_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
