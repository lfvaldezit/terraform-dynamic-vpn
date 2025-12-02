variable "name" {
  type = string
}
variable "transit_gateway_id" {
  type = string
}

variable "customer_gateway" {
    type = list(object({
      bgp_asn = number,
      ip_address = string,
      name = string
    }))  
}
variable "common_tags" {
  type = map(string)
}

variable "transit_gateway_route_table_id" {
  type = string
}