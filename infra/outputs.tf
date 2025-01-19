output "ec2_ssh_string" {
  value = module.ec2.ssh_connection_string_for_ec2
}