#!/bin/bash

set -a && source .env && set +a

if [ -z "$IFACE_MAIN" ]; then echo "[ERROR] Missing config: IFACE_MAIN"; exit; fi
if [ -z "$IFACE_NAME" ]; then echo "[ERROR] Missing config: IFACE_NAME"; exit; fi
if [ -z "$NET_PREFIX" ]; then echo "[ERROR] Missing config: NET_PREFIX"; exit; fi

# Network

cat <<OEF >> /etc/network/interfaces

auto $IFACE_NAME
iface $IFACE_NAME inet static
    address $NET_PREFIX.254/24
    bridge-ports none
    bridge-stp off
    bridge-fd 0

    post-up echo 1 > /proc/sys/net/ipv4/ip_forward
    post-up iptables -t nat -A POSTROUTING -s '$NET_PREFIX.0/24' -o $IFACE_MAIN -j MASQUERADE
    post-down iptables -t nat -D POSTROUTING -s '$NET_PREFIX.0/24' -o $IFACE_MAIN -j MASQUERADE
OEF

ifdown $IFACE_NAME && ifup $IFACE_NAME

# DHCP Server

apt install -y isc-dhcp-server

cat <<OEF > /etc/default/isc-dhcp-server
INTERFACESv4="$IFACE_NAME"
INTERFACESv6=""
authorative;
OEF

cat <<OEF > /etc/dhcp/dhcpd.conf
subnet 0.0.0.0 netmask 0.0.0.0 {
    default-lease-time 21600000;
    max-lease-time 432000000;
    authoritative;
}
OEF

systemctl restart isc-dhcp-server
