output "vpc_id" {
    value = aws_vpc.this.id
}

output "sn_public_id" {
    value = [for s in aws_subnet.public : s.id]
}

output "sn_private_id" {
    value = [for s in aws_subnet.private : s.id]
}

output "igw_id" {
    value = try(aws_internet_gateway.this[0].id, null)
}