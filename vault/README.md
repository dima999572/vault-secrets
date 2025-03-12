# Vault Setup Guide

## 1. Create a Kubernetes Namespace

Create a Kubernetes namespace for Vault by running the following command:

```bash
kubectl create namespace vault
```

To verify that the resources are created in the vault namespace, run:

```bash
kubectl get all --namespace vault
```

## 2. Create Persistent Volume Claim

Next, create the PersistentVolumeClaim by applying the configuration file (pvc.yaml).
To apply the PVC, use:

```bash
kubectl apply -f pvc.yaml
```

## 3. Create Vault Values Configuration

Create a vault-values.yaml with the appropriate configuration.

## 4. Setup Helm Repository and Install Vault

### 4.1 Add the HashiCorp Helm Repository

To add the HashiCorp Helm repository, run:

```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
```

### 4.2 Verify Helm Chart Access

Check that you have access to the Vault chart by running:

```bash
helm search repo hashicorp/vault
```

### 4.3 Install or Upgrade Vault using Helm

You can install or upgrade Vault using Helm. Optionally, you can run the command with the --dry-run flag to preview the generated manifests:

```bash
helm upgrade --install --create-namespace --namespace vault vault hashicorp/vault \
  --values vault-values.yaml
```

To view the generated manifests, use:

```bash
helm get manifest -n vault vault
```

## 5. Initialize Vault

To initialize the Vault server, run the following command:

```bash
kubectl exec -it vault-0 -n vault -- vault operator init
```

This will output the unseal keys and the initial root token:

```bash
Unseal Key 1: <UNSEAL_KEY_1>
Unseal Key 2: <UNSEAL_KEY_2>
Unseal Key 3: <UNSEAL_KEY_3>
Unseal Key 4: <UNSEAL_KEY_4>
Unseal Key 5: <UNSEAL_KEY_5>

Initial Root Token: <ROOT_TOKEN>
```

## 6. Unseal the Vault Server

To unseal the Vault server, use the unseal keys generated during initialization. You must unseal the server until the key threshold is met (typically 3 out of 5 keys).

Run the following commands for each unseal key:

```bash
kubectl exec -it vault-0 -n vault -- vault operator unseal <UNSEAL_KEY_1>
kubectl exec -it vault-0 -n vault -- vault operator unseal <UNSEAL_KEY_2>
kubectl exec -it vault-0 -n vault -- vault operator unseal <UNSEAL_KEY_5>
```

Once the key threshold is reached, Vault will be unsealed and ready for use.

