variable "name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "public_subnets" {
  type = list(object({
    name       = string
    cidr_block = string
    az         = string
  }))
  default = []
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

variable "amazon_side_asn" {
  type = string
}

variable "customer_gateway_1" {
  type = list(object({
    bgp_asn    = number,
    ip_address = string,
    name       = string
  }))
}

variable "customer_gateway_2" {
  type = list(object({
    bgp_asn    = number,
    ip_address = string,
    name       = string
  }))
}


variable "instance_count" {
  type = string
}

variable "enable_public_eni" {
  type = bool
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "source_dest_check" {
  type = bool
}

variable "security_group_description" {
  type = string
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

variable "create_tgw" {
  type = bool
}