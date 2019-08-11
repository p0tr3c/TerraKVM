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

## Project vs VM variables

Information in this doc will refere to `project` and `vm` variables.

Some variables are global to the `project`, for example `project_name` or `ssh_username`

These variables are defined outside of `vms` list.

`vm` variable refers to information specific to individual vms. For example `hostname` or `ncpu`

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

## Access Creds

Terrakvm uses `cloudinit` to preconfigure the VMs with access credentials

You can specify `username`, `password`, and `ssh key` to access the VMs

By default only `ssh key` access is configured. The terrakvm creates a key per project.

You can provide custom key via `ssh_public_key` project variable.

Sample project with custom username, enabled password and custom ssh key:

```
project_name: full_access
ssh_username: eve
ssh_public_key: c3NoLXJzYSBBQUFBQjNOemFDMXljMkVBQUFBREFRQUJBQUFCZ1FDM0ljaVg1L1VSYkN2UlhKUWQxZCtPeXRaV0FrUml4SDBFMFQ0bUpDeDVDMVJ1N0NVRGZDSmovSHV0TmttNm1xcmx1bHRpNjlqWkxGRHNBVFlYNjNtdUZQZnZMMzMrelpLZmtlTTR1dnMyM0NGY0RYUVdFMUx3cVRqc29VTitJNG0zaUtaem5Xa3lRZDVOVUdJZ29GK0dnZkswOFNzN0JvWXdlRFYwbWtmMDVranJ1bm1LakhvNS9PUGxoMW5yaDJiZDRXdWYyZDJwbEFnR0RtVEZRNXh0alZzMWI2dEZOU25Fd04rTGQrQ21GT2prSzBzNW5XaHN0cjZCVDVZMUNtdFpMMWFYWHRYVVd3dk1lWHU3clhGZk1udUdudjRUa3I1c3NEWGQzMlAyeHpLWXBVWGdxRlRYOHJLWEVsN3RWM0x6dDZWYlpEblZpT0JLa09nUFZTazltSnFvQWlJQTZhTS9qVTRjV09sOWM1Z1RlRGxldSsxbjVtRThvaWRvdTVIdU1yRENoSFIxSmdqZ1FUYWloV0hoK2EyNUljTEJza0ZVNVh5TjI5Nk5JUDZQQys2WDZSeFVocGFubmNXS2YyL1JyY1BNNEE3TjBtd2ZxSUtGMnFFa3RIZzl3ancxRVc3TklNZ1hXQWsvWm5hQ3ZpTWsvc3JaWXhuSVFyUzEyV2M9IHAwdHIzY0Bwd25ib3guYWR2ZXJzYXJpYWxlbmdpbmVlcmluZy5jb20=
vms:
  - hostname: terrakvm
    vm_name: terrakvm
    from_iso: false
    distro: fedora29
    arch: amd64
    ncpu: 2
    memory: 4096
    passwd: $6$Vfcr/tJ7hSufLBnI$jxhPbnsNT/QpDq.vp2tidL.vDz6PsKHedpxVaCzbbwMcqJO7FZvtU3PgdzD/mrSva.eoUV5K9ejVUh90LI8qZ.
    disks:
      - name: root
    networks:
      - network_name: default
        external: true
```

The `config` ssh file created by above project will be incorrect. It will point to incorrect private key.

You need to update it with the location of private key corresponding to prublic key in the project.

The password access will only be granted via local console, for example via `virt-viewer`. 

## Disk Size

By default the VM will be provisioned with the size of `qcow` image downloaded from the net

You can extend the size of the disk by specifing `size` variable in `vms` variable

Unfortunately the `size` variable has to be provided in `bytes`.

Sample project with growing disk:

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
        size: 21474836480
    networks:
      - network_name: default
        external: true
```

## Multiple Disks

You can have multiple disks in the VMs

Simply add entry in `disks` list variable

By default the additional disks will be based on the primary.

You can change the source of the disk via `source` variable

To get empty disk use `source: /dev/zero`

Sample VM with two disks:

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
      - name: data
        source: /dev/zero       
        size: 21474836480
    networks:
      - network_name: default
        external: true
```

## Serial Console

By default VMs will not output to serial console, which is useful for debugging

To enable serial console output add `enable_console: true` to `vms` variables

Sample VM with serial console enabled
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
    enable_console: true
    disks:
      - name: root
    networks:
      - network_name: default
        external: true
```

## Host file sharing

File sharing is implemented with 9p, and depends on the VMs compatibility

To enable file sharing add `filesystem` variable to `vms` spec, and sepcify source, target paths

You can then mount the share in the guest via `mount -t 9p -o trans=virtio,version=9p2000.L,rw <target> /mnt/tmp`

Sample vm with file sharing enabled:

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
    filesystem:
      source: /tmp
      target: tmp
      readonly: true
    disks:
      - name: root
    networks:
      - network_name: default
        external: true
```
