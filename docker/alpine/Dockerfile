FROM alpine:latest

LABEL version="0.2"

ARG TERRAFORM_VERSION=0.12.16
ARG PACKER_VERSION=1.4.5

ARG HOST_UID=1000
ARG HOST_GID=1000
ARG KVM_GID=121
ARG LIBVIRT_GID=129
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
RUN groupmod -g ${LIBVIRT_GID} libvirt
RUN groupmod -g ${KVM_GID} kvm
RUN adduser -u ${HOST_UID} -G ${USER_NAME} -G kvm -G libvirt -D ${USER_NAME}

# Install libvirt provider
RUN mkdir -p /home/$USER_NAME/.terraform.d/plugins && \
    mkdir -p /root/.terraform.d/plugins

COPY terraform-provider-libvirt /home/$USER_NAME/.terraform.d/plugins/
COPY terraform-provider-libvirt /root/.terraform.d/plugins/

RUN chown $USER_NAME:$USER_NAME -R /home/$USER_NAME/ &&  \
    chmod 0755 /home/$USER_NAME/.terraform.d/plugins/terraform-provider-libvirt

RUN rm -rf /tmp/build

USER ${USER_NAME}

RUN git config --global credential.helper cache

VOLUME /TerraKVM
WORKDIR /TerraKVM/ansible

CMD ["/bin/bash"]
