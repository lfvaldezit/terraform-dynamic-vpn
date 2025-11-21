module vpc {
    source = "../../modules/vpc"
    name = local.vpc_name
    cidr_block = var.cidr_block
    common_tags = local.common_tags
    private_subnets = var.private_subnets
    create_igw = var.create_igw
}

module tgw {
    source = "../../modules/transit-gateway"
    name = local.tgw_name
    vpc_id = module.vpc.vpc_id
    subnets_ids = module.vpc.sn_private_id
    amazon_side_asn = var.amazon_side_asn
    common_tags = local.common_tags
}

module vpn-1 {
    source = "../../modules/vpn"
    name = local.vpn1_name
    customer_gateway =  var.customer_gateway_1
    transit_gateway_id = module.tgw.transit_gateway_id 
    common_tags = local.common_tags
}
# module vpn-2 {
#     source = "../../modules/vpn"
#     name = local.vpn2_name
#     customer_gateway =  var.customer_gateway_2
#     transit_gateway_id = module.tgw.transit_gateway_id 
#     common_tags = local.common_tags
# }