$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")
git diff --quiet
if ($LASTEXITCODE -ne 0) { throw "Hãy commit hoặc cất thay đổi mã nguồn." }
git diff --cached --quiet
if ($LASTEXITCODE -ne 0) { throw "Hãy commit hoặc cất thay đổi đã stage." }
terraform init -input=false
if ($LASTEXITCODE -ne 0) { throw "Terraform init thất bại." }
while ($true) {
    git pull --ff-only
    if ($LASTEXITCODE -eq 0) {
        terraform apply -input=false -auto-approve -lock-timeout=30s
        if ($LASTEXITCODE -ne 0) { Write-Warning "Apply lỗi, kiểm tra log." }
    } else {
        Write-Warning "Pull lỗi, bỏ qua apply trong chu kỳ này."
    }
    Start-Sleep -Seconds 10
}
