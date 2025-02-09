# ELK Setup Guide

## 1. Create a Elastic Namespace

Create a Kubernetes namespace for Elastic by running the following command:

```bash
kubectl create namespace elastic
```

To verify that the resources are created in the elastic namespace, run:

```bash
kubectl get all --namespace elastic
```

## 2. Setup Helm Repository and Install Elastic

### 2.1 Add the Elastic Helm Repository

To add the Elastic Helm repository, run:

```bash
helm repo add elastic https://helm.elastic.co
```

### 2.2 Verify Helm Chart Access

Check that you have access to the Jenkins chart by running:

```bash
helm search repo elastic/elasticsearch
```

### 2.3 Install or Upgrade Jenkins using Helm

You can install or upgrade Jenkins using Helm. Optionally, you can run the command with the --dry-run flag to preview the generated manifests:

```bash
helm upgrade --install --create-namespace --namespace elastic elastic elastic/elasticsearch
```

To view the generated manifests, use:

```bash
helm get manifest -n elastic elastic
```
