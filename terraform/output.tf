output "public_ip" {
  description = "IP Público"
  value       = mgc_virtual_machine_instances.this.network.public_address
}