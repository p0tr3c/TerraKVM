#!/bin/sh

LIBVIRT_GID=`getent group libvirt | awk -F: '{print $3}'`
KVM_GID=`getent group kvm | awk -F: '{print $3}'`

if [ "$1" == "build" ]; then
    sudo LIBVIRT_GID="$LIBVIRT_GID" KVM_GID="$KVM_GID" docker-compose build
elif [ "$1" == "destroy" ]; then
    sudo docker-compose run terrakvm ansible-playbook playbooks/destroy.yml "${@:2}"
else
    sudo LIBVIRT_GID="$LIBVIRT_GID" KVM_GID="$KVM_GID" docker-compose run terrakvm ansible-playbook playbooks/deploy.yml "$@"
fi
