# Build Web Yurei - Web Gacha Blindbox
Xây dựng web kinh doanh YUREI mô hình Gacha -  Blindbox

## Giới thiệu

Yurei là một dự án website Gacha Blindbox được xây dựng trong môn học với mục tiêu mô phỏng quy trình quay gacha, quản lý bộ sưu tập, giao hàng và quản lý giao dịch của người dùng.

**Tóm tắt nội dung:** Quy trình của YURĒI bắt đầu khi người dùng đăng ký tài khoản và nạp tiền để nhận Coin trong hệ thống. Coin được sử dụng để tham gia Gacha và nhận các Figure thuộc các Collection đang phát hành. Sau mỗi lượt Roll, Figure sẽ được lưu trữ trong Inventory và trở thành tài sản của người dùng trong hệ sinh thái YURĒI. Tại đây, người dùng có thể tiếp tục sưu tầm, thực hiện Exchange để quy đổi thành Coin hoặc tạo đơn hàng để nhận sản phẩm vật lý.
Khi người dùng lựa chọn nhận Figure vật lý, hệ thống cho phép tạo đơn hàng trực tiếp từ Inventory, nhập thông tin giao hàng và thanh toán phí vận chuyển thông qua VNPay. Sau khi thanh toán thành công, doanh nghiệp tiến hành đóng gói và giao sản phẩm đến người nhận. Nhờ cơ chế Coin - Gacha - Inventory - Exchange/Order, YURĒI hình thành một vòng tuần hoàn khép kín, trong đó doanh nghiệp tạo doanh thu từ hoạt động bán Coin, còn người dùng nhận được cả trải nghiệm giải trí của Gacha và giá trị sở hữu của các Figure vật lý.

Repository này tập trung lưu trữ các tài liệu phân tích hệ thống và thiết kế giao diện mà tôi trực tiếp thực hiện trong dự án.

---

## Vai trò của tôi

### Phân tích nghiệp vụ
- Thiết kế BPMN cho quy trình **Đăng ký tài khoản** và **Khôi phục tài khoản**.
- Thiết kế **Use Case Diagram** cho phía Admin.
- Thiết kế **Entity Relationship Diagram (ERD)** cho hệ thống.

### Thiết kế giao diện (Figma)
Thiết kế prototype và UI cho các màn hình:
- Inventory
- Order History
- Request Return
- Wallet (Balance, Top-up, History Transaction)

### Front-end
Tham gia phát triển giao diện cho:
- Order History
- Order Detail
- Request Return

---

## Cấu trúc Repository

```
Build Web Yurei - Web Gacha Blindbox
│
├── BPMN Đăng kí & Khôi phục tài khoản.png
├── Use Case Admin.png
├── ERD.png
├── Đặc tả Use Case Admin.pdf
└── UI Web
```

Trong đó:
- **BPMN Đăng kí & Khôi phục tài khoản.png:** Quy trình Đăng ký và Khôi phục tài khoản.
- **Use Case Admin.png:** Chức năng của Admin.
- **ERD.png:** Mô hình dữ liệu của hệ thống.
- **Đặc tả Use Case Admin.pdf**: Bảng đặc tả Use Case Admin
- **UI Web:** Các màn hình UI được thiết kế bằng Figma.

---

## Prototype

Bạn có thể xem prototype đầy đủ của dự án tại:

🔗 https://www.figma.com/design/nIomo6tGEEc7xmOvrp4TGD/Untitled?node-id=1-277&t=kKY9TtyXUXQcpcNh-1
