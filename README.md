
# Project Title

A brief description of what this project does and who it's for

# Vault Integration


This project helps to understand and implement integration between HashiCorp Vault, Jenkins, and JFrog Artifactory. The goal of the integration is to dynamically create secrets for Artifactory within the Jenkins Pipeline.

## Quick Start Guide

**Setup Minikube Cluster**
- Ensure you have Minikube installed. You can follow the [official Minikube installation guide](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Farm64%2Fstable%2Fbinary+download)
- Deploy initial configuration using Terraform:
    ```sh
    cd environment_setup/
    terraform init
    terraform apply
    ```

**Manual Configuration**

Due to some limitations of the OSS versions of services, the process of this integration couldn't be fully automated. Before the last step, you need to perform a couple of manual actions

**Vault Preparation**

Enable the KV engine in Vault
```sh
vault secrets enable -path=kv kv-v2
````

**Get SA JWT Token**

Retrieve the JWT token:
```sh
kubectl --namespace vault get secret vault-root-sa-secret --output 'go-template={{ .data.token }}' | base64 --decode
```
Store this token in Vault under the path `kv/vault_configuration/kubernetes_sa_jwt`.

**Get SA CA CRT**

Retrieve the CA certificate:
```sh
kubectl --namespace vault get secret vault-root-sa-secret --output=jsonpath="{ .data['ca\.crt'] }" | base64 --decode
```
- Store this certificate in Vault under the path `kv/vault_configuration/kubernetes_sa_crt`.

**Jfrog Artifacotry Preparation**

*Create Vault Integration User*

- Create a user named `vault-integration`.
- Generate an access token for this user.
- Store the token in Vault under the path `kv/vault_configuration/vault_integration_access_token`.

*Create Viewer User*

- Create  a user named `viewer` in Artifactory.
- Assign the user to the `readers` group.

**Automated Integration Configuration**

After completing the previous steps, use Terraform to deploy the integration configuration:
```sh
cd integration_configuration/
terraform init
terraform apply
```

**Jenkins Configuration, Pipeline Setup**

Install HashiCorp Vault and HashiCorp Vault Plugins

*Configure HashiCorp Vault Plugin*

- Navigate to `Manage Jenkins -> System -> Vault Plugin`
- Click `Add` button under the `Vault Credentials` field
- Set Kind to `Vault Kubernetes Credential`, Role to anyone, Mount Path to kubernetes, and ID to `vault-kubernetes-credentials`
- Select the created credentials under `Vault Credentials` field.
- Vault URL Should be `http://vault.vault.svc.cluster.local:8200`

*Configure Artifactory Token*

- Navigate to the `System -> Credentials`
- Click `Add Credentials` button
- Set Kind to `Vault Secret Text Credential`, Path to `artifactory/token/viewer`, Vault Key to `access_token`, K/V Enginer Version to `1`, and ID to `artifactory_token`
- Click `Test Vault Secrets Credentials` to ensure everything works fine

**Finish**

Everything is ready. You can use Jenkinsfile provided by this repo to utilize this secret.
