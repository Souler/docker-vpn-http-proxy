#!/bin/sh

if [[ -z "${OPEN_VPN_FILE}" ]]; then
  echo "missing OPEN_VPN_FILE variable"
  exit 1
fi

# create tun device (necessary for docker+ovpn to run in bridge mode)
if [ ! -c /dev/net/tun ]; then
  mkdir -p /dev/net
  mknod /dev/net/tun c 10 200
fi

## read the file from the env and write it to a file
echo $OPEN_VPN_FILE | base64 -d >> /app/openvpn/config.ovpn

openvpn --config /app/openvpn/config.ovpn & \
  caddy -conf /app/caddy/Caddyfile & \
  wait