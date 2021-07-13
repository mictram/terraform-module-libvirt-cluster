resource "libvirt_pool" "default" {
  name = "${var.node_pool_vm_name}"
  type = "dir"
  path = "/tmp/terraform-libvirt_pool-${var.node_pool_vm_name}"
}

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  pool           = libvirt_pool.default.name

  user_data      = <<EOF
    #cloud-config
    disable_root: 0
    ssh_pwauth: 1
    users:
      - name: root
        ssh-authorized-keys:
        - ${file(var.ssh_pub_key_path)}
    growpart:
       mode: auto
       devices: ['/']
  EOF

  network_config  = <<EOF
    version: 2
    ethernets:
      ens3:
        dhcp4: true
  EOF
}

# We fetch the latest ubuntu release image from their mirrors
resource "libvirt_volume" "base" {
  name   = "terraform-libvirt_volume-${var.node_pool_vm_name}-base"
  pool   = libvirt_pool.default.name
  source = var.node_pool_vm_image_url 
  format = "qcow2"
}

resource "libvirt_volume" "resized" {
  count          = var.node_pool_size 
  name           = "terraform-libvirt_volume-${var.node_pool_vm_name}-${count.index}"
  base_volume_id = libvirt_volume.base.id
  pool           = libvirt_pool.default.name
  size           = var.node_pool_vm_volume_size
}
