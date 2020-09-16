#!/bin/sh

set -e


REGISTRY=docker.pkg.github.com
REPO_OWNER=`echo $GITHUB_REPOSITORY | cut -d'/' -f1`
REPO_NAME=`echo $GITHUB_REPOSITORY | cut -d'/' -f2`

echo "Authenticating with $REGISTRY as $REPO_OWNER..."
echo $INPUT_PASSWORD | docker login $REGISTRY -u $REPO_OWNER --password-stdin

echo "Configuring Kubernetes CLI..."
mkdir -p ~/.kube
echo $INPUT_KUBECONFIG | base64 -d > ~/.kube/config

id 
echo home=$HOME

echo "Creating Docker secret for Kubernetes..."
kubectl create secret generic docker \
    --from-file=.dockerconfigjson=/root/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson

echo "Configuring deployment version..."
export GIT_SHA_SHORT=$(git rev-parse --short HEAD)
export CURRENT_DATE=$(date +%F-%T)
export VERSION="$CURRENT_DATE-$GIT_SHA_SHORT"
sed -i "s/{{VERSION}}/$VERSION/g" k8s.yml
echo "Deploying $VERSION"

echo "Deploying..."
kubectl apply -f k8s.yml