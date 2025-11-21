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
      bgp_asn = number,
      ip_address = string,
      name = string
    }))  
}

variable "customer_gateway_2" {
    type = list(object({
      bgp_asn = number,
      ip_address = string,
      name = string
    }))  
}
