#!/usr/bin/env bash

set -e
cat <<EOF > /home/ubuntu/.ssh/config
Host *
  IdentityFile ~/.ssh/ecs-key.pem
  User ec2-user
EOF
