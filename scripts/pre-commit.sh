#!/bin/bash
TAG="v1.96.1@sha256:9aea677ac51d67eb96b3bbb4cf93b16afdde5476f984e75e87888850d18146c9"
docker run -v "$(pwd):/lint" -v "$HOME/.terraform.d:$HOME/.terraform.d" -w /lint ghcr.io/antonbabenko/pre-commit-terraform:$TAG run -a
