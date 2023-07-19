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
    for v in var.grants :
    length(v["objects"]) == 0 ?
    "${v["database"]} | ${v["object_type"]} | ${join(", ", v["privileges"])}" :
    "${v["database"]} | ${v["object_type"]} | ${join(", ", v["objects"])} | ${join(", ", v["privileges"])}"
    => v
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