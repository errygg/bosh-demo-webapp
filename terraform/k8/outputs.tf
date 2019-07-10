output "consul_server_public_ip" {
  value = "${azurerm_public_ip.consul_server.*.ip_address}"
}

output "consul_client_public_ip" {
  value = "${azurerm_public_ip.consul_client.*.ip_address}"
}