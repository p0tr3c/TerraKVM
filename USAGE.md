# Default configuration

By default, the terrakvm will deploy the image with below config.

You can find it in [main.yml](./ansible/roles/ansible-role-terrakvm/defaults/main.yml)

```
distro: centos
arch: amd64
project_name: dev
vm_name: "{{ project_name }}"
hostname: "{{ vm_name }}"
ncpu: 4
memory: 2048
...
# VM configuration
vms:
  - hostname: "{{ hostname }}"
    vm_name: "{{ vm_name }}"
    from_iso: "{{ from_iso }}"
    distro: "{{ distro }}"
    arch: "{{ arch }}"
    ncpu: "{{ ncpu }}"
    memory: "{{ memory }}"
    disks:
      - name: root
    networks:
      - network_name: default
        external: true
```

This will create a single Centos 7 VM, with 4 virtual cpus, 2GB of memory.

`project_name` variable will create a directory under `./terraform/<project_name>`
and store the `terraform.tfstate` files for the project.

If you only use default config, you will be overwriting the VM each time you run `terrakvm apply`

# Custom Projects

The `terrakvm` wrapper can take a project file via `-p` flag.

Sample project file:
```
project_name: terrakvm
vms:
  - hostname: terrakvm
    vm_name: terrakvm
    from_iso: false
    distro: fedora29
    arch: amd64
    ncpu: 2
    memory: 4096
    disks:
      - name: root
    networks:
      - network_name: default
        external: true
```

The project spec file is simple ansible vars file. 

It will be used by `terrakvm` to overwrite  the default config. 

This way you can have multiple concurrent deployments. 

The VM names must be unique `per libvirt` endpoint.

> Note: It is fairly easy to create unique names per project if required.

The project spec file will be mounted by docker based on the absolute paths.

This allows the project files to be located anywhere on the host filesystem.

# Features

## Multiple VMs

You can deploy multiple vms in single project.

`vms` variable is a list of vm spec. 

Simply add another item in the list to deploy multiple vms.

```
vms:
  - hostname: vm_1
    vm_name: vm_1
    from_iso: false
    distro: fedora29
    arch: amd64
    ncpu: 2
    memory: 4096
    disks:
      - name: root
    networks:
      - network_name: default
        external: true
  - hostname: vm_2
    vm_name: vm_2
    from_iso: false
    distro: fedora29
    arch: amd64
    ncpu: 2
    memory: 4096
    disks:
      - name: root
    networks:
      - network_name: default
        external: true
```

