FROM golang:alpine

# Update APK
RUN apk update && apk upgrade

# Install Dependencies
RUN apk add git make pkgconfig libvirt gcc libvirt-dev libc-dev

RUN go get github.com/dmacvicar/terraform-provider-libvirt

COPY compile-and-copy.sh ./compile-and-copy.sh
RUN chmod +x compile-and-copy.sh

VOLUME /output

CMD ["/bin/sh", "compile-and-copy.sh"]
