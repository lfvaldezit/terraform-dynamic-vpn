output "CONN1_TUNNEL1_AWS_OUTSIDE_IP" {
    value = module.vpn-1.tunnel1_address
}

output "CONN1_TUNNEL2_AWS_OUTSIDE_IP" {
    value = module.vpn-1.tunnel2_address 
}

# output "CONN2_TUNNEL1_AWS_OUTSIDE_IP" {
#     value = module.vpn-2.tunnel1_address
# }

# output "CONN2_TUNNEL2_AWS_OUTSIDE_IP" {
#     value = module.vpn-2.tunnel2_address 
# }