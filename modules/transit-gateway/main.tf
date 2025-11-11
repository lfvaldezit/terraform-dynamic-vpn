
resource "aws_ec2_transit_gateway" "this" {
    amazon_side_asn = var.amazon_side_asn
    default_route_table_association = false
    default_route_table_propagation = false
    tags = merge({Name = "${var.name}"}, var.common_tags)
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  subnet_ids         = var.subnets_ids
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.vpc_id
}

resource "aws_ec2_transit_gateway_route_table" "this" {
    transit_gateway_id = aws_ec2_transit_gateway.this.id
    tags = merge({Name = "${var.name}"}, var.common_tags)
}