terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.7.0"
    }
  }
}

provider "vault" {
  address         = local.integration_vault_server
  skip_tls_verify = true
  token           = ""
}
