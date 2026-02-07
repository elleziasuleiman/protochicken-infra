output "jumpbox_public_ip" {
  value = azurerm_public_ip.jumpbox_ip.ip_address
}

output "container_app_url" {
  value = azurerm_container_app.app.ingress[0].fqdn
}