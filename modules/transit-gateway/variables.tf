variable "name" {
  description = "Base name prefix used to label all created resources "
  type = string
}

variable "common_tags" {
    description = "Common tags for all resources"
    type = map(string)
}

variable "amazon_side_asn" {
    description = "Private ASN for the amazon side of a BGP session"
    type = string
}

variable "subnets_ids" {
  description = "subnet IDs where TGW will be deployed"
  type = set(string)
}

variable "vpc_id" {
  description = "VPC ID where the TGW will be deployed"
  type = string
}