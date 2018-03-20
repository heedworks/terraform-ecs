output "arn" {
  description = "The ARN of the Target Group (matches id)"
  value       = "${aws_lb_target_group.main.arn}"
}
