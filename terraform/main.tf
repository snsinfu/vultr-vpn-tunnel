resource "vultr_server" "tunnel" {
  label     = var.server_hostname
  hostname  = var.server_hostname
  region_id = var.server_region
  plan_id   = var.server_plan
  os_id     = var.server_os
  script_id = vultr_startup_script.tunnel.id
}

resource "vultr_startup_script" "tunnel" {
  name   = var.server_hostname
  script = data.template_file.startup_script.rendered
}

data "template_file" "startup_script" {
  template = file("${path.module}/startup.sh.tpl")
  vars = {
    admin_user            = var.admin_user
    admin_authorized_keys = join("\n", var.admin_pubkeys)
    admin_password_hash   = var.admin_password_hash
  }
}

data "template_file" "inventory" {
  template = file("${path.module}/inventory.tpl")
  vars = {
    tunnel_public_address = vultr_server.tunnel.main_ip
  }
}
