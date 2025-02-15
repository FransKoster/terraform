provider "azurerm" {
  features {}
}

# Create resource groups from the list
resource "azurerm_resource_group" "rgs" {
  for_each = { for rg in var.resource_groups : rg.name => rg }

  name     = each.value.name
  location = each.value.location
}
