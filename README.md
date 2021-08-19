# libvirt-cluster (WIP)

## example usage
Create a file `main.tf`

```
module "libvirt-cluster" {
  source = "git::http://github.com:mictram/libvirt-cluster.git"
  node_pool_vm_image_url = "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
  node_pool_size = 2
  node_pool_vm_vcpu = 2
  node_pool_vm_memory = 4096 # 4GiB
  node_pool_vm_volume_size = 21474836480 # 20GiB
  node_pool_vm_name = "primary"
  libvirt_uri = "qemu:///system"
  ssh_pub_key_path = "~/.ssh/id_rsa.pub"
}
```

Run the following commands:
```bash
terraform init
terraform plan
terraform apply
```

## multiple clusters
To create multiple clusters, create multiple module blocks in `main.tf` like so:
```
module "libvirt-cluster_dev" {
  source = "git::http://github.com:mictram/libvirt-cluster.git"
  node_pool_vm_image_url = "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
  node_pool_size = 2
  node_pool_vm_vcpu = 2
  node_pool_vm_memory = 4096 # 4GiB
  node_pool_vm_volume_size = 21474836480 # 20GiB
  node_pool_vm_name = "dev"
  libvirt_uri = "qemu:///system"
  ssh_pub_key_path = "~/.ssh/id_rsa.pub"
  libvirt_pool_path = "/mnt/libvirt_pool/libvirt-cluster_dev"
}

module "libvirt-cluster_prod" {
  source = "git::http://github.com:mictram/libvirt-cluster.git"
  node_pool_vm_image_url = "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
  node_pool_size = 2
  node_pool_vm_vcpu = 2
  node_pool_vm_memory = 4096 # 4GiB
  node_pool_vm_volume_size = 21474836480 # 20GiB
  node_pool_vm_name = "prod"
  libvirt_uri = "qemu:///system"
  ssh_pub_key_path = "~/.ssh/id_rsa.pub"
  libvirt_pool_path = "/mnt/libvirt_pool/libvirt-cluster_prod"
}
```

## configurables
| parameter | description |
| --- | --- |
| `node_pool_vm_image_url` | url of base vm image |
| `node_pool_size` | number of vms in cluster |
| `node_pool_vm_vcpu` | number of vcpus in each vm in cluster |
| `node_pool_vm_memory` | memory of each vm in cluster in megabytes |
| `node_pool_vm_volume_size` | root disk size of each vm in bytes |
| `node_pool_vm_name` | name (namespace) of each vm in the cluster |
| `libvirt_uri` | uri of the libvirt daemon |
| `ssh_pub_key_path` | local path to ssh public key to add to ~/.ssh/authorized_keys in each vm |
| `libvirt_pool_path` | path on remote path to libvirt pool directory |
