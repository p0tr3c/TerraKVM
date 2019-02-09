#!/bin/sh

# Get docker versions
echo "Docker: `docker --version`"
echo "Docker-compose: `docker-compose --version`"

# Libvirt version
echo "Virsh: `virsh --version`"
echo "Libvirtd: `libvirtd --version`"

# Operating system
echo "OS: `uname -a`"

if [ -f '/etc/os-release' ]; then
  cat /etc/os-release
fi
