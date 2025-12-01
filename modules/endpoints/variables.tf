variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = set(string)
}

variable "name" {
  type = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type = map(string)
}
