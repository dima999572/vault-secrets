variable "kubernetes_config_path" {
  description = "Kubernetes Config Path"
  type        = string
  default     = "~/.kube/config"
}

variable "kubernetes_config_context" {
  description = "Kubernetes Config Context"
  type        = string
  default     = "minikube"
}
