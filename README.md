# PostgreSQL Role Terraform module

Terraform module which creates Role in PostgreSQL

## Usage

```terraform
module "role" {
  source = "git::https://github.com/pressreader/terraform-postgresql-role.git?ref=v1.0.0"

  name     = "Name of a role"
  password = "Password for the role" # Defaults to null

  superuser       = false # Defaults to false
  create_database = false # Defaults to false
  create_role     = false # Defaults to false
  inherit         = true  # Defaults to true
  login           = true  # Defaults to true
  replication     = false # Defaults to false

  connection_limit = 1000 # Defaults to -1

  roles = ["Name of a role"] # Defaults to []

  # Defaults to []
  grants = [
    {
      database          = "Name of database" # Defaults to null
      object_type       = "table"            # Defaults to null
      privileges        = ["ALL"]            # Defaults to null
      schema            = "public"           # Defaults to null
      objects           = []                 # Defaults to []
      columns           = []                 # Defaults to []
      with_grant_option = false              # Defaults to false
    }
  ]
}
```