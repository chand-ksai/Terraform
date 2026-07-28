#!/bin/bash
set -euxo pipefail

# ------------------------------------------------------------------
# Amazon SSM Agent
# Pre-installed and pre-started on Amazon Linux 2023 AMIs, but we
# make sure it's present and enabled in case a different AMI is used.
# ------------------------------------------------------------------
if ! systemctl is-active --quiet amazon-ssm-agent 2>/dev/null; then
  dnf install -y amazon-ssm-agent || true
  systemctl enable --now amazon-ssm-agent || true
fi

# ------------------------------------------------------------------
# Git
# ------------------------------------------------------------------
dnf install -y git

# ------------------------------------------------------------------
# Docker
# ------------------------------------------------------------------
dnf install -y docker
systemctl enable --now docker

# Allow the default ec2-user to run docker without sudo
usermod -aG docker ec2-user || true

# ------------------------------------------------------------------
# Tag this instance's role for easy identification in logs
# ------------------------------------------------------------------
echo "instance_role=${instance_role}" > /etc/instance-role.env
