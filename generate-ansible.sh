#!/bin/bash

# Get the Terraform output
instance_ips=$(terraform output -json web_nodes_ips | jq -r '.[]')

# Create Ansible inventory file
inventory_file="inventory.ini"
echo "[web_nodes]" > $inventory_file

for ip in ${web_nodes_ips[@]}; do
    echo $ip >> $inventory_file
done


