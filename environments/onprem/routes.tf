
resource "aws_route" "this-0" {
  route_table_id = module.vpc.route-table[0]
  destination_cidr_block = "192.168.0.0/16"
  network_interface_id = module.router-1.eni-1_id
}

resource "aws_route" "this-1" {
  route_table_id = module.vpc.route-table[1]
  destination_cidr_block = "192.168.0.0/16"
  network_interface_id =module.router-2.eni-1_id
}