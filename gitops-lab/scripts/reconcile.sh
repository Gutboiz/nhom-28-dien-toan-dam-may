#!/usr/bin/env bash
set -euo pipefail
infra="$(cd "$(dirname "${BASH_SOURCE[0]}")/../infra" && pwd)"
tf() { terraform -chdir="$infra" "$@"; }

case "${1:-}" in
  init) tf init -input=false ;;
  apply)
    tf plan -input=false -lock-timeout=30s -out=reconcile.tfplan
    tf apply -input=false -lock-timeout=30s reconcile.tfplan
    ;;
  check)
    rc=0
    tf plan -input=false -lock-timeout=30s -detailed-exitcode || rc=$?
    case "$rc" in
      0) echo "OK: cấu hình đang khớp." ;;
      2) echo "DIFF: có thay đổi cần đối soát với Git." >&2 ;;
      *) echo "ERROR: Terraform không lập được kế hoạch." >&2 ;;
    esac
    exit "$rc"
    ;;
  *) echo "Cách dùng: bash $0 {init|apply|check}" >&2; exit 64 ;;
esac
