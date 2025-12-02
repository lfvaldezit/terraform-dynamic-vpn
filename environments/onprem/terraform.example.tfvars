
name = "vpn-onprem"

# --------------- VPC & Subnets ----------------- #

cidr_block = "172.17.0.0/16"

security_group_description = "Security Group for EC2 Instance"

public_subnets = [{ name = "vpn-onprem-sn-pub-A", cidr_block = "172.17.0.0/24", az = "us-east-1a" }]

private_subnets = [{ name = "vpn-onprem-sn-priv-A", cidr_block = "172.17.1.0/24", az = "us-east-1a" },
{ name = "vpn-onprem-sn-priv-B", cidr_block = "172.17.2.0/24", az = "us-east-1a" }]

create_igw               = true
router_source_dest_check = false
ec2_source_dest_check    = true
enable_public_eni        = true


# --------------- Security Groups ----------------- #

ingress_rules = [{ destination = "0.0.0.0/0", fromPort = 22, toPort = 22, protocol = "tcp" },
  { destination = "0.0.0.0/0", fromPort = 80, toPort = 80, protocol = "tcp" },
{ destination = "0.0.0.0/0", fromPort = -1, toPort = -1, protocol = "icmp" }]

egress_rules = [{ destination = "0.0.0.0/0", fromPort = 0, toPort = 0, protocol = "-1" }]

# --------------- EC2 ----------------- #

router_ami_id  = "ami-0ac80df6eff0e70b5"
server_ami_id  = "ami-08982f1c5bf93d976"
instance_type  = "t3.small"
instance_count = "2"