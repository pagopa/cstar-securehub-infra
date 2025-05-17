variable "key_vault_id" {
  type        = string
  description = "The ID of the Key Vault to which the policies will be applied"
}

variable "object_ids" {
  type        = list(string)
  description = "List of object IDs (users, groups, or service principals) to grant access"
  default     = []
}

variable "policies_environment" {
  type        = string
  description = "Environment name (e.g., dev, uat, prod)"
  default     = "dev"
}

variable "role" {
  type        = string
  description = "Role name for the access policy (used for naming and conditionals)"
  default     = "default"
}

# Get Key Vault to access tenant ID
data "azurerm_key_vault" "kv" {
  name                = split("/", var.key_vault_id)[8]
  resource_group_name = split("/", var.key_vault_id)[4]
}

# Define environment-specific permission sets
locals {
  # Base permission sets (can be overridden per environment)
  base_permission_sets = {
    admin = {
      key_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"]
      secret_permissions = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
      certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"]
    },
    developer = {
      key_permissions = ["Get", "List"]
      secret_permissions = ["Get", "List"]
      certificate_permissions = ["Get", "List"]
    },
    readonly = {
      key_permissions = ["Get", "List"]
      secret_permissions = ["Get", "List"]
      certificate_permissions = ["Get", "List"]
    }
  }

  # Environment-specific overrides
  # Format: env_role = { permissions }
  env_specific_overrides = {
    # Developers get full permissions in development
    "dev_developer" = {
      key_permissions = ["Get", "List", "Update", "Create", "Import"]
      secret_permissions = ["Get", "List", "Set"]
      certificate_permissions = ["Get", "List", "Update", "Create", "Import"]
    },
    # Add more environment-role specific overrides as needed
  }

  # Get the base permissions based on role
  base_permissions = local.base_permission_sets[var.role]

  # Get any environment-specific overrides
  env_override_key = "${var.policies_environment}_${var.role}"
  env_overrides = lookup(local.env_specific_overrides, local.env_override_key, {})

  # Merge base permissions with environment overrides
  merged_permissions = merge(
    local.base_permissions,
    local.env_overrides
  )
}

# Create access policies if object_ids are provided
resource "azurerm_key_vault_access_policy" "policy" {
  for_each = toset(var.object_ids)

  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_key_vault.kv.tenant_id
  object_id    = each.key

  key_permissions         = local.merged_permissions.key_permissions
  secret_permissions      = local.merged_permissions.secret_permissions
  certificate_permissions = local.merged_permissions.certificate_permissions
}
