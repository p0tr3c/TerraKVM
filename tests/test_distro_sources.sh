#!/bin/bash
PROJECT_DIR=`readlink -f "$PWD/../"`
TEST_DIR=`readlink -f $PWD`

TEST_NAME="`basename $0`"
TEST_NAME="${TEST_NAME%.*}"

READ_AVAILABLE_DISTROS_PLAY="test_distro_sources.yml"

cd "${PROJECT_DIR}/ansible/" && \
    cat > "${READ_AVAILABLE_DISTROS_PLAY}" <<EOF
- hosts: localhost
  connection: local
  gather_facts: false
  vars_files:
    - roles/ansible-role-terrakvm/defaults/main.yml
  tasks:
    - name: Test URI
      uri:
        url: "{{ item.url }}"
        method: HEAD
      loop: "{{ cloud_images | flatten(levels=1) }}"
EOF

sudo docker-compose run terrakvm ansible-playbook "${READ_AVAILABLE_DISTROS_PLAY}"   > "${TEST_DIR}/${TEST_NAME}.log" 2>&1
if [ "$?" -eq "0" ]; then
    echo "PASS: ${TEST_NAME}:distros:available"
else
    echo "FAIL: ${TEST_NAME}:distros:available"
fi

cd "${PROJECT_DIR}/ansible/" && \
    rm -rf "${READ_AVAILABLE_DISTROS_PLAY}"
if [ "$?" -ne "0" ]; then
    echo "ERROR: Failed to delete ${READ_AVAILABLE_DISTROS_PLAY}"
    exit 1
fi


