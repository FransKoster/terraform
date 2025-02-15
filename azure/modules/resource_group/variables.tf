variable "resource_groups" {
  description = "A list of resource groups with names and locations"
  type = list(object({
    name     = string
    location = string
  }))
  default = [
    { name = "example-resources-1", location = "East US" },
    { name = "example-resources-2", location = "West US" },
    { name = "example-resources-3", location = "Central US" }
  ]
}
