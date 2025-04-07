# Due to restrictions from the Artifactory side, we can't fully automate the process of Artifactory backend configuration in Vault.
# Before running this script, you need to manually create the user 'vault-integration' in Artifactory and then generate a token for this integration.

#!/bin/bash

export VAULT_ADDR="http://127.0.0.1:8200"

# Prompt the user for the access token
read -sp "Enter your access token: " ACCESS_TOKEN
echo

vault login

vault write artifactory/config/admin \
  url="http://$(kubectl get service artifactory -n artifactory -o json | jq -r '.spec.clusterIP + ":" + (.spec.ports[0].port | tostring)')" \
  default_ttl=5m \
  max_ttl=15m \
  username_template="{{ printf \"v_user_%s_%s\" (.RoleName | replace \"-\" \"_\") (unix_time_millis) }}" \
  use_expiring_tokens=false \
  revoke_on_delete=true \
  access_token="$ACCESS_TOKEN"

# Rotate that $ACCESS_TOKEN to keep it in secret from humans!
vault write -f artifactory/config/rotate