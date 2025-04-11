resource "vault_policy" "artifactory_policy" {
  name = "artifactory"

  policy = <<EOT
path "artifactory/token/viewer" {
    capabilities = ["read"]
}
EOT
}