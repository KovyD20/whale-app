#!/bin/bash
set -euxo pipefail
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

if command -v apt-get >/dev/null 2>&1; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -y
  apt-get install -y docker.io awscli
  systemctl enable --now docker
elif command -v dnf >/dev/null 2>&1; then
  dnf install -y docker awscli
  systemctl enable --now docker
elif command -v yum >/dev/null 2>&1; then
  yum install -y docker awscli
  systemctl enable --now docker
else
  echo "No supported package manager found."
  exit 1
fi

mkdir -p /opt/kd-whale
cd /opt/kd-whale
aws ecr get-login-password --region ${aws_region} | docker login --username AWS --password-stdin ${ecr_registry}
docker pull ${app_image}
docker pull ${nginx_image}
docker rm -f nginx app1 app2 || true
docker network create whale-net || true

docker run -d --name app1 --restart unless-stopped \
  --network whale-net \
  -e PORT=3000 \
  -e INSTANCE_ID=app-1 \
  ${app_image}

docker run -d --name app2 --restart unless-stopped \
  --network whale-net \
  -e PORT=3000 \
  -e INSTANCE_ID=app-2 \
  ${app_image}

docker run -d --name nginx --restart unless-stopped \
  --network whale-net \
  -p 80:80 \
  ${nginx_image}
