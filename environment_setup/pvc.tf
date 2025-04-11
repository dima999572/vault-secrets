resource "kubernetes_persistent_volume_claim" "vault_plugins" {
  metadata {
    name      = "vault-plugins"
    namespace = "vault"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "1Gi"
      }
    }

    volume_mode = "Filesystem"
  }

  depends_on = [kubernetes_namespace.vault]
}

resource "kubernetes_persistent_volume_claim" "artifactory_pvc" {
  metadata {
    name      = "artifactory-pvc"
    namespace = "artifactory"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }

  depends_on = [kubernetes_namespace.artifactory]
}

resource "kubernetes_persistent_volume_claim" "artifactory_postgres_pvc" {
  metadata {
    name      = "artifactory-postgres-pvc"
    namespace = "artifactory"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "20Gi"
      }
    }
  }
  
  depends_on = [ kubernetes_namespace.artifactory ]
}
