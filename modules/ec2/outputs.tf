output "eni-0_id" {
  value = aws_network_interface.eni-0.id
}

output "eni-1_id" {
  value = aws_network_interface.eni-1[0].id
}

output "eip_address" {
  value = aws_eip.this[0].public_ip
}

output "priv-ip-address-0" {
  value = aws_network_interface.eni-0.private_ip
}