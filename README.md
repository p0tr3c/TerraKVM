# TerraKVM
Deploy VMs on [KVM](https://www.linux-kvm.org/page/Main_Page) via [docker](https://www.docker.com/)/[ansible](https://www.ansible.com/)/[terraform](https://www.terraform.io/)

** Under development **  
** Only tested on Arch Linux **  
** Permissions issues between distros are likely **  

# Quick start

1. Install libvirt [[1](https://wiki.archlinux.org/index.php/libvirt)],[[2](https://help.ubuntu.com/community/KVM/Installation)],[[3](https://www.linuxtechi.com/install-kvm-hypervisor-on-centos-7-and-rhel-7/)], [docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/) on the host
2. `cd TerraKVM`
3. Clone [TerraKVM](https://github.com/p0tr3c/TerraKVM)
4. Deploy VM by running `sudo bash terrakvm deploy`
5. SSH to VM by running `ssh -F dev.config dev`
6. To remove VM run `sudo bash terrakvm destroy`

# Demo

[Video](https://youtu.be/fOvAujaUREA) demonstration of the CentOS 7 x86_64 deployment

# Implemented distros

- CentOS 7 x86_64 (default)
- Ubuntu Bionic x86_64 (`-e 'distro=ubuntu'`)
- Ubuntu Bionic x86 (`-e 'distro=ubuntu' -e 'arch=x86'`)
- Debian 9.7.0  x86_64 (`-e 'distro=debian'`)

# Custom Images

By default qcow2 images are downloaded from official distribution sites.

Use `-e 'from_iso=true'` to build custom images via [packer](https://www.packer.io/)

You can modify various variables in [vars.yml](ansible/default/vars.yml) to specify keyboard layout, language etc.

More granular modification can be performed in [template.json.j2](ansible/templates/packer/template.json.j2).  
This is where you can add provisioners

# Requirements

- libvirt
- docker
- docker-compose
