vpc_stack_name = "flo-cluster-vpc"
ecs_stack_name = "flo-cluster-ecs"
lb_stack_name = "flo-cluster-lb"
pipeline_stack_name = "flo-cluster-pipeline"
service_stack_name = "flo-cluster-service"
vpc_template = "templates/vpc.yml"
ecs_template = "templates/ecs.yml"
lb_template = "templates/lb.yml"
pipeline_template = "templates/pipeline.yml"
service_template = "templates/service.yml"
key_name = "flo"
vpc_cidr = "10.10.20.0/24"
subnet_one_cidr = "10.10.20.0/26"
subnet_two_cidr = "10.10.20.64/26"
image_id = "ami-fbc1c684"
instance_type = "t2.nano"
cluster_size = "3"
service_name = "hello-world"
service_tag = "1.5"
service_owner = "nand0p"
service_repo = "flo"
service_branch = "master"
service_count = "2"
service_memory = "16"
service_port = "80"
aws_region = "us-east-1"
aws_profile = "default"
