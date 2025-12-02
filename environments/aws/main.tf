module "vpc" {
  source          = "../../modules/vpc"
  name            = local.vpc_name
  cidr_block      = var.cidr_block
  common_tags     = local.common_tags
  private_subnets = var.private_subnets
  create_igw      = var.create_igw
}

module "tgw" {
  source          = "../../modules/transit-gateway"
  name            = local.tgw_name
  vpc_id          = module.vpc.vpc_id
  subnets_ids     = module.vpc.sn_private_id
  amazon_side_asn = var.amazon_side_asn
  common_tags     = local.common_tags
}

module "vpn-1" {
  source                         = "../../modules/vpn"
  name                           = local.vpn1_name
  customer_gateway               = var.customer_gateway_1
  transit_gateway_id             = module.tgw.transit_gateway_id
  transit_gateway_route_table_id = module.tgw.transit_gateway_route_table
  common_tags                    = local.common_tags
}

module vpn-2 {
    source = "../../modules/vpn"
    name = local.vpn2_name
    customer_gateway =  var.customer_gateway_2
    transit_gateway_id = module.tgw.transit_gateway_id 
transit_gateway_route_table_id = module.tgw.transit_gateway_route_table
    common_tags = local.common_tags
}

module "private-rt" {
  source           = "../../modules/route-table"
  name             = local.private_rt_name
  route_table_type = "private"
  subnet_ids       = module.vpc.sn_private_id
  vpc_id           = module.vpc.vpc_id
  create_tgw       = var.create_tgw
  tgw_id           = module.tgw.transit_gateway_id
  common_tags      = local.common_tags
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

module "ec2" {
  source             = "../../modules/ec2"
  name               = local.server_name
  instance_count     = var.instance_count
  enable_public_eni  = var.enable_public_eni
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  public_subnet_id   = module.vpc.sn_public_id
  private_subnet_id  = module.vpc.sn_private_id
  security_group_ids = [module.security-group.security_group_id]
  common_tags        = local.common_tags
  source_dest_check  = var.source_dest_check
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