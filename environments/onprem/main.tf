
module "vpc" {
  source          = "../../modules/vpc"
  name            = "${var.name}-vpc"
  cidr_block      = var.cidr_block
  region          = local.region
  common_tags     = local.common_tags
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "security-group" {
  source                     = "../../modules/security-group"
  name                       = "${var.name}-ec2-instance-secgrp"
  vpc_id                     = module.vpc.vpc_id
  security_group_description = var.security_group_description
  common_tags                = local.common_tags
  ingress_rules              = var.ingress_rules
  egress_rules               = var.egress_rules
}  