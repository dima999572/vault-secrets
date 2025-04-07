#!/bin/bash

kubectl apply -f artifactory/namespaces.yaml
kubectl apply -f vault/pvc.yaml

helm_releases=$(helm list --all-namespaces -q)

if [[ "$helm_releases" == *"artifactory"* ]]; then
    echo "Artifactore Release exists"
else
    # Add the JFrog Helm repository if it hasn't been added yet
    helm repo add jfrog https://charts.jfrog.io

    # (Optionally) Update the helm repositories to ensure we have the latest charts
    # helm repo update

    # Install or upgrade the release
    export MASTER_KEY=$(openssl rand -hex 32)
    kubectl create secret generic artifactory-masterkey-secret -n artifactory --from-literal=master-key=${MASTER_KEY}

    export JOIN_KEY=$(openssl rand -hex 32)
    kubectl create secret generic artifactory-joinkey-secret -n artifactory --from-literal=join-key=${JOIN_KEY}

    helm upgrade --install --create-namespace --namespace artifactory artifactory jfrog/artifactory-oss \
        --values artifactory/artifactory-values.yaml
fi
