resource "aws_route_table" "this" {
  count = length(var.subnet_ids)
  vpc_id = var.vpc_id
  tags = merge({Name = "${var.name}"-"${count.index+1}"})
#   tags = merge({Name = "${var.name}-public-rt-${upper
#   (substr(values(aws_subnet.public)[count.index].availability_zone,-1, 1))}"}, 
#   var.common_tags)
}

resource "aws_route" "public" {
    count = var.route_table_type == "public" ? length(var.subnet_ids) : 0
    route_table_id = aws_route_table.this[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
}

resource "aws_route" "private" {
    count = var.route_table_type == "private" && length(var.eni_ids) > 0  ? length(var.subnet_ids) : 0
    route_table_id = aws_route_table.this[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    network_interface_id = var.eni_ids[count.index % length(var.eni_ids)]
}

resource "aws_route" "private-tgw" {
  count = var.route_table_type == "private" && var.create_tgw ? length(var.subnet_ids) : 0
    route_table_id = aws_route_table.this[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    transit_gateway_id = var.tgw_id
}

resource "aws_route_table_association" "main" {
  count = length(var.subnet_ids)
  subnet_id      = var.subnet_ids[count.index]
  route_table_id = aws_route_table.this[count.index].id
}

