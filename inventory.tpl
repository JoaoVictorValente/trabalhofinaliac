all:
  hosts:
    ${vms[0].name}:
      ansible_host: ${vms[0].public_ip_address}
      ansible_user: ${username}
      ansible_ssh_private_key_file: /home/azureuser/trabalhoiac/private_key.pem
    ${vms[1].name}:
      ansible_host: ${vms[1].public_ip_address}
      ansible_user: ${username}
      ansible_ssh_private_key_file: /home/azureuser/trabalhoiac/private_key.pem

web:
  hosts:
    ${vms[0].name}

db:
  hosts:
    ${vms[1].name}
