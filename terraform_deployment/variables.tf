variable "kubernetes_ca_cert" {
  description = "The CA certificate used to validate the Kubernetes API server's certificate"
  type        = string
  default     = <<EOT
placeholder
EOT
}

variable "token_reviewer_jwt" {
  description = "The JWT token for the Kubernetes service account used for authentication"
  type = string
  default = "placeholder"
}