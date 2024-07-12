myhosts:
  hosts:
  %{ for vm in vms ~}
  ${vm.name}:
      ansible_host: ${vm.public_ip_address}
  %{ endfor ~}
vars:
    ansible_user: ${username}