
output "tunnel1_address" {
  value = aws_vpn_connection.this[*].tunnel1_address
}

output "tunnel2_address" {
  value = aws_vpn_connection.this[*].tunnel2_address
}
