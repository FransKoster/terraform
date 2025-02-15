# Define a list of resource groups
locals {
  resource_groups = [
    { name = "rg-one", location = "swedencentral" },
    { name = "rg-two", location = "westeurope" },
    { name = "rg-three", location = "northeurope" }
  ]
}
