# ─────────────────────────────────────────────────────────────────────────────
# Control Plane Node
# ─────────────────────────────────────────────────────────────────────────────

resource "aws_instance" "control_plane" {
  ami                    = local.ubuntu_ami_id
  instance_type          = var.control_plane_instance_type
  key_name               = aws_key_pair.cluster.key_name
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.control_plane.id]
  iam_instance_profile   = aws_iam_instance_profile.control_plane.name

  # Required for cloud-controller-manager — do NOT disable
  source_dest_check = false

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size_gb
    delete_on_termination = true
    encrypted             = true

    tags = merge(local.common_tags, {
      Name = "${local.name_prefix}-control-plane-root"
    })
  }

  # Minimal cloud-init: set hostname and ensure SSM agent is running.
  # Full Kubernetes bootstrapping is handled by Ansible.
  user_data = base64encode(templatefile("${path.module}/templates/userdata.sh.tpl", {
    hostname = "${local.name_prefix}-control-plane"
  }))

  tags = merge(local.common_tags, {
    Name                                         = "${local.name_prefix}-control-plane"
    Role                                         = "control-plane"
    "kubernetes.io/cluster/${local.name_prefix}" = "owned"
  })

  lifecycle {
    ignore_changes = [ami, user_data]
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# Worker Nodes
# ─────────────────────────────────────────────────────────────────────────────

resource "aws_instance" "workers" {
  count = var.worker_count

  ami                    = local.worker_ami_id
  instance_type          = var.worker_instance_type
  key_name               = aws_key_pair.cluster.key_name
  subnet_id              = aws_subnet.private[count.index % length(aws_subnet.private)].id
  vpc_security_group_ids = [aws_security_group.workers.id]
  iam_instance_profile   = aws_iam_instance_profile.workers.name

  source_dest_check = false

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size_gb
    delete_on_termination = true
    encrypted             = true

    tags = merge(local.common_tags, {
      Name = "${local.name_prefix}-worker-${count.index}-root"
    })
  }

  user_data = base64encode(templatefile("${path.module}/templates/userdata.sh.tpl", {
    hostname = "${local.name_prefix}-worker-${count.index}"
  }))

  tags = merge(local.common_tags, {
    Name                                         = "${local.name_prefix}-worker-${count.index}"
    Role                                         = "worker"
    "kubernetes.io/cluster/${local.name_prefix}" = "owned"
  })

  lifecycle {
    ignore_changes = [ami, user_data]
  }
}
