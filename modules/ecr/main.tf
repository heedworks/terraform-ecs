resource "aws_ecr_repository" "main" {
  name = "${var.name}"
}

resource "aws_ecr_repository_policy" "read_only_policy" {
  repository = "${aws_ecr_repository.main.name}"

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "${var.policy_sid}",
            "Effect": "Allow",
            "Principal": ${var.policy_principal},
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability"
            ]
        }
    ]
}
EOF
}
