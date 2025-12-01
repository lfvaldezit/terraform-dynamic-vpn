variable "name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "security_group_description" {
  type = string
}

variable "public_subnets" {
  type = list(object({
    name       = string
    cidr_block = string
    az         = string
  }))
}

variable "private_subnets" {
  type = list(object({
    name       = string
    cidr_block = string
    az         = string
  }))
}

variable "create_igw" {
  type = bool
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    destination = string
    fromPort    = number
    toPort      = number
    protocol    = string
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules"
  type = list(object({
    destination = string
    fromPort    = number
    toPort      = number
    protocol    = string
  }))
  default = []
}

variable "router_ami_id" {
  type = string
}

variable "server_ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "router_source_dest_check" {
  type = bool
}

variable "ec2_source_dest_check" {
  type = bool
}

variable "instance_count" {
  type = string
}

variable "enable_public_eni" {
  type = bool
}