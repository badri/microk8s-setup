[microk8s_HA]
${ha_host} ansible_ssh_host=${ha_ip}


[microk8s_WORKERS]
%{ for name,ip in vms ~}
%{ if name != ha_host ~}
${name} ansible_ssh_host=${ip}
%{ endif ~}
%{ endfor ~}


[all:vars]
ansible_ssh_user=${username}
ansible_ssh_private_key_file=private-key
microk8s_version=1.27/stable
ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
# cluster specifics
email=${email}
domain=${dns}
tld=${tld}
sb_url=${sb_url}
password=${password}
cluster_uuid=${cluster_uuid}
