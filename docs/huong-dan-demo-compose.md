# Demo Compose của Huỳnh Phát Huy
MSSV 087205004396. Nhóm 28. Giảng viên TS. Lê Quốc Tuấn.

## Chuẩn bị
Cài Git và Terraform. Clone repo, chuyển vào thư mục repo rồi chạy:
```bash
terraform init
terraform validate
terraform apply
```
Tệp main.tf hiện đặt replicas bằng 5. Để diễn tập 3 lên 5, commit cấu hình 3 lên nhánh thực hành trước khi chạy tác nhân.

## Khởi chạy tác nhân
Trên macOS:
```bash
bash scripts/watch.sh
```
Trên PowerShell Windows:
```powershell
.\scripts\watch.ps1
```
Script kéo nhánh đang theo dõi, apply khi pull thành công rồi chờ 10 giây. Ctrl+C dừng vòng lặp. Giữ state trên cùng máy.

## Thực hành
1. Sửa replicas trong main.tf trên GitHub và commit. Quan sát đầu ra docker-compose.yml cập nhật.
2. Giữ main.tf ở 5, sửa docker-compose.yml về 1. Quan sát Terraform khôi phục 5.
3. Chụp log apply và nội dung tệp làm bằng chứng.

Tài nguyên demo là tệp cấu hình. Cần chạy và kiểm tra container riêng nếu muốn chứng minh số replica thực tế. Cổng host 8080 cố định cần điều chỉnh khi mở rộng nhiều container trên cùng host.

## Phản biện
IaC cung cấp mã khai báo. GitOps bổ sung nguồn cấu hình Git cùng tác nhân đối soát.
Terraform đọc tài nguyên qua provider và lập kế hoạch dựa trên mã cùng state.
Chỉ quy lỗi cho Smart App Control khi có bằng chứng trên máy Windows.
