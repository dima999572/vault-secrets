#!/bin/bash

# Capture the output of the Vault operator init command
keys=$(kubectl exec -it vault-0 -n vault -- vault operator init)
exit_code=$?

echo "$keys"

# Check if the kubectl exec command succeeded
if [ $exit_code -eq 2 ]; then
    echo "Vault is already initialized"
elif [ $exit_code -eq 0 ]; then
    echo "Vault initialization successful"
    echo "$keys" > vault_keys.txt
else
    echo "Vault initialization failed with exit code $exit_code"
    exit 1
fi
