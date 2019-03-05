terraform {
  required_version = "~> 0.11"
}

provider "azurerm" {}

resource "azurerm_resource_group" "consul" {
  name     = "${var.namespace}-consul-server"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "consul" {
  name                = "${var.virtual_network_name}"
  address_space       = ["${var.network_space}"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.consul.name}"
}

resource "azurerm_subnet" "consul" {
  name                 = "${var.subnet_name}"
  virtual_network_name = "${azurerm_virtual_network.consul.name}"
  resource_group_name  = "${azurerm_resource_group.consul.name}"
  address_prefix       = "${var.subnet}"
}

resource "azurerm_public_ip" "consul_server" {
  name                = "${var.public_ip_name}-server"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.consul.name}"
  allocation_method   = "Static" # Case Sensitive
}

resource "azurerm_public_ip" "consul_client" {
  name                = "${var.public_ip_name}-client"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.consul.name}"
  allocation_method   = "Static" # Case Sensitive
}

resource "azurerm_network_security_group" "consul" {
  name                = "consul-network-security-group"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.consul.name}"
}

resource "azurerm_network_security_rule" "consul_ssh" {
  name                        = "consul-ssh-nsg-rule"
  resource_group_name         = "${azurerm_resource_group.consul.name}"
  network_security_group_name = "${azurerm_network_security_group.consul.name}"
  priority                    = 100
  direction                   = "inbound"
  access                      = "allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "http" {
  name                        = "consul-http-nsg-rule"
  network_security_group_name = "${azurerm_network_security_group.consul.name}"
  resource_group_name         = "${azurerm_resource_group.consul.name}"
  priority                    = 110
  direction                   = "inbound"
  access                      = "allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "https" {
  name                        = "consul-https-nsg-rule"
  network_security_group_name = "${azurerm_network_security_group.consul.name}"
  resource_group_name         = "${azurerm_resource_group.consul.name}"
  priority                    = 120
  direction                   = "inbound"
  access                      = "allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "server" {
  name                        = "consul-server-nsg-rule"
  network_security_group_name = "${azurerm_network_security_group.consul.name}"
  resource_group_name         = "${azurerm_resource_group.consul.name}"
  priority                    = 130
  direction                   = "inbound"
  access                      = "allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "8300"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "serf_lan" {
  name                        = "consul-serf-lan-nsg-rule"
  network_security_group_name = "${azurerm_network_security_group.consul.name}"
  resource_group_name         = "${azurerm_resource_group.consul.name}"
  priority                    = 140
  direction                   = "inbound"
  access                      = "allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "8301"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "serf_wan" {
  name                        = "consul-serf-wan-nsg-rule"
  network_security_group_name = "${azurerm_network_security_group.consul.name}"
  resource_group_name         = "${azurerm_resource_group.consul.name}"
  priority                    = 150
  direction                   = "inbound"
  access                      = "allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "8302"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "ui" {
  name                        = "consul-ui-nsg-rule"
  network_security_group_name = "${azurerm_network_security_group.consul.name}"
  resource_group_name         = "${azurerm_resource_group.consul.name}"
  priority                    = 160
  direction                   = "inbound"
  access                      = "allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "8500"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "ui-secure" {
  name                        = "consul-ui-secure-nsg-rule"
  network_security_group_name = "${azurerm_network_security_group.consul.name}"
  resource_group_name         = "${azurerm_resource_group.consul.name}"
  priority                    = 170
  direction                   = "inbound"
  access                      = "allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "8501"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "dns" {
  name                        = "consul-dns-nsg-rule"
  network_security_group_name = "${azurerm_network_security_group.consul.name}"
  resource_group_name         = "${azurerm_resource_group.consul.name}"
  priority                    = 180
  direction                   = "inbound"
  access                      = "allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "8600"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "service" {
  name                        = "service-nsg-rule"
  network_security_group_name = "${azurerm_network_security_group.consul.name}"
  resource_group_name         = "${azurerm_resource_group.consul.name}"
  priority                    = 190
  direction                   = "inbound"
  access                      = "allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_interface" "consul_server" {
  name                      = "consul-network-interface"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.consul.name}"
  network_security_group_id = "${azurerm_network_security_group.consul.id}"

  ip_configuration {
    name                          = "consul-server-public-ip-configuration"
    subnet_id                     = "${azurerm_subnet.consul.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.consul_server.id}"
  }
}

resource "azurerm_network_interface" "consul_client" {
  name                      = "consul-client-network-interface"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.consul.name}"
  network_security_group_id = "${azurerm_network_security_group.consul.id}"

  ip_configuration {
    name                          = "consul-client-public-ip-configuration"
    subnet_id                     = "${azurerm_subnet.consul.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.consul_client.id}"
  }
}

resource "azurerm_virtual_machine" "consul_server" {
  name                             = "consul-server-virtual-machine"
  location                         = "${var.location}"
  resource_group_name              = "${azurerm_resource_group.consul.name}"
  network_interface_ids            = ["${azurerm_network_interface.consul_server.id}"]
  vm_size                          = "standard_e4s_v3"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical" # Case Sensitive
    offer     = "UbuntuServer" # Case Sensitive
    sku       = "16.04-LTS" # Case Sensitive
    version   = "latest"
  }

  storage_os_disk {
    name              = "consul-server-disk-1"
    caching           = "ReadWrite" # Case Sensitive
    create_option     = "fromimage"
    managed_disk_type = "Standard_LRS" # Case Sensitive
    disk_size_gb      = 100
  }

  os_profile {
    computer_name  = "consul-server"
    admin_username = "ubuntu" # root is not allowed
    admin_password = "ubuntu"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/ubuntu/.ssh/authorized_keys"
      key_data = "${file(var.ssh_key_file)}"
    }
  }

  provisioner "file" {
    content     = "${data.template_file.server_config.rendered}"
    destination = "${var.config_destination_dir}/consul.json"
    connection {
      type        = "ssh"
      user        = "ubuntu"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y unzip",
      "mkdir -p ${var.data_directory}",
      "curl ${var.binary_uri}/${var.binary_filename} --output ${var.config_destination_dir}/consul.zip",
      "unzip ${var.config_destination_dir}/consul.zip -d ${var.config_destination_dir}",
      "nohup ${var.config_destination_dir}/consul agent -config-file=${var.config_destination_dir}/consul.json > ${var.config_destination_dir}/consul.log 2>&1 &",
      "sleep 1"
    ]
    
    connection {
      type        = "ssh"
      user        = "ubuntu"
    }
  }
}

resource "azurerm_virtual_machine" "consul_client" {
  name                             = "consul-client-virtual-machine"
  location                         = "${var.location}"
  resource_group_name              = "${azurerm_resource_group.consul.name}"
  network_interface_ids            = ["${azurerm_network_interface.consul_client.id}"]
  vm_size                          = "standard_e4s_v3"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical" # Case Sensitive
    offer     = "UbuntuServer" # Case Sensitive
    sku       = "16.04-LTS" # Case Sensitive
    version   = "latest"
  }

  storage_os_disk {
    name              = "consul-client-disk-1"
    caching           = "ReadWrite" # Case Sensitive
    create_option     = "fromimage"
    managed_disk_type = "Standard_LRS" # Case Sensitive
    disk_size_gb      = 100
  }

  os_profile {
    computer_name  = "consul-client"
    admin_username = "ubuntu" # root is not allowed
    admin_password = "ubuntu"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/ubuntu/.ssh/authorized_keys"
      key_data = "${file(var.ssh_key_file)}"
    }
  }

  provisioner "file" {
    content     = "${data.template_file.client_config.rendered}"
    destination = "${var.config_destination_dir}/consul.json"
    
    connection {
      type        = "ssh"
      user        = "ubuntu"
    }
  }

  # TODO - update go build to include assets using packr2
  provisioner "local-exec" {
    working_dir = "${path.module}/../../services/${var.service_type}"
    command     = "env GOOS=linux GOARCH=386 go build"
  }

  provisioner "file" {
    source      = "${path.module}/../../services/${var.service_type}/assets/"
    destination = "${var.config_destination_dir}"
    
    connection {
      type = "ssh"
      user = "ubuntu"
    }
  }

  provisioner "file" {
    source      = "${path.module}/../../services/${var.service_type}/${var.service_type}"
    destination = "${var.config_destination_dir}/${var.service_type}"
    
    connection {
      type = "ssh"
      user = "ubuntu"
    }
  }

  # export COUNTING_SERVICE_URL=`curl -s http://104.42.219.125:8500/v1/catalog/service/consul-counter?dc=dc1 |jq '.[0] | "http://" + .ServiceAddress + ":" + "\(.ServicePort)"'`
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y unzip jq",
      "mkdir -p ${var.data_directory}",
      "curl ${var.consul_template_binary_uri}/${var.consul_template_binary_filename} --output ${var.config_destination_dir}/consul-template.zip",
      "curl ${var.consul_binary_uri}/${var.consul_binary_filename} --output ${var.config_destination_dir}/consul.zip",
      "unzip ${var.config_destination_dir}/consul-template.zip -d ${var.config_destination_dir}",
      "unzip ${var.config_destination_dir}/consul.zip -d ${var.config_destination_dir}",
      "chmod 755 ${var.config_destination_dir}/${var.service_type}",
      "chmod 755 ${var.config_destination_dir}/consul-template",
      "chmod 755 ${var.config_destination_dir}/consul",
      "nohup ${var.config_destination_dir}/consul agent -config-file=${var.config_destination_dir}/consul.json > ${var.config_destination_dir}/consul.log 2>&1 &",
      "nohup ${var.config_destination_dir}/${var.service_type} > ${var.config_destination_dir}/${var.service_type}.log 2>&1 &",
      "sleep 1"
    ]
    
    connection {
      type        = "ssh"
      user        = "ubuntu"
    }
  }
}

data "template_file" "server_config" {
  template = "${file("${path.module}/templates/consul_server.json.tpl")}"
  vars = {
    advertise_addr   = "${azurerm_public_ip.consul_server.ip_address}"
    bootstrap_expect = "${var.bootstrap_expect}"
    client_addr      = "${var.client_addr}"
    datacenter       = "${var.datacenter}"
    data_directory   = "${var.data_directory}"
    log_level        = "${var.log_level}"
    node_name        = "${var.server_node_name}"
  }
}

data "template_file" "client_config" {
  template = "${file("${path.module}/templates/consul_client.json.tpl")}"
  vars     = {
    advertise_addr   = "${azurerm_public_ip.consul_client.ip_address}"
    bind_addr        = "${var.bind_addr}"
    datacenter       = "${var.datacenter}"
    data_directory   = "${var.data_directory}"
    log_level        = "${var.log_level}"
    node_name        = "${var.client_node_name}"
    server_addr_list = "${azurerm_network_interface.consul_server.private_ip_address}"
  }
}
