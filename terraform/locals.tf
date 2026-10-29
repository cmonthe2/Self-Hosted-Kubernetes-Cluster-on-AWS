locals {
  # Availability zones derived from the configured region
  azs = slice(data.aws_availability_zones.available.names, 0, length(var.public_subnet_cidrs))

  # Resolve AMIs: use the supplied variable if set, otherwise fall back to the
  # latest Ubuntu 22.04 LTS AMI published by Canonical (owner 099720109477).
  ubuntu_ami_id = var.control_plane_ami != "" ? var.control_plane_ami : data.aws_ami.ubuntu.id

  # Use the same AMI for workers unless overridden
  worker_ami_id = var.worker_ami != "" ? var.worker_ami : local.ubuntu_ami_id

  # Common name prefix
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# ── Data sources ─────────────────────────────────────────────────────────────

data "aws_availability_zones" "available" {
  state = "available"
}

# Latest Ubuntu 22.04 LTS (Jammy) HVM SSD AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}
