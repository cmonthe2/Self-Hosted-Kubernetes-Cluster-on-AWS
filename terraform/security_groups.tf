# ─────────────────────────────────────────────────────────────────────────────
# Security Group — Control Plane
# ─────────────────────────────────────────────────────────────────────────────

resource "aws_security_group" "control_plane" {
  name        = "${local.name_prefix}-sg-control-plane"
  description = "Security group for Kubernetes control-plane node"
  vpc_id      = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-sg-control-plane"
    Role = "control-plane"
  })
}

# SSH from operator IP
resource "aws_vpc_security_group_ingress_rule" "cp_ssh" {
  security_group_id = aws_security_group.control_plane.id
  description       = "SSH from operator"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = var.allowed_ssh_cidr
}

# Kubernetes API server (all; workers + kubectl clients)
resource "aws_vpc_security_group_ingress_rule" "cp_api_server" {
  security_group_id = aws_security_group.control_plane.id
  description       = "Kubernetes API server"
  ip_protocol       = "tcp"
  from_port         = 6443
  to_port           = 6443
  cidr_ipv4         = var.vpc_cidr
}

# etcd peer communication (between control-plane nodes if you later expand to HA)
resource "aws_vpc_security_group_ingress_rule" "cp_etcd" {
  security_group_id = aws_security_group.control_plane.id
  description       = "etcd peer / client"
  ip_protocol       = "tcp"
  from_port         = 2379
  to_port           = 2380
  cidr_ipv4         = var.vpc_cidr
}

# kubelet API (used by control-plane to reach kubelet on this node)
resource "aws_vpc_security_group_ingress_rule" "cp_kubelet" {
  security_group_id = aws_security_group.control_plane.id
  description       = "kubelet API"
  ip_protocol       = "tcp"
  from_port         = 10250
  to_port           = 10250
  cidr_ipv4         = var.vpc_cidr
}

# kube-scheduler + kube-controller-manager healthz
resource "aws_vpc_security_group_ingress_rule" "cp_scheduler" {
  security_group_id = aws_security_group.control_plane.id
  description       = "kube-scheduler healthz"
  ip_protocol       = "tcp"
  from_port         = 10259
  to_port           = 10259
  cidr_ipv4         = var.vpc_cidr
}

resource "aws_vpc_security_group_ingress_rule" "cp_controller" {
  security_group_id = aws_security_group.control_plane.id
  description       = "kube-controller-manager healthz"
  ip_protocol       = "tcp"
  from_port         = 10257
  to_port           = 10257
  cidr_ipv4         = var.vpc_cidr
}

# Flannel/Calico VXLAN overlay (UDP 8472 / 4789)
resource "aws_vpc_security_group_ingress_rule" "cp_vxlan" {
  security_group_id = aws_security_group.control_plane.id
  description       = "CNI VXLAN overlay"
  ip_protocol       = "udp"
  from_port         = 8472
  to_port           = 8472
  cidr_ipv4         = var.vpc_cidr
}

# Calico BGP
resource "aws_vpc_security_group_ingress_rule" "cp_bgp" {
  security_group_id = aws_security_group.control_plane.id
  description       = "Calico BGP"
  ip_protocol       = "tcp"
  from_port         = 179
  to_port           = 179
  cidr_ipv4         = var.vpc_cidr
}

# NodePort services range (for demo workloads)
resource "aws_vpc_security_group_ingress_rule" "cp_nodeport" {
  security_group_id = aws_security_group.control_plane.id
  description       = "NodePort services"
  ip_protocol       = "tcp"
  from_port         = 30000
  to_port           = 32767
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "cp_egress_all" {
  security_group_id = aws_security_group.control_plane.id
  description       = "Allow all outbound"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

# ─────────────────────────────────────────────────────────────────────────────
# Security Group — Worker Nodes
# ─────────────────────────────────────────────────────────────────────────────

resource "aws_security_group" "workers" {
  name        = "${local.name_prefix}-sg-workers"
  description = "Security group for Kubernetes worker nodes"
  vpc_id      = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-sg-workers"
    Role = "worker"
  })
}

# SSH from operator IP
resource "aws_vpc_security_group_ingress_rule" "worker_ssh" {
  security_group_id = aws_security_group.workers.id
  description       = "SSH from operator"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = var.allowed_ssh_cidr
}

# kubelet API (control-plane → worker)
resource "aws_vpc_security_group_ingress_rule" "worker_kubelet" {
  security_group_id = aws_security_group.workers.id
  description       = "kubelet API"
  ip_protocol       = "tcp"
  from_port         = 10250
  to_port           = 10250
  cidr_ipv4         = var.vpc_cidr
}

# kube-proxy healthz
resource "aws_vpc_security_group_ingress_rule" "worker_kube_proxy" {
  security_group_id = aws_security_group.workers.id
  description       = "kube-proxy healthz"
  ip_protocol       = "tcp"
  from_port         = 10256
  to_port           = 10256
  cidr_ipv4         = var.vpc_cidr
}

# CNI VXLAN overlay
resource "aws_vpc_security_group_ingress_rule" "worker_vxlan" {
  security_group_id = aws_security_group.workers.id
  description       = "CNI VXLAN overlay"
  ip_protocol       = "udp"
  from_port         = 8472
  to_port           = 8472
  cidr_ipv4         = var.vpc_cidr
}

# Calico BGP
resource "aws_vpc_security_group_ingress_rule" "worker_bgp" {
  security_group_id = aws_security_group.workers.id
  description       = "Calico BGP"
  ip_protocol       = "tcp"
  from_port         = 179
  to_port           = 179
  cidr_ipv4         = var.vpc_cidr
}

# NodePort services
resource "aws_vpc_security_group_ingress_rule" "worker_nodeport" {
  security_group_id = aws_security_group.workers.id
  description       = "NodePort services"
  ip_protocol       = "tcp"
  from_port         = 30000
  to_port           = 32767
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "worker_egress_all" {
  security_group_id = aws_security_group.workers.id
  description       = "Allow all outbound"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
