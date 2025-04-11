resource "kubernetes_service_account" "vault_root_sa" {
  metadata {
    name      = "vault-root-sa"
    namespace = "vault"
  }

  depends_on = [kubernetes_namespace.vault]
}
