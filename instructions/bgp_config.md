##  BGP CONFIGURATION

Go to EC2 console.   
Select `VPC-ONPREM-ROUTER-1`   
Connect to instance using `Session Manager`.

Install `FRR` to add BGP capability   

```bash
sudo bash
cd /home/ubuntu/demo_assets
chmod +x ffrouting-install.sh
./ffrouting-install.sh

It will take 10-15 minutes
```

Configuration:      

```bash
vtysh
conf t
frr defaults traditional
router bgp 65011
neighbor CONN1_TUNNEL1_AWS_INSIDE_IP remote-as 64512
neighbor CONN1_TUNNEL2_AWS_INSIDE_IP remote-as 64512
no bgp ebgp-requires-policy
address-family ipv4 unicast
redistribute connected
exit-address-family
exit
exit
wr
exit

sudo reboot

```

Do the same for `VPC-ONPREM-ROUTER-2` EC2 instance

Verification commands:   

```bash
vtysh
show ip route
```