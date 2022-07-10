#!/bin/bash

arg_count=$#
script_name=$(basename $0)
script_action=""

if test $arg_count -eq 1; then
  if [[ $1 =~ ^(ecr|dockerhub)$ ]]; then
    script_action=$1
  else
    echo "Script Action must be ecr or dockerhub"
    echo "Usage: $script_name [ecr|dockerhub]"
    exit -1
  fi
else
  echo "Usage: $script_name [ecr|dockerhub]"
  echo ""
  echo "Examples:"
  echo "$script_name ecr"
  echo ""
  exit 0
fi

# Get script location.
SHELL_PATH=$(cd "$(dirname "$0")";pwd)

pushToEcr()
{
    local aws_account_id="$(aws sts get-caller-identity --output text --query 'Account')"
    local deployment_region="$(aws configure get region)"

    # app's image repository.
    local aspdotnet_repo="dotnetasp-sigterm-demo"
    # app's image repository host.
    local aspdotnet_repo_host=$aws_account_id.dkr.ecr.$deployment_region.amazonaws.com
    # app's image repository URI.
    local aspdotnet_repo_uri=$aspdotnet_repo_host/$aspdotnet_repo

    aws ecr describe-repositories --repository-names $aspdotnet_repo --region $deployment_region &> /dev/null
    local result=$?
    if [ $result -ne 0 ]; then
        echo "Create image repository..."
        aws ecr create-repository --repository-name $aspdotnet_repo --region $deployment_region
    fi

    echo "Login to ECR..."
    aws ecr get-login-password --region $deployment_region | docker login --username AWS --password-stdin $aspdotnet_repo_host

    echo "Build docker image..."
    local image_tag="$(echo $(date '+%Y.%m.%d.%H%M%S' -d '+8 hours'))"
    docker buildx build --push --platform linux/arm64,linux/amd64 --tag $aspdotnet_repo_uri:latest --tag $aspdotnet_repo_uri:$image_tag ${SHELL_PATH}/.

    echo
    echo "Done"
}

pushToDockerHub()
{
    local aspdotnet_repo_uri=cowcoa/dotnetasp-sigterm-demo

    echo "Login to DockerHub..."
    docker login registry-1.docker.io

    echo "Build docker image..."
    docker buildx build --push --platform linux/arm64,linux/amd64 --tag $aspdotnet_repo_uri:latest ${SHELL_PATH}/.

    echo
    echo "Done"
}

if [ $script_action = ecr ]; then
    pushToEcr
else
    pushToDockerHub
fi
