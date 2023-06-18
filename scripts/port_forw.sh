#!/bin/bash

# Load Config
set -a && source .env && set +a
if [ -z "$IFACE_MAIN" ]; then echo "[ERROR] Missing config: IFACE_MAIN"; exit; fi
if [ -z "$IFACE_NAME" ]; then echo "[ERROR] Missing config: IFACE_NAME"; exit; fi
if [ -z "$NET_PREFIX" ]; then echo "[ERROR] Missing config: NET_PREFIX"; exit; fi

GUEST=""
HPORT=""
GPORT=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --guest)
            GUEST="$2"
            shift
            shift
            ;;
        --hport)
            HPORT="$2"
            shift
            shift
            ;;
        --gport)
            GPORT="$2"
            shift
            shift
            ;;
            *)
            shift
            ;;
    esac
done

if [ -z "$GUEST" ]; then echo "[ERROR] Missing argument: --guest 1"; exit; fi
if [ -z "$HPORT" ]; then echo "[ERROR] Missing argument: --hport 3389"; exit; fi
if [ -z "$GPORT" ]; then echo "[ERROR] Missing argument: --gport 3389"; exit; fi

cat <<OEF >> /etc/network/interfaces

    post-up iptables -t nat -A PREROUTING -i $IFACE_MAIN -p tcp --dport $HPORT -j DNAT --to $NET_PREFIX.$GUEST:$GPORT
    post-down iptables -t nat -D PREROUTING -i $IFACE_MAIN -p tcp --dport $HPORT -j DNAT --to $NET_PREFIX.$GUEST:$GPORT
OEF

iptables -t nat -A PREROUTING -i $IFACE_MAIN -p tcp --dport $HPORT -j DNAT --to $NET_PREFIX.$GUEST:$GPORT