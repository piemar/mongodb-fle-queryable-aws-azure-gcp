
output "AZURE_KEY_VAULT_NAME" {
  value = azurerm_key_vault.example.name
}
output "AZURE_KEY_VAULT_ENDPOINT" {
  value = azurerm_key_vault.example.vault_uri
}

output "AZURE_KEY_VAULT_ID" {
  value = azurerm_key_vault.example.id
}
output "AZURE_KEY_VERSION" {
  value = azurerm_key_vault_key.key.version
}
output "AZURE_KEY_NAME" {
  value = azurerm_key_vault_key.key.name
}
output "AZURE_CLIENT_SECRET" {
  value = nonsensitive(azuread_application_password.example.value)
}
output "AZURE_TENANT_ID" {
  value = data.azurerm_client_config.current.tenant_id
}
output "AZURE_CLIENT_ID" {
  value = azuread_application.example.application_id
}
