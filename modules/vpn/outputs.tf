
output "tunnel1_address" {
  value = aws_vpn_connection.this[*].tunnel1_address
}

output "tunnel2_address" {
  value = aws_vpn_connection.this[*].tunnel2_address
}

output "tunnel1_preshared_key" {
  value = aws_vpn_connection.this[*].tunnel1_preshared_key
}

output "tunnel2_preshared_key" {
  value = aws_vpn_connection.this[*].tunnel2_preshared_key
}