terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
  access_key = var.access_key
  secret_key = var.secret_key
  project_id = "ccef7ee5-be9e-4b28-8ff3-09a419f937b7"
  zone = "fr-par-2"
}


data "scaleway_account_ssh_key" "main" {
  name = "main"
}

data "scaleway_baremetal_option" "private_network" {
  zone = "fr-par-2"
  name = "Private Network"
}

resource "scaleway_vpc_private_network" "pn" {
  zone = "fr-par-2"
  name = "baremetal_private_network"
}

resource "scaleway_baremetal_server" "k8s_master" {
  count = var.number_of_k8s_masters
  name = "${var.cluster_name}-k8s-master-${count.index + 1}"
  zone          = "fr-par-2"
  offer       = var.offer
  os          = var.os
  ssh_key_ids = [data.scaleway_account_ssh_key.main.id]
  tags = ["cluster-${var.cluster_name}", "k8s_cluster", "kube_control_plane", "etcd", "kube_node"]
  options {
    id = data.scaleway_baremetal_option.private_network.option_id
  }
  private_network {
    id = scaleway_vpc_private_network.pn.id
  }
}

resource "scaleway_baremetal_server" "k8s_master_no_etcd" {
  count = var.number_of_k8s_masters_no_etcd
  name = "${var.cluster_name}-k8s-master-${count.index + 1}"
  zone          = "fr-par-2"
  offer       = var.offer
  os          = var.os
  ssh_key_ids = [data.scaleway_account_ssh_key.main.id]
  tags = ["cluster-${var.cluster_name}", "k8s_cluster", "kube_control_plane", "kube_node"]
  options {
    id = data.scaleway_baremetal_option.private_network.option_id
  }
  private_network {
    id = scaleway_vpc_private_network.pn.id
  }
}

resource "scaleway_baremetal_server" "k8s_etcd" {
  count = var.number_of_etcd
  name = "${var.cluster_name}-etcd-${count.index + 1}"
  zone          = "fr-par-2"
  offer       = var.offer
  os          = var.os
  ssh_key_ids = [data.scaleway_account_ssh_key.main.id]
  tags = ["cluster-${var.cluster_name}", "etcd"]
  options {
    id = data.scaleway_baremetal_option.private_network.option_id
  }
  private_network {
    id = scaleway_vpc_private_network.pn.id
  }
}

resource "scaleway_baremetal_server" "k8s_node" {
  count = var.number_of_k8s_nodes
  name = "${var.cluster_name}-k8s-node-${count.index + 1}"
  zone          = "fr-par-2"
  offer       = var.offer
  os          = var.os
  ssh_key_ids = [data.scaleway_account_ssh_key.main.id]
  tags = ["cluster-${var.cluster_name}", "k8s_cluster", "kube_node"]
  options {
    id = data.scaleway_baremetal_option.private_network.option_id
  }
  private_network {
    id = scaleway_vpc_private_network.pn.id
  }
}

resource "scaleway_instance_ip" "k8s_master_ips" {
  count = var.number_of_k8s_masters + var.number_of_k8s_masters_no_etcd
}

resource "scaleway_instance_ip" "k8s_etcd_ips" {
  count = var.number_of_etcd
}

resource "scaleway_instance_ip" "k8s_node_ips" {
  count = var.number_of_k8s_nodes
}

# output "k8s_masters" {
#   value = [for instance in scaleway_baremetal_server.k8s_master : instance.private_ip]
# }

# output "k8s_masters_no_etcd" {
#   value = [for instance in scaleway_baremetal_server.k8s_master_no_etcd : instance.private_ip]
# }

# output "k8s_etcds" {
#   value = [for instance in scaleway_baremetal_server.k8s_etcd : instance.private_ip]
# }

# output "k8s_nodes" {
#   value = [for instance in scaleway_baremetal_server.k8s_node : instance.private_ip]
# }
