# Default configuration

By default, the terrakvm will deploy the image with below config.

You can find it in [main.yml](./ansible/roles/ansible-role-terrakvm/defaults/main.yml)

```
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
