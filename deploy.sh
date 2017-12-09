#!/bin/bash -ex

STACK_NAME=flo-cluster
VPC_STACK_NAME=${STACK_NAME}-vpc
ECS_STACK_NAME=${STACK_NAME}-ecs
LB_STACK_NAME=${STACK_NAME}-lb
PIPELINE_STACK_NAME=${STACK_NAME}-pipeline
SERVICE_STACK_NAME=${STACK_NAME}-service
VPC_TEMPLATE=templates/vpc.yaml
ECS_TEMPLATE=templates/ecs-cluster.yaml
LB_TEMPLATE=templates/load-balancer.yaml
PIPELINE_TEMPLATE=templates/deployment-pipeline.yaml
SERVICE_TEMPLATE=templates/service.yaml
AWS_PROFILE=default
AWS_REGION=us-east-1
KEY_NAME=flo
VPC_CIDR=10.10.20.0/24
SUBNET_ONE_CIDR=10.10.20.0/26
SUBNET_TWO_CIDR=10.10.20.64/26
IMAGE_ID=ami-5253c32d  # latest ecs-optimized amzn linux
INSTANCE_TYPE=m3.medium
CLUSTER_SIZE=3
SERVICE_NAME=hello-world
SERVICE_TAG=1.5
SERVICE_REPO=nand0p
SERVICE_COUNT=6
SERVICE_MEMORY=16
SERVICE_PORT=80
GITHUB_USER=nand0p
GITHUB_BRANCH=master
GITHUB_REPO=flo


if [ -z "${TRUSTED_CIDR}" ]; then
  echo "export TRUSTED_CIDR"
  exit 1
fi

if [ -z "${GITHUB_TOKEN}" ]; then
  echo "export GITHUB_TOKEN"
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
  DesiredCount=${SERVICE_COUNT} \
  ServiceTag=${SERVICE_TAG} \
  ServiceName=${SERVICE_NAME} \
  ServiceRepo=${SERVICE_REPO} \
  ServiceMemory=${SERVICE_MEMORY} \
  ServicePort=${SERVICE_PORT} \
"

PIPELINE_PARAMETERS="\
  DesiredCount=${SERVICE_COUNT} \
  ServiceTag=${SERVICE_TAG} \
  ServiceName=${SERVICE_NAME} \
  ServiceRepo=${SERVICE_REPO} \
  ServiceMemory=${SERVICE_MEMORY} \
  ServicePort=${SERVICE_PORT} \
  GitHubUser=${GITHUB_USER} \
  GitHubBranch=${GITHUB_BRANCH} \
  GitHubRepo=${GITHUB_REPO} \
  GitHubToken=${GITHUB_TOKEN} \
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
