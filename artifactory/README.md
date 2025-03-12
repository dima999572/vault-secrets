# Artifactory Setup Guide

This guide will walk you through setting up **Artifactory OSS** using Helm in a Kubernetes environment.

## 1. Create a Kubernetes Namespace

Create a Kubernetes namespace for Artifactory by running the following command:

```bash
kubectl create namespace artifactory
```

To verify that the resources are created in the artifactory namespace, run:

```bash
kubectl get all --namespace artifactory
```

## 2. Setup Helm Repository and Install Artifactory

### 2.1 Add the JFrog Helm Repository

Add the JFrog Helm repository to your Helm configuration:

```bash
helm repo add jfrog https://charts.jfrog.io
```

### 2.2 Verify Helm Chart Access

To ensure you have access to the Artifactory chart, you can search for it with:

```bash
helm search repo jfrog/artifactory
```

### 2.3 Install or Upgrade Artifactory using Helm

You can install or upgrade Artifactory using Helm. Optionally, you can run the command with the --dry-run flag to preview the generated manifests:

```bash
helm upgrade --install --create-namespace --namespace artifactory artifactory jfrog/artifactory-oss
```

To view the generated manifests, use:

```bash
helm get manifest -n artifactory artifactory
```

## 3. Accessing Artifactory

Once the installation is complete, you can access Artifactory. The default username and password are:

- Username: admin
- Password: password
