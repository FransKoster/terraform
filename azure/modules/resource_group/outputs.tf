output "resource_group_names" {
  description = "The names of the created resource groups"
  value       = [for rg in azurerm_resource_group.rgs : rg.name]
}

output "resource_group_locations" {
  description = "The locations of the created resource groups"
  value       = [for rg in azurerm_resource_group.rgs : rg.location]
}
