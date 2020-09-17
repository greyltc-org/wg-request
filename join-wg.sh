#!/usr/bin/env bash

# this script depends on wireguard-tools, python3 and curl

if test $EUID -ne 0
then
  echo "Please run with root permissions"
  exit 1
fi

if test -z "${2}"
then
  if test -f /etc/wireguard/wg0.conf
  then
    echo "/etc/wireguard/wg0.conf already exists. You must specify an interface manually"
    exit 2
  fi
fi

PEER=${1:-google.com}
IFACE=${2:-wg0}

curl -fsSL -o /bin/wg-request https://raw.githubusercontent.com/greyltc/wg-request/master/wg-request >/dev/null 2>/dev/null
chmod +x /bin/wg-request >/dev/null 2>/dev/null

wg genkey | tee /tmp/peer_A.key | wg pubkey > /tmp/peer_A.pub
timeout 5 python3 /bin/wg-request --private-key $(cat /tmp/peer_A.key) $(cat /tmp/peer_A.pub) "${PEER}" > "/etc/wireguard/${IFACE}.conf" 2>/dev/null
if test "${?}" = "0"
then
  echo "New config written to /etc/wireguard/${IFACE}.conf"
  cat "/etc/wireguard/${IFACE}.conf"
else
  echo "New config NOT written to /etc/wireguard/${IFACE}.conf"
fi
wg-quick down "${IFACE}" >/dev/null 2>/dev/null
wg-quick up "${IFACE}" >/dev/null 2>/dev/null
systemctl enable "wg-quick@${IFACE}" >/dev/null 2>/dev/null

rm /tmp/peer_A.key >/dev/null 2>/dev/null
rm /tmp/peer_A.pub >/dev/null 2>/dev/null
