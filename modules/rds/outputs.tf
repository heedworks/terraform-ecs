output "id" {
  description = "The RDS instance ID."
  value       = "${aws_db_instance.main.id}"
}

output "arn" {
  description = "The ARN of the RDS instance."
  value       = "${aws_db_instance.main.arn}"
}

output "username" {
  description = "The master username for the database."
  value       = "${aws_db_instance.main.username}"
}

output "engine" {
  description = "The database engine."
  value       = "${aws_db_instance.main.engine}"
}

output "endpoint" {
  description = "The connection endpoint. e.g. se-kong-postgres.cpudfuwsfqhu.us-east-1.rds.amazonaws.com:5432"
  value       = "${aws_db_instance.main.endpoint}"
}

output "address" {
  description = "The address of the RDS instance. e.g. se-kong-postgres.cpudfuwsfqhu.us-east-1.rds.amazonaws.com"
  value       = "${aws_db_instance.main.address}"
}

output "instance_connection_string" {
  description = "e.g. postgres://se_admin:****@se-kong-postgres.cpudfuwsfqhu.us-east-1.rds.amazonaws.com:5432"
  value       = "${aws_db_instance.main.engine}://${aws_db_instance.main.username}:${aws_db_instance.main.password}@${aws_db_instance.main.endpoint}"
}

output "db_connection_string" {
  description = "e.g. postgres://se_admin:****@se-kong-postgres.cpudfuwsfqhu.us-east-1.rds.amazonaws.com:5432/se_kong"
  value       = "${aws_db_instance.main.engine}://${aws_db_instance.main.username}:${aws_db_instance.main.password}@${aws_db_instance.main.endpoint}/${aws_db_instance.main.name}"
}
