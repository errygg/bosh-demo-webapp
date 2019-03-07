# Consul on PCF Demo

This project includes all the necessary tooling in order to run a test of Consul
executing in and out of a Pivotal Cloud Foundry environment. It includes
Terraform code to spin up a Consul Server VM and Client VM that includes
a configuration to deploy either the dashboard or counter applications as well
as all the necessary networking components. Additionally, each service can be
pushed to PCF using `cf push` from the respective service directories.

This demo does assume that you have an existing PCF environment, the associated
credentials for that environment, as well as the `consul-buildpack` deployed
to that environment.

The only information necessary to run Terraform is the `peer_datacenter_address`
for the the peer datacenter to Network Area join.

## Demo 1: Dashboard in Azure, Counter in PCF

First demo includes a test of the dashboard application running _externally_
from PCF and the counter application running _inside_ of PCF.

### Setup

1. Setup the Azure infrastructure:

```bash
  > cd ./terraform
  > terraform apply
```

### Show

1. Deploy the counter app to PCF:

```bash
  > cd ./services/counter
  > cf push
```

1. Watch the PCF application logs:

```bash
  > cf logs counter
```

1. Open a browser and show the service running based on the `cf push` output URI

1. Open a new terminal and SSH to the dashboard and manually run
`consul-template`:

```bash
  > ssh ubuntu@<CONSUL_CLIENT_IP_ADDR>
  > consul-template -consul-addr=
  > ./dashboard.sh
```

1. 

## Demo 2: Dashboard in PCF, Counter in Azure

Second demo includes a test of the counter application running _externally_
from PCF and the dashboard application running _inside_ of PCF.

### Setup

1. Edit `terraform.tfvars` and uncomment `service_type=counter`. to change the
application in Azure to the counter app:

```bash
  > vi terraform.tfvars
```

1. Taint the existing VM:

```bash
  > terraform taint azurerm_virtual_machine.consul_client
```

1. Run terraform to rebuild the VM and provision the counter app:

```bash
  > terraform apply
```

### Show

1. Deploy the dashboard app to PCF:

```bash
  > cd ./services/dashboard
  > cf push
```
