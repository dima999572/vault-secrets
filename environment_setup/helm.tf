resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace  = "jenkins"

  depends_on = [
    kubernetes_namespace.jenkins
  ]
}

resource "helm_release" "artifactory" {
  name       = "artifactory"
  repository = "https://charts.jfrog.io"
  chart      = "artifactory-oss"
  namespace  = "artifactory"

  values = [
    file("${path.module}/helm_values/artifactory-values.yaml")
  ]

  depends_on = [
    kubernetes_secret.artifactory_masterkey,
    kubernetes_secret.artifactory_joinkey,
    kubernetes_persistent_volume_claim.artifactory_pvc,
    kubernetes_persistent_volume_claim.artifactory_postgres_pvc
  ]
}

resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  namespace  = "vault"

  values = [
    file("${path.module}/helm_values/vault-values.yaml")
  ]

  depends_on = [
    kubernetes_service_account.vault_root_sa,
    kubernetes_cluster_role_binding.vault_root_sa_clusterrolebinding,
    kubernetes_secret.vault_root_sa_secret,
    kubernetes_persistent_volume_claim.vault_plugins
  ]
}
