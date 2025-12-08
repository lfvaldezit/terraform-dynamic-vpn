On-prem environment.   
Go to EC2 console.   
Connect to instance using `Session Manager`.   

```bash
sudo bash
cd /home/ubuntu/demo_assets/
nano ipsec.conf

CTRL+O to save and CTRL+X to exit

nano ipsec.secrets

CTRL+O to save and CTRL+X to exit

nano ipsec-vti.sh

CTRL+O to save and CTRL+X to exit

cp ipsec* /etc
chmod +x /etc/ipsec-vti.sh

systemctl restart strongswan
```

Check tunnels by running `ifconfig`.   
You can also check the connection in the AWS VPC console => Site-to-site VPN connections.   