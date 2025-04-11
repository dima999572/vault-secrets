# Vault Integration


This project helps to understand and implement integration between HashiCorp Vault, Jenkins, and JFrog Artifactory. The goal of the integration is to dynamically create secrets for Artifactory within the Jenkins Pipeline.

## Quick Start Gu

1. **Setup Minikube Cluster**
- Ensure you have Minikube installed. You can follow the [official Minikube installation guide](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Farm64%2Fstable%2Fbinary+download)
- Deploy initial configuration using Terraform:
    ```sh
    cd environment_setup/
    terraform init
    terraform apply
    ```

2. **Manual Configuration**

Due to some limitations of the OSS versions of services, the process of this integration couldn't be fully automated. Before the last step, you need to perform a couple of manual actions

2.1 **Vault Preparation**

- Enable the KV engine in Vault
    ```sh
    vault secrets enable -path=kv kv-v2
    ```

2.2 **Get SA JWT Token**

- Retrieve the JWT token:
    ```sh
    kubectl --namespace vault get secret vault-root-sa-secret --output 'go-template={{ .data.token }}' | base64 --decode
    ```
- Store this token in Vault under the path `kv/vault_configuration/kubernetes_sa_jwt`.

2.3 **Get SA CA CRT**
- Retrieve the CA certificate:
    ```sh
    kubectl --namespace vault get secret vault-root-sa-secret --output=jsonpath="{ .data['ca\.crt'] }" | base64 --decode
    ```
- Store this certificate in Vault under the path `kv/vault_configuration/kubernetes_sa_crt`.

3. **Jfrog Artifacotry Preparation**

3.1 **Create Vault Integration User**

- Create a user named `vault-integration`.
- Generate an access token for this user.
- Store the token in Vault under the path `kv/vault_configuration/vault_integration_access_token`.

2. **Create Viewer User**

- Create  a user named `viewer` in Artifactory.
- Assign the user to the `readers` group.

4. **Automated Integration Configuration**

After completing the previous steps, use Terraform to deploy the integration configuration:
```sh
cd integration_configuration/
terraform init
terraform apply
```

4. Final Step - Jenkins Configuration, Pipeline setup 