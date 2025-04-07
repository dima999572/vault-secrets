# Due to restrictions from the Artifactory side, we can't fully automate the process of Artifactory backend configuration in Vault.
# Before running this script, you need to manually create the user 'viewer' in Artifactory.

#!/bin/bash

export VAULT_ADDR="http://127.0.0.1:8200"

vault login

vault write -f artifactory/roles/viewer \
  scope="applied-permissions/user" \
  username="viewer@gmail.com" \
  default_ttl=5m \
  max_ttl=15m
