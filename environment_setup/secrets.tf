resource "kubernetes_secret" "jenkins_secret" {
  metadata {
    name      = "jenkins-secret"
    namespace = "jenkins"
    annotations = {
      "kubernetes.io/service-account.name" = "jenkins"
    }
  }

  type = "kubernetes.io/service-account-token"

  depends_on = [helm_release.jenkins]
}

resource "kubernetes_secret" "vault_root_sa_secret" {
  metadata {
    name      = "vault-root-sa-secret"
    namespace = "vault"

    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.vault_root_sa.metadata[0].name
    }
  }

  type = "kubernetes.io/service-account-token"

  depends_on = [kubernetes_service_account.vault_root_sa]
}

resource "kubernetes_secret" "artifactory_masterkey" {
  metadata {
    name      = "artifactory-masterkey-secret"
    namespace = "artifactory"
  }

  data = {
    master-key = base64encode(random_string.master_key.result)
  }

  depends_on = [kubernetes_namespace.artifactory]
}

resource "kubernetes_secret" "artifactory_joinkey" {
  metadata {
    name      = "artifactory-joinkey-secret"
    namespace = "artifactory"
  }

  data = {
    join-key = base64encode(random_string.join_key.result)
  }

  depends_on = [kubernetes_namespace.artifactory]
}
