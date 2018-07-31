# ECS reference architecture implementation from https://github.com/awslabs/ecs-refarch-continuous-deployment


- Terraform for single command deployment `terraform apply`

- Parameterized ECS environment for single container

- Deploys CloudFormation for all AWS Resources:

1. VPC Dependencies
2. ECS Cluster
3. Frontend ELB
4. ECS Service with Application Auto-Scaling
5. CodePipeline CI/CD Pipeline.

- CI/CD Structure:

1. Polls github repo for Dockerfile at root
2. Builds and tags container
3. Publishes container to ECR
4. Rolls out new container to ECS



- TODO: `.flo.yml` vars become available to CodeBuild Stages.
- TODO: Clair container scanning pipeline stage
