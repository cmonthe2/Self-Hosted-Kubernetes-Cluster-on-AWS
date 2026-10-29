# ─────────────────────────────────────────────────────────────────────────────
# SSH key outputs
# ─────────────────────────────────────────────────────────────────────────────

output "key_pair_name" {
  description = "Name of the EC2 key pair created by Terraform"
  value       = aws_key_pair.cluster.key_name
}

output "ssh_private_key_ssm_path" {
  description = "SSM Parameter Store path where the SSH private key is stored"
  value       = aws_ssm_parameter.ssh_private_key.name
}

# ─────────────────────────────────────────────────────────────────────────────
# Network outputs
# ─────────────────────────────────────────────────────────────────────────────

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}

# ─────────────────────────────────────────────────────────────────────────────
# EC2 outputs
# ─────────────────────────────────────────────────────────────────────────────

output "control_plane_public_ip" {
  description = "Public IP of the control-plane node (use for SSH and kubeconfig)"
  value       = aws_instance.control_plane.public_ip
}

output "control_plane_private_ip" {
  description = "Private IP of the control-plane node"
  value       = aws_instance.control_plane.private_ip
}

output "control_plane_instance_id" {
  description = "EC2 instance ID of the control-plane node"
  value       = aws_instance.control_plane.id
}

output "worker_instance_ids" {
  description = "EC2 instance IDs of all worker nodes"
  value       = aws_instance.workers[*].id
}

output "worker_private_ips" {
  description = "Private IPs of all worker nodes"
  value       = aws_instance.workers[*].private_ip
}

# ─────────────────────────────────────────────────────────────────────────────
# Ansible-ready inventory snippet
# ─────────────────────────────────────────────────────────────────────────────

output "ansible_inventory_hint" {
  description = "Paste into ansible/inventory/hosts if you prefer a static inventory"
  value       = <<-EOT
    [control_plane]
    ${aws_instance.control_plane.public_ip} ansible_user=ubuntu

    [workers]
    %{for ip in aws_instance.workers[*].private_ip~}
    ${ip} ansible_user=ubuntu
    %{endfor~}
  EOT
}
