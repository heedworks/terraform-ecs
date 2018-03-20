output "arn" {
  description = "The ARN of the load balancer (matches id)."
  value       = "${aws_lb.main.arn}"
}

output "arn_suffix" {
  description = "The ARN suffix for use with CloudWatch Metrics."
  value       = "${aws_lb.main.arn}"
}

output "dns_name" {
  description = "The DNS name of the load balancer."
  value       = "${aws_lb.main.dns_name}"
}

output "zone_id" {
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
  value       = "${aws_lb.main.zone_id}"
}

output "canonical_hosted_zone_id" {
  description = "The canonical hosted zone ID of the load balancer."
  value       = "${aws_lb.main.canonical_hosted_zone_id}"
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = "${aws_security_group.main.id}"
}
