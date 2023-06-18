# Proxmox Upgrades
Some Proxmox upgrade configuration scripts.


## About
This project was created for personal use, based on my needs, but feel free to use it as per your need.

**Features:**

- create an private network
- share internet from main interface to guests
- add guest VMs to private network, setting fixed IP
- install and configure an DHCP server for private network
- redirect host (main interface) port to guest port using iptables

**Next Features:**

- download, create and configure cloud-init templates
- access RESTful API to create, configure and deploy templates
- redirect/passthrough host PCI hardware to guest VMs (PCI Passthrough)

### Settings
Add your configurations on `.env` file:

```
NET_PREFIX=192.168.10
IFACE_MAIN=vmbr0
IFACE_NAME=vmbr1
```

### Scripts

- [x] `configure` creates the private network and install DHCP server
- [x] `add_guest` add guest VM to the private network and share internet
- [x] `port_forw` redirect host port from main interface to the guest VM port
- [ ] `pcie_pass` allow to redirect host PCI hardware to guest VMs (PCI Passthrough)
- [ ] `add_cloud` download cloud image, create new VM and configure as template with cloud-init
- [ ] `new_cloud` clone VM template, creating new VM based on cloud-init template created by `add_cloud`
- [ ] `api_start` start an custom HTTP RESTful API to configure and deploy new VMs, and manage the servers

### How to Use

```bash
# Permissions
chmod +x scripts/configure.sh
chmod +x scripts/add_guest.sh
chmod +x scripts/port_forw.sh

# Configure
./scripts/configure.sh

# Add Guest 1 To Network (192.168.10.1)
./scripts/add_guest.sh --name VM1 --mac 01:AB --guest 1

# Redirect Host Port to Network Guest 1
./scripts/port_forw.sh --hport 13389 --gport 3389 --guest 1
```