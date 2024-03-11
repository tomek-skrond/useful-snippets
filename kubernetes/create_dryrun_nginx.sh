#!/bin/bash
kubectl create svc loadbalancer test --tcp=80:80 --dry-run=client -o yaml
kubectl create deployment test --image=nginx:latest --replicas=3 --dry-run=client -o yaml
