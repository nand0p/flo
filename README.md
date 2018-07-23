# ECS reference architecture implementation


- Parameterizes environments for ease of deployment.

- Deploys CFN for VPC, ECS Cluster, Frontend ELB, ECS Service, and Codepipeline CI/CD for ECS Service.


- TODO: Clair inline container scanning
- TODO: move to python and pyyaml
- TODO: `flo.yaml` is expected in service repo root, and vars available to CodeBuild Stages.


- CI/CD Structure:

1. Polls github repo with Dockerfile at root

2. Builds and tags container

3. Publishes container to ecr

4. Rolls out new container to ECS
