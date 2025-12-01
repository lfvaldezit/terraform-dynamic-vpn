
module "vpc" {
  source          = "../../modules/vpc"
  name            = local.vpc_name
  cidr_block      = var.cidr_block
  common_tags     = local.common_tags
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  create_igw      = var.create_igw
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

module "public-rt" {
  source           = "../../modules/route-table"
  name             = local.public_rt_name
  route_table_type = "public"
  subnet_ids       = module.vpc.sn_public_id
  vpc_id           = module.vpc.vpc_id
  igw_id           = module.vpc.igw_id
  common_tags      = local.common_tags
}

module "private-rt" {
  depends_on       = [module.router]
  source           = "../../modules/route-table"
  name             = local.private_rt_name
  route_table_type = "private"
  subnet_ids       = module.vpc.sn_private_id
  vpc_id           = module.vpc.vpc_id
  eni_ids          = module.router.private_eni_ids
  common_tags      = local.common_tags
}

module "router" {
  source             = "../../modules/ec2"
  name               = local.router_name
  instance_count     = var.instance_count
  enable_public_eni  = var.enable_public_eni
  ami_id             = var.router_ami_id
  instance_type      = var.instance_type
  public_subnet_id   = module.vpc.sn_public_id
  private_subnet_id  = module.vpc.sn_private_id
  security_group_ids = [module.security-group.security_group_id]
  common_tags        = local.common_tags
  source_dest_check  = var.router_source_dest_check
  user_data          = <<-EOF
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

module "ec2" {
  source             = "../../modules/ec2"
  name               = "vpn-onprem-ec2"
  instance_count     = var.instance_count
  enable_public_eni  = false
  ami_id             = var.server_ami_id
  instance_type      = var.instance_type
  private_subnet_id  = module.vpc.sn_private_id
  security_group_ids = [module.security-group.security_group_id]
  common_tags        = local.common_tags
  source_dest_check  = var.ec2_source_dest_check
  user_data          = <<-EOF
            #!/bin/bash -xe
  EOF
}

module "ec2-endpoint" {
  source             = "../../modules/endpoints"
  name               = var.name
  security_group_ids = [module.security-group.security_group_id]
  subnet_id          = module.vpc.sn_private_id[0]
  common_tags        = local.common_tags
}