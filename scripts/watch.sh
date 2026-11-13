#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
git diff --quiet && git diff --cached --quiet || {
  echo "Hãy commit hoặc cất thay đổi mã nguồn trước khi chạy." >&2
  exit 1
}
terraform init -input=false
while true; do
  if git pull --ff-only; then
    terraform apply -input=false -auto-approve -lock-timeout=30s || echo "Apply lỗi, kiểm tra log." >&2
  else
    echo "Pull lỗi, bỏ qua apply trong chu kỳ này." >&2
  fi
  sleep 10
done
