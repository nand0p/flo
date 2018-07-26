# Barebones ECS reference architecture implementation for a single microservice container

- Parameterizes environments for ease of single command deployment.

- Deploys CFN for VPC, ECS Cluster, Frontend ELB, ECS Service, and Codepipeline CI/CD for ECS Service.

- CI/CD Structure:

1. Polls github repo with Dockerfile at root

2. Builds and tags container

3. Publishes container to ecr

4. Rolls out new container to ECS



- TODO: optional Clair container scanning pipeline stage
- TODO: `.flo.yml` expected in service repo root, and vars become available to CodeBuild Stages.
- TODO: orchestrate cfn runs with terraform, instead of awscli
