resource "vault_auth_backend" "kubernetes_auth" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes_auth_config" {
  backend            = vault_auth_backend.kubernetes_auth.path
  kubernetes_host    = "https://kubernetes.default.svc.cluster.local"
  kubernetes_ca_cert = local.kubernetes_sa_cert
  token_reviewer_jwt = local.kubernetes_sa_jwt
}

resource "vault_kubernetes_auth_backend_role" "kubernetes_auth_anyone_role" {
  backend                          = vault_auth_backend.kubernetes_auth.path
  alias_name_source                = "serviceaccount_name"
  role_name                        = "anyone"
  bound_service_account_names      = ["*"]
  bound_service_account_namespaces = ["*"]
  token_ttl                        = 300
  token_max_ttl                    = 900
  token_policies                   = ["artifactory"]
}
