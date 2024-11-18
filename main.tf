resource "postgresql_role" "main" {
  name     = var.name
  password = var.password

  superuser       = var.superuser
  create_database = var.create_database
  create_role     = var.create_role

  inherit = var.inherit
  login   = var.login

  replication      = var.replication
  connection_limit = var.connection_limit

  roles = var.roles
}

resource "postgresql_grant" "database_object_type_privileges" {
  for_each = {
    for v in var.grants : v.description => v
  }

  role = postgresql_role.main.name

  database    = each.value.database
  object_type = each.value.object_type
  privileges  = each.value.privileges
  schema      = each.value.schema

  objects           = each.value.objects
  columns           = each.value.columns
  with_grant_option = each.value.with_grant_option
}

resource "postgresql_default_privileges" "default_privileges" {
  for_each = {
    for v in var.default_grants : v.description => v
  }


  role  = postgresql_role.main.name
  owner = postgresql_role.main.name

  database    = each.value.database
  object_type = each.value.object_type
  privileges  = each.value.privileges
  schema      = each.value.schema

  with_grant_option = each.value.with_grant_option
}
