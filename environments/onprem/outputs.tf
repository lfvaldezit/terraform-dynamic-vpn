output "CONN1_TUNNEL1-2_ONPREM_OUTSIDE_IP" {
    value = module.router-1.eip_address
}

output "ROUTER1_PRIVATE_IP" {
    value = module.router-1.priv-ip-address-0
}

# output "CONN2_TUNNEL1-2_ONPREM_OUTSIDE_IP" {
#     value = module.router-2.eip_address
# }

# output "ROUTER2_PRIVATE_IP" {
#     value = module.router-2.priv-ip-address-0
# }