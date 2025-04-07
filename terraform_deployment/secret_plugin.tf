resource "null_resource" "install_vault_plugin" {
  provisioner "local-exec" {
    command = <<EOT
kubectl -n vault cp ../vault/plugins/artifactory/artifactory-secrets-plugin vault/vault-0:/vault/plugins/vault-plugin-secrets-artifactory -c vault
kubectl -n vault exec vault-0 -- chmod +x /vault/plugins/vault-plugin-secrets-artifactory -c vault
kubectl -n vault exec vault-0 -- chown vault:vault /vault/plugins/vault-plugin-secrets-artifactory -c vault
EOT
  }
}

resource "vault_plugin" "vault_plugin_secrets_artifactory" {
  type    = "secret"
  name    = "vault-plugin-secrets-artifactory"
  command = "vault-plugin-secrets-artifactory"
  version = "v1.8.6"
  sha256  = "a32ad9592ebb65cf1d98a1ca59cea3e95d5479a070147cde4b2e0cd8576dcf9e" # shasum -a 256 /path/to/your/plugin-file

  depends_on = [
    null_resource.install_vault_plugin
  ]
}

resource "vault_mount" "artifactory" {
  path        = "artifactory"
  type        = "vault-plugin-secrets-artifactory"
  description = "Artifactory secrets engine"

  depends_on = [
    vault_plugin.vault_plugin_secrets_artifactory
  ]
}
