output "db_name" {
  description = "The database name."
  value       = "${module.db.name}"
}

output "db_arn" {
  description = "The ARN of the RDS instance."
  value       = "${module.db.arn}"
}

output "db_instance_connection_string" {
  description = "e.g. postgres://se_admin:****@se-kong-postgres.cpudfuwsfqhu.us-east-1.rds.amazonaws.com:5432"
  value       = "${module.db.instance_connection_string}"
}

output "db_connection_string" {
  description = "e.g. postgres://se_admin:****@se-kong-postgres.cpudfuwsfqhu.us-east-1.rds.amazonaws.com:5432/se_kong"
  value       = "${module.db.db_connection_string}"
}
