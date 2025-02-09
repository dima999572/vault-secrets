#!/bin/bash

kubectl --namespace jenkins port-forward svc/jenkins 8080:8080 &
