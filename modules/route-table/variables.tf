variable "name" {
  type = string
}

variable "vpc_id" {
  description = ""
  type        = string
}

variable "subnet_ids" {
  description = ""
  type        = list(string)
}

variable "route_table_type" {
  description = ""
  type        = string
  validation {
    condition     = contains(["public", "private"], var.route_table_type)
    error_message = "route_table_type must be either'public' or 'private'"
  }
}

variable "igw_id" {
  type = string
  default = ""
}

variable "eni_ids" {
  type = list(string)
  default = []
}

variable "common_tags" {
  description = "Common tags for all resources"
  type = map(string)
}

variable "tgw_id" {
  type = string
  default = "null"
}

variable "create_tgw" {
  type = bool
  default = false
}