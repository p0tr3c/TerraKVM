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

If you only use default config, you will be overwritting the VM each time you run `terrakvm apply`

