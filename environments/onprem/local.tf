locals {
  common_tags = {
    Environment = "onprem"
    Project     = "terraform-dynamic-vpn"
    Owner       = "user"
    CreatedBy   = "terraform"
  }
  region = "us-east-1"
  profile = "default"
}
