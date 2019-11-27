FROM ubuntu:latest

LABEL version="0.2"
LABEL name="terrakvm"

# Set she
SHELL ["/bin/bash", "-c"]


ARG TERRAFORM_VERSION="0.12.16"
ARG PACKER_VERSION="1.4.5"
ARG TERRAFORM_PROVIDER_URL="https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v0.6.0/terraform-provider-libvirt-0.6.0+git.1569597268.1c8597df.Ubuntu_18.04.amd64.tar.gz"

ARG HOST_UID="1000"
ARG HOST_GID="1000"
ARG USER_NAME="pwn"
ARG GROUP_NAME="pwn"
ARG LIBVIRT_GID
ARG KVM_GID
ARG WHEEL_GID

# Update image
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q && \
    apt-get install \
    wget \
    unzip \
    git \
    python-pip \
    vim \
    sudo \
    python-mysqldb \
    jq \
    libvirt-clients \
    openvpn \
    curl \
    python-netaddr \
    apt-transport-https \
    gnupg2 \
    sshpass \
    tmux \
    netcat \
    iputils-ping \
    iproute2 \
    ssh \
    ipmitool \
    dnsutils \
    qemu \
    qemu-kvm \
    libguestfs-tools \
    xsltproc \
    pkg-config \
    libvirt-dev \
     -y && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*

# Add guestfs to the image
RUN apt-get update -q && \
    apt-get install \
    libguestfs-tools \
    -y --no-install-recommends && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*

# Make temp working directory
RUN mkdir -p /tmp/build
WORKDIR /tmp/build

# Install terraform
RUN wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    cp terraform /usr/local/sbin/terraform && \
    chmod 0755 /usr/local/sbin/terraform && \
    rm -rf /tmp/build/*


# Download and install packer
RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip "packer_${PACKER_VERSION}_linux_amd64.zip" && \
    cp packer /usr/local/sbin/packer  && \
    chmod 0755 /usr/local/sbin/packer && \
    rm -rf /tmp/build/*

# Create default Ansible config
RUN mkdir -p /etc/ansible
COPY ansible.cfg /etc/ansible/ansible.cfg

# Create non-root user
RUN groupadd -r -g ${HOST_GID} ${GROUP_NAME} &&  \
    useradd -r -m -u ${HOST_UID} -g ${GROUP_NAME} -G sudo -s /bin/bash ${USER_NAME}

# Requried for ubuntu distro
# Add libvirt groups
RUN if [ ! -z "$LIBVIRT_GID" ] ; then \
        groupadd -r -g ${LIBVIRT_GID} libvirt; \
        usermod -a -G libvirt "$USER_NAME"; \
    fi
RUN if [ ! -z "$KVM_GID" ]; then\
        groupmod -g ${KVM_GID} kvm; \
        usermod -a -G kvm "$USER_NAME"; \
    fi


# Install libvirt provider
RUN cd /tmp/build && \
    wget -O terraform-provider-libvirt.tar.gz ${TERRAFORM_PROVIDER_URL} && \
    tar -zxvf terraform-provider-libvirt.tar.gz && \
    mkdir -p /home/$USER_NAME/.terraform.d/plugins && \
    mkdir -p /root/.terraform.d/plugins && \
    cp terraform-provider-libvirt /home/$USER_NAME/.terraform.d/plugins/ && \
    cp terraform-provider-libvirt /root/.terraform.d/plugins/ && \
    chown $USER_NAME:$USER_NAME -R /home/$USER_NAME/ &&  \
    chmod 0755 /home/$USER_NAME/.terraform.d/plugins/terraform-provider-libvirt && \
    rm -rf /tmp/build/*

# Give user admin rights
RUN echo "%$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Remove downloads
RUN rm -rf /tmp/build

# Set working dir
WORKDIR /home/$USER_NAME/

# Copy wait-for-it.sh
COPY wait-for-it.sh /usr/local/sbin/wait-for-it.sh

# Copy requirements
COPY requirements.txt requirements.txt

# Initialize env and install dependencies
RUN pip install -r requirements.txt

# Run as $USER_NAME user
USER $USER_NAME

# Default ansible logs
RUN mkdir /home/$USER_NAME/.ansible

# Configure git caching
RUN git config --global credential.helper cache

# Mount local repo
VOLUME /TerraKVM

WORKDIR /TerraKVM/ansible

CMD ["/bin/bash"]
