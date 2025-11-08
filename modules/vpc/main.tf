
data "aws_region" "current" {}

# --------------- VPC & Subnets ----------------- #

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = merge({Name = var.name}, var.common_tags)
}

resource "aws_subnet" "public" {
  for_each = { for subnet in var.public_subnets : subnet.name => subnet }
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags = merge({Name = each.value.name}, var.common_tags)
}

resource "aws_subnet" "private" {
  for_each = { for subnet in var.private_subnets : subnet.name => subnet }
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = false
  tags = merge({Name = each.value.name}, var.common_tags)
}

# --------------- IGW ----------------- #

resource "aws_internet_gateway" "this" {
  count = var.create_igw == true ? 1 : 0 
  vpc_id = aws_vpc.this.id
  tags = merge({Name = "${var.name}-igw"}, var.common_tags)
}

# --------------- Route Table ----------------- #

resource "aws_route_table" "public" {
  count = var.create_igw ? length(aws_subnet.public) : 0
  vpc_id = aws_vpc.this.id
  tags = merge({Name = "${var.name}-public-rt-${upper
  (substr(values(aws_subnet.public)[count.index].availability_zone,-1, 1))}"}, 
  var.common_tags)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }
}

resource "aws_route_table_association" "public" {
  count = var.create_igw ? length(aws_subnet.public) : 0
  subnet_id = values(aws_subnet.public)[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route_table" "private" {
  count = length(aws_subnet.private)
  vpc_id = aws_vpc.this.id
  tags = merge({Name = "${var.name}-private-rt-${upper
  (substr(values(aws_subnet.private)[count.index].availability_zone,-1, 1))}"}, 
  var.common_tags)
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)
  subnet_id = values(aws_subnet.private)[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# --------------- Interface Endpoint ----------------- #


# resource "aws_vpc_endpoint" "aws-ssm-int-endpoint" {
#   vpc_id = aws_vpc.this.id
#   subnet_ids = [for subnet in aws_subnet.private : subnet.id]
#   service_name = "com.amazonaws.${data.aws_region.current}.ssm"
#   vpc_endpoint_type = "Interface"
#   security_group_ids = var.endpoint_security_group_ids
#   private_dns_enabled = true
# }

# resource "aws_vpc_endpoint" "aws-ssm-ec2-messages" {
#   vpc_id = aws_vpc.this.id
#   subnet_ids = [for subnet in aws_subnet.private : subnet.id]
#   service_name = "com.amazonaws.${data.aws_region.current}.ec2messages"
#   vpc_endpoint_type = "Interface"
#   security_group_ids = var.endpoint_security_group_ids
#   private_dns_enabled = true
# }

# resource "aws_vpc_endpoint" "aws-ssm-messages" {
#   vpc_id = aws_vpc.this.id
#   subnet_ids = [for subnet in aws_subnet.private : subnet.id]
#   service_name = "com.amazonaws.${data.aws_region.current}.ssmmessages"
#   vpc_endpoint_type = "Interface"
#   security_group_ids = var.endpoint_security_group_ids
#   private_dns_enabled = true
# }
