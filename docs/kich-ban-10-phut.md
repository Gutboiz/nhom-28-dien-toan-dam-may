# Kịch bản thuyết trình 10 phút

## Đề tài và phạm vi demo

Nhóm 28 trình bày quản lý hạ tầng bằng mã và GitOps với phát hiện sai lệch cấu hình. Terraform sinh tệp docker-compose.yml từ main.tf. Tài nguyên được kiểm chứng trong bài là tệp cấu hình triển khai trên máy.

## Bài toán sai lệch cấu hình

Khi quản trị viên sửa trực tiếp môi trường, cấu hình thực tế có thể lệch khỏi thiết kế trong Git. Nhóm xây dựng quy trình khai báo, đối soát và khôi phục để thay đổi có thể truy vết. Mục tiêu kiểm chứng là thay đổi qua Git được áp dụng và sửa tệp ngoài Git được phát hiện.

## IaC và GitOps

IaC biểu diễn tài nguyên bằng mã. GitOps bổ sung Git làm nguồn cấu hình mong muốn cùng tác nhân kéo cấu hình và thực hiện đối soát lặp lại. Trong bài, tác nhân là script chạy trên máy demo. Một lệnh apply riêng lẻ thể hiện IaC. Vòng lặp lấy commit mới và apply thể hiện cách vận dụng GitOps.

## Vai trò của Terraform state

Terraform đọc cấu hình, state và tài nguyên qua provider khi lập kế hoạch. State giữ thông tin ánh xạ tài nguyên đã quản lý. Provider local đọc lại tệp trên đĩa. Nếu nội dung tệp bị thay đổi hoặc tệp bị xóa, Terraform có thể lập kế hoạch tạo lại tệp từ cấu hình. Mã thoát 2 của plan detailed-exitcode chỉ cho biết có thay đổi trong kế hoạch, cần bối cảnh để kết luận drift.

## Thiết lập cấu hình chuẩn

Mở main.tf và chỉ vào resource local_file.web_infra. filename trỏ tới docker-compose.yml. content chứa dịch vụ nginx và deploy.replicas. Phiên bản nhận từ nhóm hiện đặt 5. Để diễn tập thay đổi từ 3 lên 5, chuẩn bị một commit đặt 3 trước buổi trình bày. Chạy init, validate và apply để tạo trạng thái ban đầu.

## Tác nhân đồng bộ

Khởi chạy scripts/watch.sh trên macOS hoặc scripts/watch.ps1 trên Windows. Script dùng git pull --ff-only và chỉ apply khi pull thành công. Sau mỗi lượt, script chờ 10 giây. Thời gian phản hồi gồm thời gian chờ cùng thời gian Git và Terraform thực thi. Ctrl C dừng tác nhân. Demo sử dụng auto-approve trong môi trường thực hành.

## Demo cập nhật qua Git

Trên GitHub sửa replicas từ 3 lên 5 và commit vào nhánh mà máy demo đang theo dõi. Trở về Terminal quan sát pull và apply. Mở docker-compose.yml kiểm tra giá trị 5. Đối chiếu commit trên GitHub để chứng minh thay đổi có nguồn gốc rõ ràng. Việc đổi replicas trong tệp thể hiện cập nhật cấu hình triển khai.

## Demo phát hiện và phục hồi

Giữ nguyên main.tf, mở docker-compose.yml và sửa replicas từ 5 xuống 1 rồi lưu. Tác nhân chạy lại apply, provider nhận thấy tệp đã khác cấu hình và Terraform khôi phục nội dung chuẩn. Kiểm tra tệp trở về 5. Có thể dừng tác nhân để chạy plan detailed-exitcode và giải thích kế hoạch. Không sửa main.tf cục bộ trong bước gây drift.

## Kết quả và giới hạn

Demo kiểm chứng vòng đời của tệp cấu hình. Tệp compose có replicas bằng 5 chưa đủ chứng minh đang có 5 container chạy. Cổng host cố định 8080 cần được thiết kế lại nếu chạy nhiều container cùng host. Khi mở rộng sang cloud cần provider phù hợp, state dùng chung có khóa và quy trình kiểm duyệt thay đổi. Chỉ ghi nhận các kết quả có log thực nghiệm.

## Tổng kết và phản biện

Nhóm đã mô tả IaC, tác nhân GitOps và cơ chế phục hồi tệp khi có drift. Khi giảng viên hỏi vì sao dùng local, giải thích đây là cách tái hiện cơ chế trên môi trường thực hành và phân biệt phạm vi tệp với tài nguyên cloud. Nếu đề cập Smart App Control, cần có thông báo lỗi hoặc nhật ký của máy Windows. Câu hỏi về tự phục hồi được trả lời bằng việc provider đọc thực tế, plan xác định thay đổi rồi apply khôi phục.