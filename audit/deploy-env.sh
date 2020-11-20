#!/bin/bash

environment=$1
region=$2
bucket=$3
AWS_ES_VPC_ENDPOINT=$4

terraform init \
--backend-config="bucket=${bucket}" \
--backend-config="region=${region}"

terraform apply -auto-approve -parallelism=3 \
-var "region=${region}" \
-var "AWS_ES_VPC_ENDPOINT=${AWS_ES_VPC_ENDPOINT}" \
-var "env=${environment}"

exit