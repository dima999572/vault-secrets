resource "kubernetes_cluster_role_binding" "vault_root_sa_clusterrolebinding" {
  metadata {
    name = "vault-root-sa-clusterrolebinding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "vault-root-sa"
    namespace = "vault"
  }

  depends_on = [kubernetes_namespace.vault]
}
