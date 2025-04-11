#!/bin/bash
CA_CERT=$(kubectl --namespace vault get secret vault-root-sa-secret --output=jsonpath="{ .data['ca\.crt'] }" | base64 --decode)

jq -n --arg output "$CA_CERT" '{"output":$output}'
