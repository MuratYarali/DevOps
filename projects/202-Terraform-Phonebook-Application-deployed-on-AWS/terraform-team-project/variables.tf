variable "awsprops" {
  type = map(string)
  default = {
    keyname      = "Engin_Linux"
    instancetype = "t2.micro"

  }

}

variable "dbprops" {
  type = map(string)
  default = {
    identifier = ""
    DbName     = "clarusway_phonebook"
    username   = "admin"
    password   = ""
  }

}

variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}