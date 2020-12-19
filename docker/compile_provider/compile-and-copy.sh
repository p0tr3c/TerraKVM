#!/bin/sh

cd $GOPATH/src/github.com/dmacvicar/terraform-provider-libvirt/

export GO111MODULE=on
export GOFLAGS=-mod=vendor
make install

cp $GOPATH/bin/terraform-provider-libvirt /output/
