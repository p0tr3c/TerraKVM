FROM ubuntu:latest

LABEL version="0.1"
LABEL name="terrakvm"

# Set shell
SHELL ["/bin/bash", "-c"]

ARG USER_UID="1000"
ARG USER_GID="1000"
ARG USER_NAME="terrakvm"
ARG GROUP_NAME="terrakvm"
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
ENV TERRAFORM_VERSION 0.11.11
RUN wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    cp terraform /usr/local/sbin/terraform && \
    chmod 0755 /usr/local/sbin/terraform && \
    rm -rf /tmp/build/*



# Download and install vault
ENV VAULT_VERSION 1.0.2
RUN wget "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" && \
    unzip "vault_${VAULT_VERSION}_linux_amd64.zip" && \
    cp vault /usr/local/sbin/vault && \
    chmod 0755 /usr/local/sbin/vault && \
    rm -rf /tmp/build/*

# Download and install terragrunt
ENV TERRAGRUNT_RELEASE v0.17.4
RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/$TERRAGRUNT_RELEASE/terragrunt_linux_amd64 && \
    cp terragrunt_linux_amd64 /usr/local/sbin/terragrunt && \
    chmod 0755 /usr/local/sbin/terragrunt && \
    rm -rf /tmp/build/*

# Download and install packer
ENV PACKER_VERSION 1.3.3
RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip "packer_${PACKER_VERSION}_linux_amd64.zip" && \
    cp packer /usr/local/sbin/packer  && \
    chmod 0755 /usr/local/sbin/packer && \
    rm -rf /tmp/build/*

# Create default Ansible config
RUN mkdir -p /etc/ansible
COPY ansible.cfg /etc/ansible/ansible.cfg

# Create non-root user
RUN groupadd -r -g ${USER_GID} ${GROUP_NAME} &&  \
    useradd -r -m -u ${USER_UID} -g ${GROUP_NAME} -G sudo -s /bin/bash ${USER_NAME}

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
ENV LIBVIRT_TERRAFORM_VERSION 0.5.1
RUN wget https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v$LIBVIRT_TERRAFORM_VERSION/terraform-provider-libvirt-$LIBVIRT_TERRAFORM_VERSION.Ubuntu_18.04.amd64.tar.gz && \
    tar -zxvf terraform-provider-libvirt-$LIBVIRT_TERRAFORM_VERSION.Ubuntu_18.04.amd64.tar.gz && \
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

# Install virtualenv
RUN pip install virtualenv
RUN pip install virtualenvwrapper

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
