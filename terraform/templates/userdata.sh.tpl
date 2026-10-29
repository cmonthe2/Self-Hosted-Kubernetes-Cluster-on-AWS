#!/usr/bin/env bash
# Minimal cloud-init — sets hostname and installs SSM agent.
# Full Kubernetes configuration is driven by Ansible after Terraform apply.
set -euo pipefail

hostnamectl set-hostname "${hostname}"

# Ensure AWS SSM agent is installed (Ubuntu 22.04 snap)
if ! snap list amazon-ssm-agent &>/dev/null; then
  snap install amazon-ssm-agent --classic
fi
snap start amazon-ssm-agent
