#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AWS_REGION="${AWS_REGION:-eu-west-3}"
TAG="${TAG:-latest}"

ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
ECR_REGISTRY="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
APP_IMAGE="${ECR_REGISTRY}/kd-whale_app:${TAG}"
NGINX_IMAGE="${ECR_REGISTRY}/kd-whale_nginx:${TAG}"

aws ecr get-login-password --region "${AWS_REGION}" \
  | docker login --username AWS --password-stdin "${ECR_REGISTRY}"

docker build -t "${APP_IMAGE}" "${ROOT_DIR}/app"
docker build -t "${NGINX_IMAGE}" "${ROOT_DIR}/nginx"

docker push "${APP_IMAGE}"
docker push "${NGINX_IMAGE}"

printf "app_image=%s\nnginx_image=%s\n" "${APP_IMAGE}" "${NGINX_IMAGE}"
