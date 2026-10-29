

### 3 — Deploy

Open **Actions → Terraform Apply + Ansible Provision → Run workflow**.

The workflow runs two sequential jobs:

| Job | What happens |
|-----|-------------|
| **Terraform Apply** | Provisions VPC, subnets, SGs, IAM roles, EC2 instances |
| **Ansible Provision** | Waits for SSH, runs all 4 playbook phases, prints cluster access info |

The four Ansible phases:

| Phase | Hosts | What happens |
|-------|-------|-------------|
| 1 | all nodes | Swap off, kernel params, containerd, kubeadm/kubelet/kubectl |
| 2 | control-plane | `kubeadm init`, Calico CNI, join-command captured |
| 3 | workers | `kubeadm join` |
| 4 | control-plane | nginx Deployment + NodePort Service deployed to `demo` namespace |

### 4 — Verify

When the workflow completes, the last step prints:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Cluster is ready!
 SSH:       ssh -i <key> ubuntu@<ip>
 kubectl:   ssh ubuntu@<ip> kubectl get nodes
 nginx:     http://<ip>:30080
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 5 — Teardown

**Actions → Terraform Destroy → Run workflow**, type `destroy` to confirm.

---

## PR Workflow

Every pull request targeting `main` triggers:

1. `terraform fmt -check`
2. `terraform validate`
3. `terraform plan` — output posted as a PR comment (old comments replaced)
4. `tfsec` security scan — annotates the PR with findings (soft-fail)
5. `TFLint` best-practices check

---

## Project Structure

```
.
├── terraform/
│   ├── providers.tf          # S3 backend, AWS provider
│   ├── variables.tf          # All input variables
│   ├── locals.tf             # Computed locals, AMI data source
│   ├── vpc.tf                # VPC, subnets, IGW, NAT GW, route tables
│   ├── security_groups.tf    # SGs for control-plane and workers
│   ├── iam.tf                # Instance profiles + policies
│   ├── ec2.tf                # control-plane + worker instances
│   ├── outputs.tf            # IPs, IDs, inventory snippet
│   ├── templates/
│   │   └── userdata.sh.tpl   # cloud-init (hostname + SSM agent)
│   └── terraform.tfvars.example
│
└── ansible/
    ├── ansible.cfg
    ├── requirements.yml       # Galaxy collections (amazon.aws, kubernetes.core)
    ├── site.yml               # Master playbook
    ├── inventory/
    │   └── aws_ec2.yml        # Dynamic EC2 inventory
    ├── group_vars/
    │   ├── all.yml            # Kubernetes version, CNI, CIDRs
    │   ├── control_plane.yml
    │   └── worker.yml
    └── roles/
        ├── common/            # swap, kernel, containerd, k8s packages
        ├── control_plane/     # kubeadm init, CNI, join-command
        ├── worker/            # kubeadm join
        └── sample_workload/   # nginx Deployment + NodePort Service
```

---

## Customisation

### Change the worker count

Update the `TF_VAR_WORKER_COUNT` GitHub Variable (Settings → Secrets and variables → Actions → Variables).

### Change the Kubernetes version

```yaml
# ansible/group_vars/all.yml
kubernetes_version: "1.30"
kubernetes_apt_version: "1.30.0-1.1"
```

### Switch from Calico to Flannel

```yaml
# ansible/group_vars/all.yml
cni_plugin: "flannel"
pod_network_cidr: "10.244.0.0/16"
```

Then add the Flannel manifest URL to `all.yml` and a corresponding task in the `control_plane` role.

---



> Workers are in private subnets — outbound traffic routes through NAT Gateway.
> The NAT GW incurs cost even when idle. Run **Terraform Destroy** when not in use.

---

## Conventional Commits & Releases

This repo uses [semantic-release](https://semantic-release.gitbook.io/semantic-release/). Commit messages must follow the [Conventional Commits](https://www.conventionalcommits.org/) spec to trigger automated GitHub releases.
