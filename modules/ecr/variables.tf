variable "name" {
  description = "Repository name, e.g. schedule-engine/se-kong"
}

variable "policy_sid" {
  description = "Read-only policy sid, e.g. se-app-read-only"
}

variable "policy_principal" {
  description = "Read-only policy principals"
}
