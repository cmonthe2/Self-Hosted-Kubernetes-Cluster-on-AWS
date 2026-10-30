# Changelog

All notable changes to this project will be documented in this file.

## [1.0.8](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/compare/v1.0.7...v1.0.8) (2026-10-30)

### 🐛 Bug Fixes

* allow IP protocol 4 for Calico IP-in-IP overlay (cross-node networking) ([e3ad77f](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/commit/e3ad77ff8172c8601e243f2e324240ec82af5057))

## [1.0.7](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/compare/v1.0.6...v1.0.7) (2026-10-30)

### 🐛 Bug Fixes

* allow SSH from within VPC so control-plane can jump to workers ([83bb4ac](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/commit/83bb4ac996b1eb4adb3339e9719f98a461c20cfe))

## [1.0.6](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/compare/v1.0.5...v1.0.6) (2026-10-30)

### 🐛 Bug Fixes

* scope join_command var to all, robust worker proxycommand, safe compose ([a00d6bf](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/commit/a00d6bf85d71ca478f9eb0b0f87454be295e63f8))

## [1.0.5](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/compare/v1.0.4...v1.0.5) (2026-10-30)

### 🐛 Bug Fixes

* kubectl-based workload deploy, restore Name hostnames, add inventory debug ([91c34b1](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/commit/91c34b1c3b3cddb8d2e0286c7db2abca9775d12a))

## [1.0.4](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/compare/v1.0.3...v1.0.4) (2026-10-30)

### 🐛 Bug Fixes

* containerd version pin, worker proxyjump via IP hostnames ([5e738e5](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/commit/5e738e56ab2be8d16aef237f89b603e21ce746c4))

## [1.0.3](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/compare/v1.0.2...v1.0.3) (2026-10-30)

### 🐛 Bug Fixes

* replace removed yaml callback with result_format, update ec2_tags ([9380c69](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/commit/9380c694402950e1fa8d59420c2deccd365d1038))
* replace removed yaml callback with result_format, update ec2_tags ([d06ab96](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/commit/d06ab96ab9cba752d04e41bf39ed509eb7226393))
* replace removed yaml callback with result_format, update ec2_tags ([c1b9810](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/commit/c1b981003424cb1a1267be3795005e45eec24609))

## [1.0.2](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/compare/v1.0.1...v1.0.2) (2026-10-30)

### 🐛 Bug Fixes

* pass explicit inventory path and ANSIBLE_CONFIG to ansible-playbook ([7c8435f](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/commit/7c8435f4802cfaf1f24664a481b0fadd7857500c))

## [1.0.1](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/compare/v1.0.0...v1.0.1) (2026-10-30)

### 🐛 Bug Fixes

* handle None public_ip_address in dynamic inventory compose ([42a5a04](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/commit/42a5a04a858d38f8bc7753c5a1a950bb3a53c1d8))

## 1.0.0 (2026-10-29)

### 🐛 Bug Fixes

* install terraform-docs binary in pre-commit CI job ([6ba7d75](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/commit/6ba7d7550a0c0e24e39b10f0f88ebdc4ab26c356))
* install terraform-docs binary in pre-commit CI job ([f0bc8c2](https://github.com/cmonthe2/Self-Hosted-Kubernetes-Cluster-on-AWS/commit/f0bc8c25254e3470c7a1227667aa3c72268e00c0))
