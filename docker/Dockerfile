FROM alpine:latest

LABEL version="0.2"
LABEL name="terrakvm"

ARG TERRAFORM_VERSION=0.12.16
ARG PACKER_VERSION=1.4.5

ARG HOST_UID=1000
ARG HOST_GID=1000
ARG KMV_GID=992
ARG LIBVIRT_GID
ARG USER_NAME="pwn"

RUN apk update && \
    apk add bash zip unzip wget tzdata

SHELL ["/bin/bash", "-c"]

# Set the locale
ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8

RUN ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
RUN echo "Europe/London" > /etc/timezone
RUN date
RUN apk del tzdata

RUN mkdir /tmp/build

# Install terraform
RUN cd /tmp/build && \
    wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    cp terraform /sbin/terraform && \
    chmod 0755 /sbin/terraform && \
    rm -rf /tmp/build/*

# Install packer
RUN cd /tmp/build && \
    wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip && \
    mv packer /sbin/packer && \
    chmod 0755 /sbin/packer && \
    rm -rf /tmp/build/*


COPY apk_install.sh /tmp/apk_install.sh
COPY apk_requirements.txt /tmp/apk_requirements.txt

RUN chmod +x /tmp/apk_install.sh && \
    /tmp/apk_install.sh

RUN rm -rf /var/cache/apk/*

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

RUN addgroup -g ${HOST_GID} -S ${USER_NAME}
RUN adduser -u ${HOST_UID} -G ${USER_NAME} -G kvm -G libvirt -D ${USER_NAME}
COPY bashrc /home/${USER_NAME}/.bashrc

# Install libvirt provider
RUN cd /tmp/build && \
    wget -O terraform-provider-libvirt.tar.gz https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v0.6.0/terraform-provider-libvirt-0.6.0+git.1569597268.1c8597df.Ubuntu_18.04.amd64.tar.gz && \
    tar -zxvf terraform-provider-libvirt.tar.gz && \
    mkdir -p /home/$USER_NAME/.terraform.d/plugins && \
    mkdir -p /root/.terraform.d/plugins && \
    cp terraform-provider-libvirt /home/$USER_NAME/.terraform.d/plugins/ && \
    cp terraform-provider-libvirt /root/.terraform.d/plugins/ && \
    chown $USER_NAME:$USER_NAME -R /home/$USER_NAME/ &&  \
    chmod 0755 /home/$USER_NAME/.terraform.d/plugins/terraform-provider-libvirt && \
    rm -rf /tmp/build/*

RUN rm -rf /tmp/build

USER ${USER_NAME}

RUN git config --global credential.helper cache

VOLUME /TerraKVM
WORKDIR /TerraKVM/ansible

CMD ["/bin/bash"]
