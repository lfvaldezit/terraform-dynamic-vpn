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
  tgw_name         = "${var.name}-tgw"
  vpn1_name        = "${var.name}-vpn-1"
  vpn2_name        = "${var.name}-vpn-2"
  server_name      = "${var.name}-ec2"
  private_rt_name  = "${var.name}-private-rt"
}
