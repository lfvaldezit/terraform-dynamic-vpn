
output "tunnel1_inside_cidr" {
  value = aws_vpn_connection.this.tunnel1_inside_cidr
}

output "tunnel2_inside_cidr" {
  value = aws_vpn_connection.this.tunnel2_inside_cidr
}

output "tunnel1_preshared_key" {
  value = aws_vpn_connection.this.tunnel1_preshared_key
}

output "tunnel2_preshared_key" {
  value = aws_vpn_connection.this.tunnel2_preshared_key
}