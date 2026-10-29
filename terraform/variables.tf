
variable "project_name" {
  description = "Name prefix applied to all resources"
  type        = string
  default     = "k8s-cluster"
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

# ── Networking ──────────────────────────────────────────────────────────────

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

# ── EC2 ──────────────────────────────────────────────────────────────────────

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to reach the nodes on port 22. Defaults to open (0.0.0.0/0) — override at apply time with the runner's IP."
  type        = string
  default     = "0.0.0.0/0"
}

# ── Control Plane ────────────────────────────────────────────────────────────

variable "control_plane_instance_type" {
  description = "EC2 instance type for the Kubernetes control-plane node"
  type        = string
  default     = "t3.medium"
}

variable "control_plane_ami" {
  description = "AMI ID for the control-plane node (Ubuntu 22.04 LTS recommended)"
  type        = string
  default     = "ami-0d97d7f07b25dd693"
}

# ── Worker Nodes ─────────────────────────────────────────────────────────────

variable "worker_count" {
  description = "Number of worker nodes to provision"
  type        = number
  default     = 2
}

variable "worker_instance_type" {
  description = "EC2 instance type for Kubernetes worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "worker_ami" {
  description = "AMI ID for worker nodes (Ubuntu 22.04 LTS recommended)"
  type        = string
  default     = "ami-0d97d7f07b25dd693"
}

# ── Storage ──────────────────────────────────────────────────────────────────

variable "root_volume_size_gb" {
  description = "Root EBS volume size in GiB for all cluster nodes"
  type        = number
  default     = 30
}

variable "root_volume_type" {
  description = "EBS volume type for all cluster nodes"
  type        = string
  default     = "gp3"
}
