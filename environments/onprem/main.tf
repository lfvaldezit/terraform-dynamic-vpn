
module "vpc" {
  source          = "../../modules/vpc"
  name            = local.vpc_name
  cidr_block      = var.cidr_block
  common_tags     = local.common_tags
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  create_igw = var.create_igw
}

module "security-group" {
  source                     = "../../modules/security-group"
  name                       = local.sec_grp_ec2_name
  vpc_id                     = module.vpc.vpc_id
  security_group_description = var.security_group_description
  common_tags                = local.common_tags
  ingress_rules              = var.ingress_rules
  egress_rules               = var.egress_rules
}

module "router-1" {
  source             = "../../modules/ec2"
  name               = local.router-1_name
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_type        = "public"
  public_subnet_id   = module.vpc.sn_public_id[0]
  subnet_id          = module.vpc.sn_private_id[0]
  security_group_ids = [module.security-group.security_group_id]
  common_tags        = local.common_tags
  source_dest_check = var.source_dest_check
  user_data = <<-EOF
            #!/bin/bash -xe
            apt-get update && apt-get install -y strongswan wget
            mkdir /home/ubuntu/demo_assets
            cd /home/ubuntu/demo_assets
            wget https://raw.githubusercontent.com/lfvaldezit/terraform-dynamic-vpn/main/scripts/ipsec.conf
            wget https://raw.githubusercontent.com/lfvaldezit/terraform-dynamic-vpn/main/scripts/ipsec.secrets
            wget https://raw.githubusercontent.com/lfvaldezit/terraform-dynamic-vpn/main/scripts/51-eth1.yaml
            wget https://raw.githubusercontent.com/lfvaldezit/terraform-dynamic-vpn/main/scripts/ffrouting-install.sh
            wget https://raw.githubusercontent.com/lfvaldezit/terraform-dynamic-vpn/main/scripts/ipsec-vti.sh
            chown ubuntu:ubuntu /home/ubuntu/demo_assets -R
            cp /home/ubuntu/demo_assets/51-eth1.yaml /etc/netplan
            netplan --debug apply
  EOF
}       

module "router-2" {
  source             = "../../modules/ec2"
  name               = local.router-2_name
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_type        = "public"
  public_subnet_id   = module.vpc.sn_public_id[0]
  subnet_id          = module.vpc.sn_private_id[1]
  security_group_ids = [module.security-group.security_group_id]
  common_tags        = local.common_tags
  source_dest_check = var.source_dest_check
  user_data = <<-EOF
            !/bin/bash -xe
            apt-get update && apt-get install -y strongswan wget
            mkdir /home/ubuntu/demo_assets
            cd /home/ubuntu/demo_assets
            wget https://raw.githubusercontent.com/lfvaldezit/terraform-dynamic-vpn/main/scripts/ipsec.conf
            wget https://raw.githubusercontent.com/lfvaldezit/terraform-dynamic-vpn/main/scripts/ipsec.secrets
            wget https://raw.githubusercontent.com/lfvaldezit/terraform-dynamic-vpn/main/scripts/51-eth1.yaml
            wget https://raw.githubusercontent.com/lfvaldezit/terraform-dynamic-vpn/main/scripts/ffrouting-install.sh
            wget https://raw.githubusercontent.com/lfvaldezit/terraform-dynamic-vpn/main/scripts/ipsec-vti.sh
            chown ubuntu:ubuntu /home/ubuntu/demo_assets -R
            cp /home/ubuntu/demo_assets/51-eth1.yaml /etc/netplan
            netplan --debug apply
  EOF
}
