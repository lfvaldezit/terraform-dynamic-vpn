locals {
  common_tags = {
    Environment = "onprem"
    Project     = "terraform-dynamic-vpn"
    Owner       = "user"
    CreatedBy   = "terraform"
  }
  
  region  = "us-east-1"
  profile = "default"

  vpc_name         = "${var.name}-vpc"
  sec_grp_ec2_name = "${var.name}-ec2-sec-grp"
  router-1_name         = "${var.name}-router-1"
  router-2_name         = "${var.name}-router-2"
}
