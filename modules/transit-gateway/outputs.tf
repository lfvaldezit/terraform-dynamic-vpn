output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.this.id
}

output "transit_gateway_route_table" {
  value = aws_ec2_transit_gateway_route_table.this.id
}