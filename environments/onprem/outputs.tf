output "CONN1_TUNNEL1-2_ONPREM_OUTSIDE_IP" {
  value = { for idx, outside_ip in module.router.public_ips :
    "ROUTER${idx + 1}_CONN1_TUNNEL1-2_ONPREM_OUTSIDE_IP: " => outside_ip
  }
}

output "ROUTER1_PRIVATE1-2_IP" {
  value = { for idx, private_ip in module.router.private_ips :
    "ROUTER${idx + 1}_PRIVATE1-2_IP: " => private_ip
  }
}
