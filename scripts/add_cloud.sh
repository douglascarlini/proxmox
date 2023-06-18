#!/bin/bash

set -a && source .env && set +a
if [ -z "$IFACE_MAIN" ]; then echo "[ERROR] Missing config: IFACE_MAIN"; exit; fi

CPU=2
CID=123
TID=1000
MEM=2048
NAME=ubuntu01
PATH=/var/lib/vz/template/iso
IMG=bionic-server-cloudimg-amd64.img
URL=https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img

# Download image
wget -O $PATH/$IMG $URL

# Create Template
qm create $TID --memory $MEM --net0 virtio,bridge=$IFACE_NAME --scsihw virtio-scsi-pci
qm set $TID --scsi0 local-lvm:0,import-from=$PATH/$IMG
qm set $TID --ide2 local-lvm:cloudinit
qm set $TID --boot order=scsi0
qm set $TID --serial0 socket --vga serial0
qm template $TID

# Deploy Template
# qm clone $TID $CID --name $NAME
# qm set $CID --cores $CPU --memory $MEM