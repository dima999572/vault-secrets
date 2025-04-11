#!/bin/bash
TOKEN=$(kubectl --namespace vault get secret vault-root-sa-secret --output "go-template={{ .data.token }}" | base64 --decode)

jq -n --arg output "$TOKEN" '{"output":$output}'
