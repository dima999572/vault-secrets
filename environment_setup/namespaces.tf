resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"
  }
}

resource "kubernetes_namespace" "artifactory" {
  metadata {
    name = "artifactory"
  }
}

resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
}
