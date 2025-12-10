
##  VPN TUNNEL - CONFIGURATION

Go to EC2 console.   
Select VPC-ONPREM-ROUTER-1
Connect to instance using `Session Manager`.   

```bash
sudo bash
cd /home/ubuntu/demo_assets/
nano ipsec.conf

Replace the following:

conn AWS-VPC-GW1
         # Customer Gateway: :
         left=ROUTER1_PRIVATE1_IP
         leftid=CONN1_TUNNEL1_ONPREM_OUTSIDE_IP
         # Virtual Private Gateway :
         right=CONN1_TUNNEL1_AWS_OUTSIDE_IP
         rightid=CONN1_TUNNEL1_AWS_OUTSIDE_IP
         auto=start
         mark=100
         #reqid=1
conn AWS-VPC-GW2
         # Customer Gateway: :
         left=ROUTER1_PRIVATE2_IP
         leftid=CONN1_TUNNEL2_ONPREM_OUTSIDE_IP
         # Virtual Private Gateway :
         right=CONN1_TUNNEL2_AWS_OUTSIDE_IP
         rightid=CONN1_TUNNEL2_AWS_OUTSIDE_IP
         auto=start
         mark=200


CTRL+O to save and CTRL+X to exit
```

```bash
nano ipsec.secrets

Replace the following:

CONN1_TUNNEL1_ONPREM_OUTSIDE_IP CONN1_TUNNEL1_AWS_OUTSIDE_IP : PSK "CONN1_TUNNEL1_PresharedKey"
CONN1_TUNNEL2_ONPREM_OUTSIDE_IP CONN1_TUNNEL2_AWS_OUTSIDE_IP : PSK "CONN1_TUNNEL2_PresharedKey"

CTRL+O to save and CTRL+X to exit
```

```bash
nano ipsec-vti.sh

Replace the following:

case "$PLUTO_CONNECTION" in
AWS-VPC-GW1)
VTI_INTERFACE=vti1
VTI_LOCALADDR=CONN1_TUNNEL1_ONPREM_INSIDE_IP
VTI_REMOTEADDR=CONN1_TUNNEL1_AWS_INSIDE_IP
;;
AWS-VPC-GW2)
VTI_INTERFACE=vti2
VTI_LOCALADDR=CONN1_TUNNEL2_ONPREM_INSIDE_IP
VTI_REMOTEADDR=CONN1_TUNNEL2_AWS_INSIDE_IP

CTRL+O to save and CTRL+X to exit
```

```bash
cp ipsec* /etc
chmod +x /etc/ipsec-vti.sh
systemctl restart strongswan
```

Check tunnels by running `ifconfig`.   
You can also check the connection in the AWS VPC console => Site-to-site VPN connections.   