#!/bin/bash

kubectl apply -f vault/namespaces.yaml
kubectl apply -f vault/pvc.yaml

helm_releases=$(helm list --all-namespaces -q)

if [[ "$helm_releases" == *"vault"* ]]; then
    echo "Vault Release exists"
else
    # Add the Vault Helm repository if it hasn't been added yet
    helm repo add hashicorp https://helm.releases.hashicorp.com

    # (Optionally) Update the helm repositories to ensure we have the latest charts
    # helm repo update

    # Install or upgrade the release
    helm upgrade --install --create-namespace --namespace vault vault hashicorp/vault \
        --values vault/vault-values.yaml
fi
