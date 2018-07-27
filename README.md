# Barebones ECS reference architecture implementation for a single microservice container

- Terraform for single command deployment `terraform apply`

- Parameterized ECS environment for single container

- Deploys CFN for VPC, ECS Cluster, Frontend ELB, ECS Service, and Codepipeline CI/CD for ECS Service.

- CI/CD Structure:

1. Polls github repo with Dockerfile at root
2. Builds and tags container
3. Publishes container to ecr
4. Rolls out new container to ECS



- TODO: `.flo.yml` vars become available to CodeBuild Stages.
- TODO: optional Clair container scanning pipeline stage
- TODO: add application auto scaling for service
