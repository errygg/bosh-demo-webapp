#!/usr/bin/env bash

export PATH=$PATH:/usr/local/bin

echo "Installing dependencies ..."
apt-get update
apt-get install -y unzip curl

echo "Installing Consul ${binary_filename} ..."
curl -s -O ${binary_url}/${binary_filename}

unzip ${binary_filename}
chown root:root consul
chmod 0755 consul
mv consul /usr/local/bin

consul -autocomplete-install
complete -C /usr/local/bin/consul consul

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
NETWORK_INTERFACE=$(ls -1 /sys/class/net | grep -v lo | sort -r | head -n 1)
IP_ADDRESS=$(ip address show $NETWORK_INTERFACE | awk '{print $2}' | egrep -o '([0-9]+\.){3}[0-9]+')
HOSTNAME=$(hostname -s)

cat > /etc/consul.d/consul.json << EOF
{
  "addresses": {
    "https": "$${IP_ADDRESS}"
  },
  "advertise_addr":   "${advertise_addr}",
  "bootstrap_expect": ${bootstrap_expect},
  "client_addr":      "$${IP_ADDRESS}",
  "datacenter":       "${datacenter}",
  "data_dir":         "${data_directory}",
  "enable_syslog":    true,
  "log_level":        "${log_level}",
  "node_name":        "$${HOSTNAME}",
  "server":           true,
  "ui":               true
}
EOF

chown root:consul /etc/consul.d/consul.json
chmod 0640 /etc/consul.d/consul.json

cat > /etc/systemd/system/consul.service << EOF
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/consul.json
[Service]
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/usr/local/bin/consul reload
KillMode=process
Restart=on-failure
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable consul
systemctl restart consul
