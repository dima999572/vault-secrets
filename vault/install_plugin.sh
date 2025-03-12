#!/bin/bash

export VAULT_ADDR="http://127.0.0.1:8200"
plugin_dir="vault/plugins/artifactory"
plugin_url="https://github.com/jfrog/vault-plugin-secrets-artifactory/releases/download/v1.8.5/artifactory-secrets-plugin_1.8.5_linux_amd64"
plugin_path="$plugin_dir/artifactory-secrets-plugin"

if [ -d "$plugin_dir" ]; then
    echo "Directory $plugin_dir exists"
else
    echo "Directory '$plugin_dir' does not exist. Creating it..."
    mkdir -p "$plugin_dir"
fi

if [ -f "$plugin_path" ]; then
    echo "Plugin already downloaded."
else
    echo "Downloading the Artifactory Vault plugin..."
    curl -fLo "$plugin_path" "$plugin_url"

        # Check if curl was successful
    if [ $? -eq 0 ]; then
        echo "Plugin downloaded successfully."
    else
        echo "Failed to download the plugin."
        exit 1
    fi
fi

# kubectl --namespace vault cp "$plugin_path" vault-0:/vault/plugins/artifactory-secrets-plugin -c vault
# kubectl --namespace vault exec -it vault-0 -- \
#   chmod +x /vault/plugins/artifactory-secrets-plugin
# kubectl --namespace vault exec -it vault-0 -- \
#   chown vault:vault /vault/plugins/artifactory-secrets-plugin

# vault plugin register -sha256=$(kubectl --namespace vault exec -it vault-0 -- \
#   sha256sum /vault/plugins/artifactory-secrets-plugin | cut -d " " -f 1) \
#   -command=artifactory-secrets-plugin secret artifactory

# vault secrets enable -path=artifactory artifactory

vault write artifactory/config/admin \
  url=http://127.0.0.1:8200 \
  default_ttl=5m \
  max_ttl=15m \
  username_template="{{ printf \"v_user_%s_%s\" (.RoleName | replace \"-\" \"_\") (unix_time_millis) }}" \
  use_expiring_tokens=false \
  revoke_on_delete=true \
  access_token="<access_token>"
