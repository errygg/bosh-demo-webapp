#!/usr/bin/env bash

echo "Installing dependencies ..."
apt-get update
apt-get install -y unzip curl

echo "Installing Consul version ${consul_version} ..."
curl -s -O ${binary_uri}/${binary_filename} --output consul.zip

unzip consul.zip
chown root:root consul
chmod 0755 consul
mv consul /usr/local/bin

echo "Creating Consul service account ..."
useradd -r -d /etc/consul.d -s /bin/false consul

echo "Creating Consul directory structure ..."
mkdir /etc/consul{,.d}
chown root:consul /etc/consul{,.d}
chmod 0750 /etc/consul{,.d}

mkdir /var/lib/consul
chown consul:consul /var/lib/consul
chmod 0750 /var/lib/consul

echo "Creating Consul config ..."
HOSTNAME=$(hostname -s)
