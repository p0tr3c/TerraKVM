#!/bin/bash
export TF_ENV_tf_state_bucket=`aws ssm get-parameters --name /terrakvm/tf_state_bucket --region "$SSM_REGION" | jq -r '.Parameters[0].Value'`
export TF_ENV_aws_region=`aws ssm get-parameters --name /terrakvm/aws_region --region "$SSM_REGION" | jq -r '.Parameters[0].Value'`
export TF_ENV_state_key=`aws ssm get-parameters --name /terrakvm/tf_state_key --region "$SSM_REGION" | jq -r '.Parameters[0].Value'`
export GOOGLE_CLOUD_KEYFILE_JSON=`aws ssm get-parameters --name /terrakvm/gcloud_access_file --region "$SSM_REGION" | jq -r '.Parameters[0].Value'`
export GOOGLE_PROJECT=`aws ssm get-parameters --name /terrakvm/gcloud_project --region "$SSM_REGION" | jq -r '.Parameters[0].Value'`
export GOOGLE_REGION=`aws ssm get-parameters --name /terrakvm/gcloud_region --region "$SSM_REGION" | jq -r '.Parameters[0].Value'`
export TF_VAR_gcloud_zone=`aws ssm get-parameters --name /terrakvm/gcloud_compute_zone --region "$SSM_REGION" | jq -r '.Parameters[0].Value'`

aws s3 cp "s3://${TF_ENV_tf_state_bucket}/${GOOGLE_CLOUD_KEYFILE_JSON}" ./
if [ "$?" -ne "0" ];then
    echo "Failed to fetch access key to gcloud!"
    exit 1
fi

