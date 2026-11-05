#!/usr/bin/env bash
set -euo pipefail
lab="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/infra" "$tmp/scripts"
cp "$lab/infra/main.tf" "$lab/infra/desired.json" "$tmp/infra/"
cp "$lab/scripts/reconcile.sh" "$tmp/scripts/"
run() { bash "$tmp/scripts/reconcile.sh" "$@"; }
expect_drift() {
  local status=0
  run check || status=$?
  if [[ "$status" != 2 ]]; then
    echo "Mong đợi mã 2, nhận được $status" >&2
    return 1
  fi
}

run init
terraform -chdir="$tmp/infra" validate
run apply
run check
printf '{"service":"nhom-28","replicas":5,"log_level":"debug"}\n' > "$tmp/infra/runtime/service.json"
expect_drift
run apply
run check
cmp "$tmp/infra/desired.json" "$tmp/infra/runtime/service.json"

rm "$tmp/infra/runtime/service.json"
expect_drift
run apply
run check
cmp "$tmp/infra/desired.json" "$tmp/infra/runtime/service.json"
echo "PASS: phát hiện và khôi phục cả sửa nội dung lẫn xóa tệp."
