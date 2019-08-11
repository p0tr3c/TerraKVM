# TerraKVM

![Build Status](https://codebuild.eu-west-1.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiNjl0NEJ3R2xUOGFna3dIaXVnWklxVSs4NXpNOWxlZnlGY2JGcjAvdGJLMXUra2s4eCtpNVB3dWFvcjZWSmJ1L3NQenU2TExtbDlQN2kvNVBvYXU0QWZvPSIsIml2UGFyYW1ldGVyU3BlYyI6InlVSGdzMEZEZC9OS0hUM2ciLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)

Deploy VMs on [KVM](https://www.linux-kvm.org/page/Main_Page) via [docker](https://www.docker.com/)/[ansible](https://www.ansible.com/)/[terraform](https://www.terraform.io/)

** Under development **  
** Only tested on Arch Linux **  
** Permissions issues between distros are likely **  

# Quick start

1. Install libvirt [[1](https://wiki.archlinux.org/index.php/libvirt)],[[2](https://help.ubuntu.com/community/KVM/Installation)],[[3](https://www.linuxtechi.com/install-kvm-hypervisor-on-centos-7-and-rhel-7/)], [docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/) on the host
2. `cd TerraKVM`
3. Clone [TerraKVM](https://github.com/p0tr3c/TerraKVM)
4. Deploy VM by running `sudo bash terrakvm apply`
5. SSH to VM by running `ssh -F dev.config dev`
6. To remove VM run `sudo bash terrakvm destroy`

# How does it work?

The project is a combination of ansible, terraform and jinja templates.

The `terrakvm` shell script is a wrapper around docker-compose which executes the ansible playbook in `ansible/playbooks/` via docker container defined in `docker/`.

Ansible playbook executes role `ansible/roles/ansible-role-terrakvm`.

From high level point of view the role will template `terraform` configuration files via jinja2 templates.

You can find the templates in `ansible/roles/ansible-role-terrakvm/templates/terraform`.

Jinja will utilize variables defined in `ansible/roles/ansible-role-terrakvm/defaults/main.yml`

You can overwrite these variables from the command line just like in normal ansible execution.

The templates will generate terraform configuration for libvirt deployment. At the backend the terraform will utilize `https://github.com/dmacvicar/terraform-provider-libvirt` plugin for libvirt to deploy the vms.

As terraform utilizes state files to maintain state of the infrastructure, the project will create a directory under `terraform/` for each deployment. Variable `project_name` defines the name of the new directory. 

To destroy the infrastructure run `terrakvm` with destroy flag.

# Demo

[Video](https://youtu.be/fOvAujaUREA) demonstration of the CentOS 7 x86_64 deployment
> Note: the video is outdated

# Requirements

- libvirt
- docker
- docker-compose
