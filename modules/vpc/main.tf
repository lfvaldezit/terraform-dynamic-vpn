
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

# --------------- Interface Endpoint ----------------- #

# resource "aws_vpc_endpoint" "aws-ssm-int-endpoint" {
#   vpc_id = aws_vpc.this.id
#   subnet_ids = [for subnet in aws_subnet.private : subnet.id]
#   service_name = "com.amazonaws.${var.region}.ssm"
#   vpc_endpoint_type = "Interface"
#   security_group_ids = var.endpoint_security_group_ids
#   private_dns_enabled = true
# }

# resource "aws_vpc_endpoint" "aws-ssm-ec2-messages" {
#   vpc_id = aws_vpc.this.id
#   subnet_ids = [for subnet in aws_subnet.private : subnet.id]
#   service_name = "com.amazonaws.${var.region}.ec2messages"
#   vpc_endpoint_type = "Interface"
#   security_group_ids = var.endpoint_security_group_ids
#   private_dns_enabled = true
# }

# resource "aws_vpc_endpoint" "aws-ssm-messages" {
#   vpc_id = aws_vpc.this.id
#   subnet_ids = [for subnet in aws_subnet.private : subnet.id]
#   service_name = "com.amazonaws.${var.region}.ssmmessages"
#   vpc_endpoint_type = "Interface"
#   security_group_ids = var.endpoint_security_group_ids
#   private_dns_enabled = true
# }
