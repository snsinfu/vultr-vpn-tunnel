variable "server_hostname" {
  type = string
}

variable "server_region" {
  type = string
}

variable "server_plan" {
  type = string
}

variable "server_os" {
  type = string
}

variable "admin_user" {
  type = string
}

variable "admin_pubkeys" {
  type = list(string)
}

variable "admin_password_hash" {
  type = string
}
