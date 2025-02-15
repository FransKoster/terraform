
module "resource_groups" {
  source          = "../modules/resource_group"
  resource_groups = local.resource_groups
}
