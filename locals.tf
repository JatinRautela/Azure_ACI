# locals {
#   env         = "environment"
#   name        = "project_name"
#   name_prefix = "${local.env}-${local.name}"

#   common_tags = {
#     BU  = "${local.name}"
#     env = "${local.env}"
#   }
# }


locals {
  project_name_prefix = var.name == "" ? terraform.workspace : var.name
  common_tags         = length(var.common_tags) == 0 ? var.default_tags : merge(var.default_tags, var.common_tags)
}