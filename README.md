# config-manage-ansible
Configuration Management of IaC Provisioned Using Terraform


/* echo "[web_nodes]" > ./inventory.ini
      echo "${join("\n", aws_instance.web_nodes.*.public_ip)}" >> ./inventory.ini */