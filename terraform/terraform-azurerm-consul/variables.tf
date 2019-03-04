variable "advertise_addr" {
  description = "Address that other nodes in the cluster use to gossip"
  default     = "0.0.0.0"
}

variable "binary_filename" {

}

variable "binary_uri" {

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

variable "config_destination_dir" {
  description = "Destination directory for the Consul server configuration file"
  default     = "/home/ubuntu"
}

variable "datacenter" {
  description = "Datacenter that the Consul server is running in"
  default     = "dc1"
}

variable "data_directory" {
  description = "Directory to store the Consul data"
  default     = "/home/ubuntu/consul_data"
}

variable "location" {
  description = "Location (Region) of Azure"
  default     = "westus"
}

variable "log_level" {
  description = "Logging level for the Consul server"
  default     = "INFO"
}

# Required
variable "namespace" {
  description = "Unique namespace for the resource group name"
}

variable "network_space" {
  description = "Virtual network address space"
  default     = "10.0.0.0/16"
}

variable "client_node_name" {
  description = "Consul client node name"
  default     = "consul-client"
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

# Required
variable "ssh_key_file" {
  description = "SSH key file"
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
