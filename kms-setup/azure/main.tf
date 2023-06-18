data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}
provider "azuread" {
  tenant_id = data.azurerm_client_config.current.tenant_id
}

# Retrieve domain information
data "azuread_domains" "example" {
  only_initial = true
}

# Create an application
resource "azuread_application" "example" {
  display_name = "fle-demo-app"
}
resource "azurerm_key_vault_access_policy" "example-principal" {
  key_vault_id = azurerm_key_vault.example.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azuread_service_principal.example.object_id

  key_permissions = [
    "Create", "Delete", "Update", "Get", "List", "Decrypt", "Encrypt", "Sign", "UnwrapKey", "Verify", "WrapKey","Rotate","GetRotationPolicy","SetRotationPolicy", "Purge","Recover"
  ]
}
# Create a service principal
resource "azuread_service_principal" "example" {
  application_id = azuread_application.example.application_id
  use_existing   = true
}
# Create a user
resource "azuread_user" "example" {
  user_principal_name = "ExampleUser@${data.azuread_domains.example.domains.0.domain_name}"
  display_name        = "Example User"
  password            = "Vartavag1241!"
  
}
resource "azuread_application_password" "example" {
  application_object_id = azuread_application.example.object_id
}

resource "azurerm_key_vault" "example" {
  name                = "fle-azure-vault"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [  
        "Create", "Delete", "Update", "Get", "List", "Decrypt", "Encrypt", "Sign", "UnwrapKey", "Verify", "WrapKey","Rotate","GetRotationPolicy","SetRotationPolicy", "Purge","Recover"
    ]

    secret_permissions = [
      "Get","List"
    ]

    storage_permissions = [
      "Get"
    ]
  }
}



resource "azurerm_key_vault_key" "key" {
  name = "fle-azure-vault-key"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }
}


