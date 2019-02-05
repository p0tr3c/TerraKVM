# TerraKVM
Deploy VMs on [KVM](https://www.linux-kvm.org/page/Main_Page) via [docker](https://www.docker.com/)/[ansible](https://www.ansible.com/)/[terraform](https://www.terraform.io/)

# Quick start

1. Install libvirt [1](https://wiki.archlinux.org/index.php/libvirt)[2](https://help.ubuntu.com/community/KVM/Installation)[3](https://www.linuxtechi.com/install-kvm-hypervisor-on-centos-7-and-rhel-7/), [docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/) on the host
2. `cd TerraKVM`
3. Clone [TerraKVM](https://github.com/p0tr3c/TerraKVM)
4. Deploy VM by running `sudo docker-compose run terrakvm ansible-playbook playbooks/deploy.yml`
5. SSH to VM by running `ssh -i dev.pkey dev@172.32.1.254`
6. To remove VM run `sudo docker-compose run terrakvm ansible-playbook playbooks/destroy.yml`

# Demo

[Video](https://youtu.be/fOvAujaUREA) demonstration of the CentOS 7 x86_64 deployment

# Implemented distros

- CentOS 7 x86_64 (default)
- Ubuntu Bionic x86_64 (`-e 'distro=ubuntu'`)
- Ubuntu Bionic x86 (`-e 'distro=ubuntu' -e 'arch=x86'`)
- Debian 9.7.0  x86_64 (`-e 'distro=debian'`)

# Requirements

- libvirt
- docker
- docker-compose
