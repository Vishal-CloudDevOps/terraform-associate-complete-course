output "vpc_id"      { value = module.networking.vpc_id }
output "server_ips"  { value = module.compute.public_ips }
output "ami_used"    { value = module.compute.ami_id }
