# Site-to-site VPN (In progress...)

## 🏗️ Architecture 

<img width="800" height="500" alt="image" src="https://raw.githubusercontent.com/lfvaldezit/terraform-dynamic-vpn/main/image.png" />

## 🌐 Stack Overview

* **VPC**: Provides an isolated virtual network where all AWS resources are deployed.
* **Internet Gateway**: Internet connectivity for resources.
* **EC2 Instances**: Virtual machines running StrongSwan (IPsec) and FRRouting to establish and route traffic through the VPN.
* **Transit Gateway**: Acts as a central hub to connect multiple VPCs and VPNs.
* **EC2 Instance Connect Endpoint**: SSH access to private-subnet EC2 instances through the AWS network



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
    └── ec2/     
    └── endpoints/     
    └── route-table/     
    └── security-group/
    └── transit-gateway/
    └── vpc/           
    └── vpn/     
```

