#!/bin/bash -ex

source vars.sh

if [ -z "${TRUSTED_CIDR}" -a -z "${GITHUB_TOKEN}" ]; then
  echo "export TRUSTED_CIDR and GITHUB_TOKEN"
  exit 1
fi


VPC_PARAMETERS="\
  VpcCIDR=${VPC_CIDR} \
  Subnet1CIDR=${SUBNET_ONE_CIDR} \
  Subnet2CIDR=${SUBNET_TWO_CIDR} \
"

ECS_PARAMETERS="\
  ImageId=${IMAGE_ID} \
  InstanceType=${INSTANCE_TYPE} \
  ClusterSize=${CLUSTER_SIZE} \
  KeyName=${KEY_NAME} \
  TrustedCidr=${TRUSTED_CIDR} \
"

LB_PARAMETERS="\
  TrustedCidr=${TRUSTED_CIDR} \
  ServicePort=${SERVICE_PORT} \
"

SERVICE_PARAMETERS="\
  ServiceCount=${SERVICE_COUNT} \
  ServiceTag=${SERVICE_TAG} \
  ServiceName=${SERVICE_NAME} \
  ServiceRepo=${SERVICE_REPO} \
  ServiceMemory=${SERVICE_MEMORY} \
  ServicePort=${SERVICE_PORT} \
"

PIPELINE_PARAMETERS="\
  ServiceCount=${SERVICE_COUNT} \
  ServiceTag=${SERVICE_TAG} \
  ServiceName=${SERVICE_NAME} \
  ServiceBranch=${SERVICE_BRANCH} \
  ServiceUser=${SERVICE_USER} \
  ServiceMemory=${SERVICE_MEMORY} \
  ServicePort=${SERVICE_PORT} \
  ServiceToken=${SERVICE_TOKEN} \
"


echo -e "\n\nDeploying ${VPC_STACK_NAME} Stack:\n\n"
aws cloudformation deploy \
  --stack-name ${VPC_STACK_NAME} \
  --profile ${AWS_PROFILE} \
  --region ${AWS_REGION} \
  --template-file ${VPC_TEMPLATE} \
  --no-fail-on-empty-changeset \
  --parameter-overrides ${VPC_PARAMETERS}

echo -e "\n\nDeploying ${ECS_STACK_NAME} Stack:\n\n"
aws cloudformation deploy \
  --stack-name ${ECS_STACK_NAME} \
  --profile ${AWS_PROFILE} \
  --region ${AWS_REGION} \
  --template-file ${ECS_TEMPLATE} \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides ${ECS_PARAMETERS}

echo -e "\n\nDeploying ${LB_STACK_NAME} Stack:\n\n"
aws cloudformation deploy \
  --stack-name ${LB_STACK_NAME} \
  --profile ${AWS_PROFILE} \
  --region ${AWS_REGION} \
  --template-file ${LB_TEMPLATE} \
  --no-fail-on-empty-changeset \
  --parameter-overrides ${LB_PARAMETERS}

echo -e "\n\nDeploying ${SERVICE_STACK_NAME} Stack:\n\n"
aws cloudformation deploy \
  --stack-name ${SERVICE_STACK_NAME} \
  --profile ${AWS_PROFILE} \
  --region ${AWS_REGION} \
  --template-file ${SERVICE_TEMPLATE} \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides ${SERVICE_PARAMETERS}

echo -e "\n\nDeploying ${PIPELINE_STACK_NAME} Stack:\n\n"
aws cloudformation deploy \
  --stack-name ${PIPELINE_STACK_NAME} \
  --profile ${AWS_PROFILE} \
  --region ${AWS_REGION} \
  --template-file ${PIPELINE_TEMPLATE} \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides ${PIPELINE_PARAMETERS}
