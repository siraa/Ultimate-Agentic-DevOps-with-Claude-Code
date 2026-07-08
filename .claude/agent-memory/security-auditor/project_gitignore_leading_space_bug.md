---
name: gitignore-leading-space-bug
description: Root .gitignore's ".terraform" entry has a leading space, so it does not actually ignore terraform/.terraform/ (confirmed via git status showing it untracked)
metadata:
  type: project
---

The root `.gitignore` in this repo contains a single entry: `" .terraform"` (note the leading
space character before the dot). Git does not strip leading whitespace from `.gitignore` patterns
(only trailing whitespace is trimmed, and only if unescaped), so this pattern only matches paths
that literally start with a space — it does not match a real `.terraform` directory. This was
confirmed live: `git status` showed `?? terraform/.terraform/` as untracked/not-ignored even
though the intent was clearly to ignore it.

The file also has no entries for `*.tfstate`, `*.tfstate.*`, `*.tfvars`, or
`.terraform.tfstate.lock.info`, which matters because `terraform/backend.tf` ships with the S3
remote backend commented out by default (see [[project_portfolio_terraform_baseline]]), so a
fresh `terraform init`/`apply` produces a local state file that could be committed by accident.

**Why:** Silent `.gitignore` bugs like a stray leading space are easy to miss in review and were
only caught by cross-checking `git status` output against the ignore file — worth calling out
explicitly as a finding rather than assuming the ignore file works as intended.
**How to apply:** Flag this on every audit until fixed: `.gitignore` should have `.terraform/`
(no leading space) plus `*.tfstate`, `*.tfstate.*`, `.terraform.tfstate.lock.info`, and `*.tfvars`
(unless tfvars are known to be non-sensitive).
