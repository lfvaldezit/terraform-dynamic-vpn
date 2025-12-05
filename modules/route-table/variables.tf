variable "name" {
  description = "Base name prefix used to label all created resources"
  type = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the route tables will be created and associated"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the route table"
  type        = list(string)
}

variable "route_table_type" {
  description = "Specifies whether the route table is intended for public or private subnets"
  type        = string
  validation {
    condition     = contains(["public", "private"], var.route_table_type)
    error_message = "route_table_type must be either'public' or 'private'"
  }
}

variable "igw_id" {
  description = "Internet Gateway ID"
  type = string
  default = ""
}

variable "eni_ids" {
  description = "Elastic Network Interface ID"
  type = list(string)
  default = []
}

variable "common_tags" {
  description = "Common tags for all resources"
  type = map(string)
}

variable "tgw_id" {
  description = "Transit Gateway ID"
  type = string
  default = "null"
}

variable "create_tgw" {
  description = "Indicates whether the module should create a Transit Gateway"
  type = bool
  default = false
}