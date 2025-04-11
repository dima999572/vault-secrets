locals {
  integration_vault_server = "http://127.0.0.1:8200"
  integration_namespace    = "vault"

  jfrog_server = "http:127.0.0.1:8082"

  vault_integration_access_token = data.vault_generic_secret.vault_config.data["vault_integration_access_token"]
  kubernetes_sa_jwt = data.vault_generic_secret.vault_config.data["kubernetes_sa_jwt"]
  kubernetes_sa_cert = data.vault_generic_secret.vault_config.data["kubernetes_sa_crt"]
}
