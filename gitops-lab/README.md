# Nhóm 28 — Quản lý hạ tầng bằng mã và GitOps với phát hiện sai lệch cấu hình

Git lưu cấu hình mong muốn trong `infra/desired.json`. Terraform dùng cấu hình đó để tạo `infra/runtime/service.json`, tệp mô phỏng cấu hình đang chạy của dịch vụ. Demo không cần tài khoản cloud và không triển khai dịch vụ thật.

## Quy trình

1. Tạo nhánh Git và sửa cấu hình mong muốn, ví dụ đổi `replicas` từ 2 thành 3.
2. Mở pull request. GitHub Actions chạy demo để kiểm tra cấu hình và khả năng phát hiện, khôi phục sai lệch.
3. Sau khi hợp nhất, trên máy giữ môi trường demo, đồng bộ nhánh chính rồi chạy `bash gitops-lab/scripts/reconcile.sh apply`. Terraform lập kế hoạch rồi áp dụng kế hoạch đó.
4. Kiểm tra bằng `bash gitops-lab/scripts/reconcile.sh check` trên cùng máy và cùng Terraform state. Mã 0 nghĩa là đã khớp, 2 nghĩa là kế hoạch có thay đổi, 1 nghĩa là lỗi Terraform.
5. Nếu có sai lệch ngoài Git, xem kế hoạch và chạy lại `apply` từ commit đã duyệt để khôi phục. Nếu thay đổi bên ngoài là chủ ý, đưa cấu hình mới vào Git qua pull request trước khi áp dụng.

Mã 2 cũng có thể xuất hiện khi chưa triển khai lần đầu hoặc vừa cập nhật cấu hình trong Git. Để minh họa drift, triển khai trước, giữ nguyên commit và chỉ sửa tài nguyên đang chạy.

## Thực hành

Cần Bash, Terraform 1.6 trở lên (dưới 2.0) và kết nối tải provider khi chạy init. Chạy từ thư mục gốc repo:

```bash
bash gitops-lab/scripts/reconcile.sh init
bash gitops-lab/scripts/reconcile.sh apply
bash gitops-lab/scripts/reconcile.sh check
printf '{"service":"nhom-28","replicas":5,"log_level":"debug"}\n' > gitops-lab/infra/runtime/service.json
bash gitops-lab/scripts/reconcile.sh check
echo $?  # 2
bash gitops-lab/scripts/reconcile.sh apply
bash gitops-lab/scripts/reconcile.sh check
cat gitops-lab/infra/runtime/service.json  # replicas trở về 2
```

Để chạy toàn bộ kịch bản trong thư mục tạm, kể cả tình huống xóa tệp:

```bash
bash gitops-lab/scripts/demo.sh
```

GitHub Actions kiểm tra trên môi trường tạm; nó không quan sát máy cá nhân. Demo đối soát theo lệnh, chưa có bộ điều khiển liên tục. Nếu mở rộng sang cloud, dùng state dùng chung có khóa, danh tính chỉ cấp quyền cần thiết và tác vụ kiểm tra định kỳ trên môi trường thực.

Tham khảo: [Terraform plan và mã thoát](https://developer.hashicorp.com/terraform/cli/commands/plan).
