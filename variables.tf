variable "name" {
  description = "The name of the role. Must be unique on the PostgreSQL server instance where it is configured."
  type        = string
}

variable "password" {
  description = "Sets the role's password. A password is only of use for roles having the login attribute set to true."
  type        = string
  default     = null
}

variable "superuser" {
  description = "Defines whether the role is a superuser, and therefore can override all access restrictions within the database. Defaults to false."
  type        = bool
  default     = false
}

variable "create_database" {
  description = "Defines a role's ability to execute CREATE DATABASE. Defaults to false."
  type        = bool
  default     = false
}

variable "create_role" {
  description = "Defines a role's ability to execute CREATE ROLE. A role with this privilege can also alter and drop other roles. Defaults to false."
  type        = bool
  default     = false
}

variable "inherit" {
  description = "Defines whether a role inherits the privileges of roles it is a member of. Defaults to true."
  type        = bool
  default     = true
}

variable "login" {
  description = "Defines whether role is allowed to log in. Roles without this attribute are useful for managing database privileges, but are not users in the usual sense of the word. Defaults to true."
  type        = bool
  default     = true
}

variable "replication" {
  description = "Defines whether a role is allowed to initiate streaming replication or put the system in and out of backup mode. Default value is false"
  type        = bool
  default     = false
}

variable "connection_limit" {
  description = "If this role can log in, this specifies how many concurrent connections the role can establish. -1 means no limit. Defaults to -1."
  type        = number
  default     = -1
}

variable "roles" {
  description = "Defines list of roles which will be granted to this new role. Defaults to []."
  type        = list(string)
  default     = []
}

variable "grants" {
  description = <<EOT
  <br><b>database:</b> The database to grant privileges on for this role. Defaults to null.
  <br><b>object_type:</b> The PostgreSQL object type to grant the privileges on (one of: database, schema, table, sequence, function, procedure, routine, foreign_data_wrapper, foreign_server, column). Defaults to null.
  <br><b>privileges:</b> The list of privileges to grant. There are different kinds of privileges: SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER, CREATE, CONNECT, TEMPORARY, EXECUTE, and USAGE. An empty list could be provided to revoke all privileges for this role. Defaults to null.
  <br><b>schema:</b> The database schema to grant privileges on for this role (Required except if object_type is database). Defaults to null.
  <br><b>objects:</b> The objects upon which to grant the privileges. An empty list means to grant permissions on all objects of the specified type. You cannot specify this option if the object_type is database or schema. When object_type is column, only one value is allowed. Defaults to [].
  <br><b>columns:</b> The columns upon which to grant the privileges. Required when object_type is column. You cannot specify this option if the object_type is not column. Defaults to [].
  <br><b>with_grant_option:</b> Whether the recipient of these privileges can grant the same privileges to others. Defaults to false.
EOT
  type        = list(object({
    database          = string
    object_type       = string
    privileges        = list(string)
    schema            = optional(string)
    objects           = optional(list(string), [])
    columns           = optional(list(string), [])
    with_grant_option = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue(flatten([
      for k in var.grants : contains([
        "database", "schema", "table", "sequence", "function", "procedure", "routine", "foreign_data_wrapper",
        "foreign_server", "column",
      ], k["object_type"])
    ]))
    error_message = "object_type value must be database, schema, table, sequence, function, procedure, routine, foreign_data_wrapper, foreign_server, or column."
  }

  validation {
    condition = alltrue(flatten([
      for k in var.grants :flatten([
        for v in k["privileges"] :contains([
          "SELECT", "INSERT", "UPDATE", "DELETE", "TRUNCATE", "REFERENCES", "TRIGGER", "CREATE", "CONNECT", "TEMPORARY",
          "EXECUTE", "USAGE", "ALL"
        ], v)
      ])
    ]))
    error_message = "privileges value must be SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER, CREATE, CONNECT, TEMPORARY, EXECUTE, USAGE and ALL."
  }
}