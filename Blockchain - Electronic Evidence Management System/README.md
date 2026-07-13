# Ứng dụng Blockchain trong quản lý chứng cứ điện tử (Evidence Chain of Custody)

Dự án xây dựng hệ thống quản lý chứng cứ điện tử (Evidence Chain of Custody - CoC) ứng dụng công nghệ Blockchain nhằm đảm bảo tính toàn vẹn, tính bất biến và khả năng truy vết của chứng cứ trong toàn bộ quá trình xử lý vụ án.

Hệ thống kết hợp Blockchain, IPFS và Supabase theo mô hình On-chain/Off-chain để vừa đảm bảo tính minh bạch của dữ liệu quan trọng, vừa tối ưu khả năng lưu trữ và quản lý thông tin.

---

## Mục tiêu dự án

- Quản lý vòng đời của vụ án và chứng cứ điện tử.
- Đảm bảo chứng cứ không thể bị chỉnh sửa sau khi ghi nhận.
- Ghi lại toàn bộ lịch sử xử lý (Chain of Custody) trên Blockchain.
- Phân quyền người dùng theo từng vai trò trong quy trình xử lý chứng cứ.
- Hỗ trợ xác thực tính hợp pháp của chứng cứ thông qua SHA-256 Hash.

---

## Kiến trúc hệ thống

Hệ thống được xây dựng theo mô hình kết hợp:

- **Blockchain:** lưu trữ thông tin vụ án, chứng cứ và lịch sử Chain of Custody.
- **IPFS:** lưu trữ tệp chứng cứ.
- **Supabase:** quản lý thông tin người dùng và trạng thái tài khoản.
- **MetaMask:** xác thực và ký giao dịch Blockchain.

---

## Chức năng chính

- Đăng ký và quản lý tài khoản theo từng vai trò.
- Tạo vụ án.
- Upload chứng cứ lên IPFS và Blockchain.
- Xem xét, xác thực hoặc từ chối chứng cứ.
- Lưu trữ chứng cứ và đóng vụ án.
- Xác thực công khai tính hợp pháp của chứng cứ.
- Tra cứu danh sách vụ án và chứng cứ.

---

## Vai trò của tôi

**Thành viên dự án – Phân tích hệ thống & Phát triển Smart Contract**

- Thiết kế mô hình dữ liệu gồm **ERD**, **Data Flow** và kiến trúc **On-chain/Off-chain** kết hợp Blockchain, IPFS và Supabase.
- Tham gia phát triển **Smart Contract** và xây dựng giao diện web tích hợp Blockchain cho các chức năng tạo vụ án, tải lên chứng cứ, xác thực chứng cứ và quản lý dữ liệu thông qua MetaMask.
- Tham gia thảo luận, góp ý hoàn thiện cơ chế phân quyền và luồng xử lý nghiệp vụ của hệ thống.
- Phối hợp kiểm thử và đề xuất cải tiến trải nghiệm người dùng như:
  - Tự động tạo SHA-256 Hash.
  - Tự động sinh Evidence ID.
  - Tìm kiếm chứng cứ theo Case ID.
  - Xác thực chứng cứ trực tiếp từ tệp thay vì nhập Hash thủ công.

---

## Cấu trúc Repository

- **Slide báo cáo**: Chứa ERD, Data Flow và hình ảnh giao diện hệ thống
- **EvidenceCoC_realfinal.sol**: Mã nguồn Smart Contract chính của hệ thống, triển khai trên Remix Ethereum

---

## Demo

🌐 Website:

https://evidence-coc.vercel.app/

---

## Công nghệ sử dụng

- Solidity
- Ethereum
- Smart Contract
- IPFS
- Supabase
- MetaMask
