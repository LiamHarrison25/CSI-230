#!/bin/bash

# The purpose of this program is to filter out the ip address from using ip addr

echo "Original command: "
echo ""

ip addr

echo ""
echo ""

ip=$(ip addr | awk '/inet / {print $2}' | egrep -v "127.0.0.1")

echo "IP: $ip"

