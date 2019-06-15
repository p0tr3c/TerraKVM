#!/bin/bash
PROJECT_DIR=`realpath "$PWD/../"`
TEST_DIR=`realpath $PWD`

TEST_NAME="`basename $0`"
TEST_NAME="${TEST_NAME%.*}"

READ_AVAILABLE_DISTROS_PLAY="test_distro_sources_signatures.yml"
DOWNLOAD_DELETE_DISTRO_PLAY="test_distro_sources_signatrues_loop.yml"

cd "${PROJECT_DIR}/ansible/" && \
    cat > "${DOWNLOAD_DELETE_DISTRO_PLAY}" <<EOF
- name: Download Image
  get_url:
    url: "{{ item.url }}"
    dest: "{{ temp_dir.path }}/{{ item.iso_name }}"
    checksum: "{{ item.checksum }}"
- name: Delete Image
  file:
    path: "{{ temp_dir.path }}/{{ item.iso_name }}"
    state: absent
EOF

cd "${PROJECT_DIR}/ansible/" && \
    cat > "${READ_AVAILABLE_DISTROS_PLAY}" <<EOF
- hosts: localhost
  connection: local
  gather_facts: false
  vars_files:
    - roles/ansible-role-terrakvm/defaults/main.yml
  tasks:
    - name: Create tmp dir
      tempfile:
        state: directory
      register: temp_dir
    - name: Loop over images
      include_tasks: "${DOWNLOAD_DELETE_DISTRO_PLAY}"
      loop: "{{ cloud_images | flatten(levels=1) }}"
    - name: Delete temp dir
      file:
        path: "{{ temp_dir.path }}"
        state: absent
EOF

sudo docker-compose run terrakvm ansible-playbook "${READ_AVAILABLE_DISTROS_PLAY}"   > "${TEST_DIR}/${TEST_NAME}.log" 2>&1
if [ "$?" -eq "0" ]; then
    echo "PASS: ${TEST_NAME}:distros:available"
else
    echo "FAIL: ${TEST_NAME}:distros:available"
fi

cd "${PROJECT_DIR}/ansible/" && \
    rm -rf "${READ_AVAILABLE_DISTROS_PLAY}" && \
    rm -rf "${DOWNLOAD_DELETE_DISTRO_PLAY}"

if [ "$?" -ne "0" ]; then
    echo "ERROR: Failed to delete test playbooks"
    exit 1
fi

