## dotnetasp-sigterm-demo
Demonstrated how to handle the SIGTERM(kill -15) signal for graceful shutdown in .NET APS 6.

## Prerequisites
1. Install and configure AWS CLI Version 2 environment:<br />
   [Install AWS CLI] - Installing or updating the latest version of the AWS CLI v2.<br />
   [Config AWS CLI] - Configure basic settings that AWS CLI uses to interact with AWS.<br />
   NOTE: Make sure your IAM User/Role has sufficient permissions.
2. Install .NET 6:<br />
   Run [dotnet6-install/aws-amzl2-install.sh](dotnet6-install/aws-amzl2-install.sh) to install .NET6 SDK and runtime.
3. Install Docker:<br />
   [Install Docker] - The installation section shows you how to install Docker on a variety of platforms.
4. Install Docker buildx:<br />
   [Install Docker buildx] - buildx is a Docker CLI plugin for extended build capabilities with BuildKit.

## Deployment & Testing
1. Run the following command to build and push docker image to your repository:<br />
     ```sh
     build-n-push-image.sh
     ```
   Or you can use the [pre-built multi-arch image](https://hub.docker.com/repository/docker/cowcoa/dotnetasp-sigterm-demo).
2. Run the following command to deploy the pre-built multi-arch image to your K8s cluster:<br />
     ```sh
     kubectl apply -f kube-manifest.yml
     ```

## Testing
1. The kube-manifest.yml will create a Deployment with 2 Pods, you can change the spec.replicas from 2 to 1 and re-deploy the manifest.
2. K8s will choose 1 out of 2 Pods to stop, you can run "kubectl logs" to observe the logs of the terminating Pod.
3. Our .NETASP app will handle the SIGTERM signal and wait 30s before exiting the process.
4. You can also run the app locally and do a "kill -15" to simulate this.

[Install AWS CLI]: <https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html>
[Config AWS CLI]: <https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html>
[Install Docker]: <https://docs.docker.com/engine/install/>
[Install Docker buildx]: <https://github.com/docker/buildx#dockerfile>
