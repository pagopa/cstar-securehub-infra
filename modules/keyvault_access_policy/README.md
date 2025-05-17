# Key Vault Access Policy Module

This module simplifies managing Azure Key Vault access policies with environment-specific permissions.

## Features

- **Environment-Aware**: Different permissions per environment (dev, uat, prod)
- **Role-Based**: Define access based on roles (admin, developer, readonly)
- **Simple Interface**: Just provide object IDs and environment
- **Flexible**: Override permissions per environment-role combination

## Basic Usage

```hcl
# Basic usage with environment
module "dev_access" {
  source      = "../../modules/keyvault_access_policy"
  key_vault_id = azurerm_key_vault.example.id
  object_ids  = [data.azuread_group.developers.object_id]
  environment = "dev"
  role        = "developer"
}
```

## Environment-Specific Examples

### Development Environment
```hcl
# Developers get full developer access in dev
module "dev_developers" {
  source      = "../../modules/keyvault_access_policy"
  key_vault_id = azurerm_key_vault.example.id
  object_ids  = [data.azuread_group.developers.object_id]
  environment = "dev"
  role        = "developer"
}
```

### Production Environment
```hcl
# Same developers get read-only in production
module "prod_developers" {
  source             = "../../modules/keyvault_access_policy"
  key_vault_id      = azurerm_key_vault.prod.id
  object_ids         = [data.azuread_group.developers.object_id]
  policies_environment = "prod"
  role              = "developer"  # Will be downgraded to read-only in prod
}

# Operations team keeps admin access in all environments
module "ops_team" {
  source             = "../../modules/keyvault_access_policy"
  key_vault_id      = azurerm_key_vault.example.id
  object_ids         = [data.azuread_group.ops_team.object_id]
  policies_environment = var.environment
  role              = "admin"
}
```

## Available Roles

### admin
- Full access to keys, secrets, and certificates
- Can manage permissions and purge deleted items
- Same in all environments

### developer
- **dev/uat**: Read and write access
- **prod**: Read-only access (unless overridden)

### readonly
- Read-only access in all environments

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| key_vault_id | The ID of the Key Vault | `string` | n/a | yes |
| object_ids | List of Azure AD object IDs to grant access | `list(string)` | `[]` | no |
| policies_environment | Environment name (e.g., dev, uat, prod) | `string` | `"dev"` | no |
| role | Role name (admin, developer, readonly) | `string` | `"default"` | no |

## Customizing Permissions

To customize permissions for specific environment-role combinations, modify the `env_specific_overrides` local variable in `main.tf`:

```hcl
env_specific_overrides = {
  # Developers get read-only in production
  "prod_developer" = {
    key_permissions = ["Get", "List"]
    secret_permissions = ["Get", "List"]
    certificate_permissions = ["Get", "List"]
  },
  # Add more overrides as needed
}
```
