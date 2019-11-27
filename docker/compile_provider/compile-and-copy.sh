#!/bin/sh

cd src/github.com/dmacvicar/terraform-provider-libvirt/

make

make build

cp terraform-provider-libvirt /output/
