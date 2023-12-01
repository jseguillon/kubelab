variable "cluster_name" {
  default = "kubespray"
}

variable "operating_system" {
  default = "ubuntu_22_04"
}

variable "public_key_path" {
  description = "The path of the ssh pub key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "plan_k8s_masters" {
  default = "c3.small.x86"
}

variable "plan_k8s_masters_no_etcd" {
  default = "c3.small.x86"
}

variable "plan_etcd" {
  default = "c3.small.x86"
}

variable "plan_k8s_nodes" {
  default = "c3.medium.x86"
}

variable "number_of_k8s_masters" {
  default = 1
}

variable "number_of_k8s_masters_no_etcd" {
  default = 0
}

variable "number_of_etcd" {
  default = 0
}

variable "number_of_k8s_nodes" {
  default = 1
}


variable "access_key" { 

}
variable "secret_key" { 

}

variable "offer" {
  default="EM-L101X-SATA"
} 
variable "os" {
  default="83640d93-a0b8-45ad-9c9f-30cae48380a4"
} 