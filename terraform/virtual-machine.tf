resource "mgc_ssh_keys" "this" {
  provider = mgc.sudeste
  name     = "mgc_vm_ssh_key"
  key      = file("../mgc_ssh_key.pub")
}

resource "mgc_virtual_machine_instances" "this" {
  depends_on = [mgc_ssh_keys.this, mgc_network_security_groups.this]
  name       = "mgc-vm-instance"

  machine_type = {
    name = var.machine_type
  }

  image = {
    name = var.image
  }

  network = {
    associate_public_ip = true
    delete_public_ip    = true

    interface = {
      security_groups = [{
        id = mgc_network_security_groups.this.id
      }]
    }
  }

  ssh_key_name = mgc_ssh_keys.this.name
}
