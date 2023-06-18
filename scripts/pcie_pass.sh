#!/bin/bash

set -a && source .env && set +a
if [ -z "$BRAND" ]; then echo "[ERROR] Missing config: BRAND (intel/amd)"; exit; fi

GRUB_FROM="quiet"
GRUB_TO="quiet ${BRAND}_iommu=on"
sed -i -e 's/$GRUB_FROM/$GRUB_TO/g' /etc/default/grub

update-grub

cat <<OEF >> /etc/modules

vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
OEF

# VGA_GROUP=$(lspci -v | grep -A 2 VGA | grep IOMMU | awk '{print $NF}')
# VGA_COUNT=$(($(find /sys/kernel/iommu_groups/ -type l | grep $VGA_GROUP | wc -l) / 2))
# if [ "$VGA_COUNT" != "1" ]; echo "options vfio_iommu_type1 allow_unsafe_interrupts=1" > /etc/modprobe.d/iommu_unsafe_interrupts.conf; fi
