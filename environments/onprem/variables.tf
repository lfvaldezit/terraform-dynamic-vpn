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

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}