// The ECR name.
output "ecr_name" {
  value = "${aws_ecr_repository.main.name}"
}

output "ecr_arn" {
  value = "${aws_ecr_repository.main.arn}"
}

output "ecr_registry_id" {
  value = "${aws_ecr_repository.main.registry_id}"
}

output "ecr_repository_url" {
  value = "${aws_ecr_repository.main.repository_url}"
}
