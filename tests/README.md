# Setup test environment

Most configuration options are in `inventory/group_vars/all.yml`

Create AWS S3 bucket

```
ansible-playbook playbooks/deploy_state_bucket.yaml -i inventory/
```

Create GCE Project

```
Follow instruction in GCE documentation and get Service Account json credential file
```

Create AWS GCE codebuild project

```
ansible-playbook playbooks/deploy_test_on_gce.yaml -i inventory/ -e 'gce_service_account_access_file_src=/path/to/local/json/file'
```


