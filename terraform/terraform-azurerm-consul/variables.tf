variable "advertise_addr" {
  description = "Address that other nodes in the cluster use to gossip"
  default     = "0.0.0.0"
}

variable "bind_addr" {
  default = "0.0.0.0"
}

variable "bootstrap_expect" {
  description = "Number of running Consul servers to expect"
  default     = 1
}

variable "client_addr" {
  description = "Address for the Consul server to bind to"
  default     = "127.0.0.1"
}

variable "client_node_name" {
  description = "Consul client node name"
  default     = "consul-client"
}

variable "config_destination_dir" {
  description = "Destination directory for the Consul server configuration file"
  default     = "/home/ubuntu"
}

variable "consul_binary_filename" {
  description = "Zip file name of the consul binary"
  default     = "consul-enterprise_1.4.2%2Bent_linux_amd64.zip"
}

variable "consul_binary_url" {
  description = "Location of `consul_binary_filename`"
  default     = "https://s3-us-west-2.amazonaws.com/hc-enterprise-binaries/consul/ent/1.4.2"
}

variable "consul_template_binary_filename" {
  description = "Zip file name of the consul-template binary"
  default     = "consul-template_0.20.0_linux_386.zip"
}

variable "consul_template_binary_url" {
  description = "Location of `consul_template_binary_filename`"
  default     = "https://releases.hashicorp.com/consul-template/0.20.0"
}

variable "datacenter" {
  description = "Datacenter that the Consul server is running in"
  default     = "dc2"
}

variable "data_directory" {
  description = "Directory to store the Consul data"
  default     = "/var/lib/consul"
}

variable "location" {
  description = "Location (Region) of Azure"
  default     = "westus"
}

variable "log_level" {
  description = "Logging level for the Consul server"
  default     = "DEBUG"
}

# Required
variable "namespace" {
  description = "Unique namespace for the resource group name"
}

variable "network_space" {
  description = "Virtual network address space"
  default     = "10.0.0.0/16"
}

variable "public_ip_name" {
  description = "Public IP address name"
  default     = "consul-public-ip"
}

variable "server_node_name" {
  description = "Consul server node name"
  default     = "consul-server"
}

variable "service_type" {
  default = "dashboard"
}

variable "ssh_key_file" {
  description = "SSH key file"
  default     = "~/.ssh/id_rsa.pub"
}

variable "subnet_name" {
  description = "Name of the subnet that resources will be placed in"
  default     = "consul-subnet"
}

variable "subnet" {
  description = "Subnet CIDR for PTFE"
  default     = "10.0.0.0/24"
}

variable "virtual_network_name" {
  description = "Name of the main Virtual Network to place all of the Azure resources"
  default     = "consul-virtual-network"
}
