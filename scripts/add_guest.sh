#!/bin/bash

set -a && source .env && set +a

if [ -z "$IFACE_MAIN" ]; then echo "[ERROR] Missing config: IFACE_MAIN"; exit; fi
if [ -z "$IFACE_NAME" ]; then echo "[ERROR] Missing config: IFACE_NAME"; exit; fi
if [ -z "$NET_PREFIX" ]; then echo "[ERROR] Missing config: NET_PREFIX"; exit; fi

MAC=""
NAME=""
GUEST=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --guest)
            GUEST="$2"
            shift
            shift
            ;;
        --name)
            NAME="$2"
            shift
            shift
            ;;
        --mac)
            MAC="$2"
            shift
            shift
            ;;
            *)
            shift
            ;;
    esac
done

if [ -z "$GUEST" ]; then echo "[ERROR] Missing argument: --guest 1"; exit; fi
if [ -z "$NAME" ]; then echo "[ERROR] Missing argument: --name VM1"; exit; fi
if [ -z "$MAC" ]; then echo "[ERROR] Missing argument: --mac 00:00:00:00:00"; exit; fi

cat <<OEF >> /etc/dhcp/dhcpd.conf

host $NAME {
    hardware ethernet $MAC;
    option routers $NET_PREFIX.254;
    option subnet-mask 255.255.255.255;
    fixed-address $NET_PREFIX.$GUEST;
    option domain-name-servers 8.8.8.8,1.1.1.1;
}
OEF

systemctl restart isc-dhcp-server
