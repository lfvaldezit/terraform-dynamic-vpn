
resource "aws_customer_gateway" "this" {
    count = length(var.customer_gateway)
    bgp_asn = var.customer_gateway[count.index].bgp_asn
    ip_address = var.customer_gateway[count.index].ip_address
    type = "ipsec.1"
    tags = merge({Name = var.customer_gateway[count.index].name}, var.common_tags)
}

resource "aws_vpn_connection" "this" {
    count = length(var.customer_gateway)
    customer_gateway_id = aws_customer_gateway.this[count.index].id
    transit_gateway_id = var.transit_gateway_id
    enable_acceleration = true
    static_routes_only = false
    type = "ipsec.1"
    tags = merge({Name = "${var.name}"}, var.common_tags)
}