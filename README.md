# Site-to-site VPN (In progress...)

## 🏗️ Architecture 

<img width="800" height="500" alt="image" src="https://raw.githubusercontent.com/lfvaldezit/terraform-dynamic-vpn/main/image.png" />

## 🌐 Stack Overview

* **VPC**: Provides an isolated virtual network where all AWS resources are deployed.
* **Internet Gateway**: Internet connectivity for resources.
* **EC2 Instances**: Virtual machines running StrongSwan (IPsec) and FRRouting to establish and route traffic through the VPN.
* **Transit Gateway**: Acts as a central hub to connect multiple VPCs and VPNs.
* **EC2 Instance Connect Endpoint**: SSH access to private-subnet EC2 instances through the AWS network

## ⚙️ Configuration

1. **Clone the repository**

   ```bash
   git clone <your-repo-url>
   cd terraform-dynamic-vpn
   ```
2. **Configure AWS credentials**

   ```bash
   aws configure
   ```
3. **ON-PREM infrastructure**   
   Adjusts the variables in /environments/onprem/terraform.example.tfvars as needed

   ```bash
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
    ```

    ```bash
   cd /environments/onprem
   terraform init
   terraform apply
    ```

4. **AWS infrastructure**

   ```bash

   ```

## 📝 Instructions

- [VPN Tunnel Config](https://github.com/lfvaldezit/terraform-dynamic-vpn/blob/main/instructions/vpntunnel_config.md)
- [BGP Config](https://raw.githubusercontent.com/lfvaldezit/terraform-dynamic-vpn/main/instructions/bgp_config.md)

## 📁 Project Structure

```
├── image.png              
├── README.md        
├── .gitignore          
├── environments/
│   └── aws/
│   │   ├── locals.tf
│   │   ├── main.tf        
│   │   ├── outputs.tf 
│   │   ├── providers.tf
│   │   ├── terraform.example.tfvars
│   │   └── variables.tf
│   └── onprem/
│       ├── locals.tf
│       ├── main.tf        
│       ├── outputs.tf 
│       ├── providers.tf
│       ├── terraform.example.tfvars
│       └── variables.tf
├── instructions/ 
├── scripts/        
└── modules/
    ├── ec2/     
    ├── endpoints/     
    ├── route-table/     
    ├── security-group/
    ├── transit-gateway/
    ├── vpc/           
    └── vpn/     
```

