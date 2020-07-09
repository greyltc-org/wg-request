#!/usr/bin/env bash

if test $EUID -ne 0
then
  echo "Please run with root permissions"
  exit 1
fi

PEER=${1:-google.com}
PORT=${2:-51820}
IFACE=${3:-wg0}

pacman -S --needed --noconfirm python wireguard-tools curl >/dev/null 2>/dev/null
curl -fsSL -o /bin/wg-request https://raw.githubusercontent.com/greyltc/wg-request/master/wg-request >/dev/null 2>/dev/null
chmod +x /bin/wg-request >/dev/null 2>/dev/null

wg genkey | tee /tmp/peer_A.key | wg pubkey > /tmp/peer_A.pub
timeout 5 python3 /bin/wg-request --port "${PORT}" --private-key $(cat /tmp/peer_A.key) $(cat /tmp/peer_A.pub) "${PEER}" > "/etc/wireguard/${IFACE}.conf" 2>/dev/null
wg-quick down "${IFACE}" >/dev/null 2>/dev/null
wg-quick up "${IFACE}" >/dev/null 2>/dev/null
systemctl enable "wg-quick@${IFACE}" >/dev/null 2>/dev/null

rm /tmp/peer_A.key >/dev/null 2>/dev/null
rm /tmp/peer_A.pub >/dev/null 2>/dev/null
