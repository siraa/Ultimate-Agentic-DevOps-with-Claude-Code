---
name: portfolio-terraform-baseline
description: Terraform stack for the portfolio site is minimal (S3 + CloudFront only, no IAM/OIDC yet) — recurring security gaps found in first full audit on 2026-07-08
metadata:
  type: project
---

The `terraform/` directory in this repo (Ultimate-Agentic-DevOps-with-Claude-Code) currently
provisions only a static-site stack: `aws_s3_bucket.website`, `aws_s3_bucket_public_access_block`,
`aws_cloudfront_origin_access_control` (OAC, not legacy OAI — done correctly), an OAC-scoped
`aws_s3_bucket_policy`, and `aws_cloudfront_distribution.website`. There is no IAM role/policy,
no OIDC trust policy, and no GitHub Actions workflow file in the repo yet, even though CLAUDE.md
describes GitHub Actions automation — so IAM/OIDC least-privilege checks are not yet applicable
and should be re-checked once a deploy workflow/role is actually added.

On the first full audit (2026-07-08) these gaps were found and are worth re-checking on every
future pass since they are easy to reintroduce when resources are re-created or copy-pasted:
- No `aws_s3_bucket_server_side_encryption_configuration` (no encryption at rest on the website bucket).
- No `aws_s3_bucket_versioning` on the website bucket.
- No access logging anywhere: neither `aws_s3_bucket_logging` nor a CloudFront `logging_config` block.
- No `aws_cloudfront_response_headers_policy` — CSP / X-Frame-Options / X-Content-Type-Options /
  HSTS are entirely unset on the distribution's `default_cache_behavior`.
- `custom_error_response` only maps 404 → /index.html; a 403 (the actual response S3 returns via
  OAC for a missing/denied object) is unmapped and leaks a raw S3 AccessDenied XML page.
- No WAFv2 Web ACL attached to the CloudFront distribution (`web_acl_id` unset).
- `variable "domain_name"` is declared in variables.tf but never referenced in main.tf — no
  `aliases` block or ACM certificate wired up, so a custom domain cannot actually be attached
  despite the variable existing. Worth asking whether this is planned/unused dead code.
- `backend.tf` ships with the S3 remote backend commented out by default, so a fresh `terraform init`
  uses local state (no encryption, no locking, risk of local `terraform.tfstate` containing
  ARNs/account ID being accidentally committed). See [[project_gitignore_leading_space_bug]] — the
  repo's `.gitignore` does not exclude `*.tfstate` either.

What is done correctly (don't flag as issues, just confirm still true each audit): public access
block has all four flags set true; bucket policy is scoped to the specific CloudFront distribution
ARN via `AWS:SourceArn` condition rather than a wildcard; OAC (not OAI) is used; `viewer_protocol_policy
= "redirect-to-https"` enforces HTTPS.

**Why:** These are the kind of gaps that don't cause `terraform plan/apply` to fail and are easy to
miss without a dedicated security pass, so they tend to persist across commits.
**How to apply:** On future audits of this repo, check first whether each of the above gaps has
been remediated before re-deriving the whole list from scratch, and prioritize IAM/OIDC review once
a `.github/workflows/` deploy pipeline actually appears in the repo.
