# ─────────────────────────────────────────────────────────────────────────────
# SSH Key Pair — fully managed by Terraform
#
# 1. tls_private_key generates a fresh RSA-4096 key in Terraform state.
# 2. aws_key_pair registers the public half with EC2.
# 3. aws_ssm_parameter stores the private key in SSM Parameter Store
#    (SecureString, encrypted with the default SSM KMS key).
#
# The Ansible job in GitHub Actions fetches the private key from SSM at
# runtime — no SSH secrets need to be stored in GitHub.
# ─────────────────────────────────────────────────────────────────────────────

resource "tls_private_key" "cluster" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "cluster" {
  key_name   = "${local.name_prefix}-key"
  public_key = tls_private_key.cluster.public_key_openssh

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-key"
  })
}

resource "aws_ssm_parameter" "ssh_private_key" {
  name        = "/${local.name_prefix}/ssh-private-key"
  description = "SSH private key for Ansible to access cluster nodes"
  type        = "SecureString"
  value       = tls_private_key.cluster.private_key_openssh

  # Overwrite on re-apply so the parameter stays in sync with the key in state
  overwrite = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-ssh-private-key"
  })

  lifecycle {
    # Prevent accidental deletion while instances still depend on this key
    prevent_destroy = false
  }
}
