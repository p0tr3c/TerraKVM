FROM ubuntu:latest

LABEL version="0.1"
LABEL name="terrakvm"

# Set shell
SHELL ["/bin/bash", "-c"]

ARG USER_UID="1000"
ARG USER_GID="1000"
ARG USER_NAME="terrakvm"
ARG GROUP_NAME="terrakvm"

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
     -y && \
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

# Install libvirt provider
ENV LIBVIRT_TERRAFORM_VERSION 0.5.1
RUN wget https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v$LIBVIRT_TERRAFORM_VERSION/terraform-provider-libvirt-$LIBVIRT_TERRAFORM_VERSION.Ubuntu_18.04.amd64.tar.gz && \
    tar -zxvf terraform-provider-libvirt-$LIBVIRT_TERRAFORM_VERSION.Ubuntu_18.04.amd64.tar.gz && \
    mkdir -p /home/$USER_NAME/.terraform.d/plugins && \
    cp terraform-provider-libvirt /home/$USER_NAME/.terraform.d/plugins/ && \
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

# Run as $USER_NAME user
USER $USER_NAME

# Default ansible logs
RUN mkdir /home/$USER_NAME/.ansible

# Setup virtualenvs
RUN mkdir /home/$USER_NAME/.Envs
RUN echo "export WORKON_HOME=~/.Envs" >> /home/$USER_NAME/.bashrc
RUN echo "source /usr/local/bin/virtualenvwrapper.sh" >> /home/$USER_NAME/.bashrc

# Copy requirements
COPY requirements.txt requirements.txt

# Initialize env and install dependencies
ENV WORKON_HOME=/home/$USER_NAME/.Envs
RUN source /usr/local/bin/virtualenvwrapper.sh && \
    mkvirtualenv os-$USER_NAME && \
    workon os-$USER_NAME && \
    pip install -r requirements.txt

# Configure git caching
RUN git config --global credential.helper cache

# Mount local repo
VOLUME /data

WORKDIR /data

CMD ["/bin/bash"]
