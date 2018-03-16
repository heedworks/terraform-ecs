// External SSH allows ssh connections on port 22 from the world.
output "external_ssh" {
  value = "${aws_security_group.external_ssh.id}"
}

// Internal SSH allows ssh connections from the external ssh security group.
output "internal_ssh" {
  value = "${aws_security_group.internal_ssh.id}"
}

// Internal ELB allows internal traffic.
output "internal_alb" {
  value = "${aws_security_group.internal_alb.id}"
}

// External ELB allows traffic from the world.
output "external_alb" {
  value = "${aws_security_group.external_alb.id}"
}
