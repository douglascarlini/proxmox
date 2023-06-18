#!/bin/bash

CPU=2
CID=123
TID=1000
MEM=2048
NAME=ubuntu01

# Deploy Template
qm clone $TID $CID --name $NAME
qm set $CID --cores $CPU --memory $MEM