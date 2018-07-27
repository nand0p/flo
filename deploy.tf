variable "vpc_stack_name" {}
variable "ecs_stack_name" {}
variable "lb_stack_name" {}
variable "pipeline_stack_name" {}
variable "service_stack_name" {}
variable "vpc_template" {}
variable "ecs_template" {}
variable "lb_template" {}
variable "pipeline_template" {}
variable "service_template" {}
variable "key_name" {}
variable "vpc_cidr" {}
variable "subnet_one_cidr" {}
variable "subnet_two_cidr" {}
variable "image_id" {}
variable "instance_type" {}
variable "cluster_size" {}
variable "service_name" {}
variable "service_tag" {}
variable "service_owner" {}
variable "service_repo" {}
variable "service_branch" {}
variable "service_count" {}
variable "service_memory" {}
variable "service_port" {}
variable "github_token" {}
variable "trusted_cidr" {}
variable "aws_region" {}
variable "aws_profile" {}


provider "aws" {
  region = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

resource "aws_cloudformation_stack" "flo-cluster-vpc" {
  name = "${var.vpc_stack_name}"
  template_body = "${file("${path.module}/${var.vpc_template}")}"
  parameters {
    VpcCIDR = "${var.vpc_cidr}"
    Subnet1CIDR = "${var.subnet_one_cidr}"
    Subnet2CIDR = "${var.subnet_two_cidr}"
  }
}

resource "aws_cloudformation_stack" "flo-cluster-ecs" {
  depends_on = [ "aws_cloudformation_stack.flo-cluster-vpc" ]
  name = "${var.ecs_stack_name}"
  template_body = "${file("${path.module}/${var.ecs_template}")}"
  capabilities = [ "CAPABILITY_IAM" ]
  parameters {
    ImageId = "${var.image_id}"
    InstanceType = "${var.instance_type}"
    ClusterSize = "${var.cluster_size}"
    KeyName = "${var.key_name}"
    TrustedCidr = "${var.trusted_cidr}"
  }
}

resource "aws_cloudformation_stack" "flo-cluster-lb" {
  depends_on = [ "aws_cloudformation_stack.flo-cluster-ecs" ]
  name = "${var.lb_stack_name}"
  template_body = "${file("${path.module}/${var.lb_template}")}"
  parameters {
    TrustedCidr = "${var.trusted_cidr}"
    ServicePort = "${var.service_port}"
  }
}

resource "aws_cloudformation_stack" "flo-cluster-service" {
  depends_on = [ "aws_cloudformation_stack.flo-cluster-lb" ]
  name = "${var.service_stack_name}"
  template_body = "${file("${path.module}/${var.service_template}")}"
  capabilities = [ "CAPABILITY_IAM" ]
  parameters {
    ServiceCount = "${var.service_count}"
    ServiceTag = "${var.service_tag}"
    ServiceName = "${var.service_name}"
    ServiceRepo = "${var.service_owner}"
    ServiceMemory = "${var.service_memory}"
    ServicePort = "${var.service_port}"
  }
}

resource "aws_cloudformation_stack" "flo-cluster-pipeline" {
  depends_on = [ "aws_cloudformation_stack.flo-cluster-service" ]
  name = "${var.pipeline_stack_name}"
  template_body = "${file("${path.module}/${var.pipeline_template}")}"
  capabilities = [ "CAPABILITY_IAM" ]
  parameters {
    ServiceCount = "${var.service_count}"
    ServiceName = "${var.service_name}"
    ServiceBranch = "${var.service_branch}"
    ServiceOwner = "${var.service_owner}"
    ServiceMemory = "${var.service_memory}"
    ServicePort = "${var.service_port}"
    ServiceRepo = "${var.service_repo}"
    ServiceToken = "${var.github_token}"
    ServiceStack = "${var.service_stack_name}"
  }
}
