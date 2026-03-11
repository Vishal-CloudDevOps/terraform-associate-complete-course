output "server_ip"  { value = module.web_server.public_ip }
output "server_id"  { value = module.web_server.instance_id }
output "sg_id"      { value = module.web_sg.security_group_id }
