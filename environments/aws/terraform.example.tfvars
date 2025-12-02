
name = "vpn-aws"

# --------------- VPC & Subnets ----------------- #

cidr_block = "192.168.0.0/16"

security_group_description = "Security Group for EC2 Instance"


private_subnets = [{ name = "vpn-aws-sn-priv-A", cidr_block = "192.168.1.0/24", az = "us-east-1a" },
{ name = "vpn-aws-sn-priv-B", cidr_block = "192.168.2.0/24", az = "us-east-1b" }]

create_igw        = false
source_dest_check = true
enable_public_eni = false

# --------------- TGW ----------------- #

amazon_side_asn = "64512"
create_tgw      = true

# --------------- Customer Gateway ----------------- #

customer_gateway_1 = [{ bgp_asn = 65011, ip_address = "ROUTER1_CONN1_TUNNEL1-2_ONPREM_OUTSIDE_IP", name = "vpn-aws-cgw-1" }]
customer_gateway_2 = [{ bgp_asn = 65011, ip_address = "ROUTER2_CONN1_TUNNEL1-2_ONPREM_OUTSIDE_IP", name = "vpn-aws-cgw-2" }]

# --------------- Security Groups ----------------- #

ingress_rules = [{ destination = "0.0.0.0/0", fromPort = 22, toPort = 22, protocol = "tcp" },
  { destination = "0.0.0.0/0", fromPort = 80, toPort = 80, protocol = "tcp" },
{ destination = "0.0.0.0/0", fromPort = -1, toPort = -1, protocol = "icmp" }]

egress_rules = [{ destination = "0.0.0.0/0", fromPort = 0, toPort = 0, protocol = "-1" }]

# --------------- EC2 ----------------- #

ami_id         = "ami-0ac80df6eff0e70b5"
instance_type  = "t3.small"
instance_count = "2"