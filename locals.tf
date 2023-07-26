locals {
  env         = "environment"
  name        = "project_name"
  name_prefix = "${local.env}-${local.name}"

  common_tags = {
    BU  = "${local.name}"
    env = "${local.env}"
  }
}