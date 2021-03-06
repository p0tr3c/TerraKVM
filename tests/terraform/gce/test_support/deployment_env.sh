#!/bin/bash
export TF_ENV_tf_state_bucket=`aws ssm get-parameters --name /terrakvm/tf_state_bucket --region "$SSM_REGION" | jq -r '.Parameters[0].Value'`
export TF_ENV_aws_region=`aws ssm get-parameters --name /terrakvm/aws_region --region "$SSM_REGION" | jq -r '.Parameters[0].Value'`
export TF_ENV_state_key=`aws ssm get-parameters --name /terrakvm/gce_state_file_key --region "$SSM_REGION" | jq -r '.Parameters[0].Value'`
export GCLOUD_KEYFILE_JSON=`aws ssm get-parameters --name /terrakvm/gce_service_account_access_file --region "$SSM_REGION" | jq -r '.Parameters[0].Value'`
export GOOGLE_PROJECT=`aws ssm get-parameters --name /terrakvm/gce_project --region "$SSM_REGION" | jq -r '.Parameters[0].Value'`
export GOOGLE_REGION=`aws ssm get-parameters --name /terrakvm/gce_region --region "$SSM_REGION" | jq -r '.Parameters[0].Value'`
export TF_VAR_gcloud_zone=`aws ssm get-parameters --name /terrakvm/gce_compute_zone --region "$SSM_REGION" | jq -r '.Parameters[0].Value'`

aws s3 cp "s3://${TF_ENV_tf_state_bucket}/${GCLOUD_KEYFILE_JSON}" ./
if [ "$?" -ne "0" ];then
    echo "Failed to fetch access key to gcloud!"
    exit 1
fi
export GCP_SERVICE_ACCOUNT_FILE="`pwd`/$GCLOUD_KEYFILE_JSON"
