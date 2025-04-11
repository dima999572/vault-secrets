resource "null_resource" "install_vault_plugin" {
  provisioner "local-exec" {
    command = <<EOT
kubectl -n vault cp ./artifactory-secrets-plugin/artifactory-secrets-plugin vault/vault-0:/vault/plugins/vault-plugin-secrets-artifactory -c vault
kubectl -n vault exec vault-0 -- chmod +x /vault/plugins/vault-plugin-secrets-artifactory -c vault
kubectl -n vault exec vault-0 -- chown vault:vault /vault/plugins/vault-plugin-secrets-artifactory -c vault
EOT
  }
}

resource "vault_plugin" "vault_plugin_secrets_artifactory" {
  type    = "secret"
  name    = "vault-plugin-secrets-artifactory"
  command = "vault-plugin-secrets-artifactory"
  version = "v1.8.5"
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

resource "vault_generic_secret" "artifactory_config" {
  path = "artifactory/config/admin"

  data_json = jsonencode({
    url                                 = "http://artifactory.artifactory.svc.cluster.local:8082"
    default_ttl                         = "5m"
    max_ttl                             = "15m"
    username_template                   = "{{ printf \"v_user_%s_%s\" (.RoleName | replace \"-\" \"_\") (unix_time_millis) }}"
    use_expiring_tokens                 = false
    revoke_on_delete                    = true
    access_token                        = local.vault_integration_access_token
    bypass_artifactory_tls_verification = true
  })

  lifecycle {
    ignore_changes = [
      data_json
    ]
  }
}

# TO VERIFY LATER
# resource "vault_generic_secret" "rotate_artifactory_token" {
#   path         = "artifactory/config/rotate"
#   disable_read = true

#   data_json = jsondecode({})
# }

resource "vault_generic_secret" "artifactory_role_viewer" {
  path = "artifactory/roles/viewer"

  data_json = jsonencode({
    scope       = "applied-permissions/user"
    username    = "viewer"
    default_ttl = "5m"
    max_ttl     = "15m"
  })

  lifecycle {
    ignore_changes = [
      data_json
    ]
  }
}
