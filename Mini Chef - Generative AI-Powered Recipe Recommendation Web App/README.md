# Mini Chef - Generative AI-Powered Recipe Recommendation Web App
Mini Chef - Ứng dụng gợi ý công thức nấu ăn sử dụng Generative AI

## Giới thiệu

Mini Chef là hệ thống gợi ý công thức nấu ăn ứng dụng Generative AI, cho phép người dùng nhập các nguyên liệu hiện có để nhận đề xuất món ăn phù hợp.

Hệ thống kết hợp **Vector Search**, **LLM** và **workflow tự động bằng n8n** để tìm kiếm công thức trong cơ sở dữ liệu hoặc sinh công thức mới khi không tìm thấy kết quả phù hợp.

---

## Vai trò

**Thành viên dự án – Thiết kế Workflow AI và Logic xử lý**

Các công việc đã thực hiện:

- Thiết kế và phát triển một phần workflow trên **n8n** phục vụ quá trình gợi ý công thức.
- Xây dựng nhánh điều kiện (IF Node) để phân luồng xử lý giữa trường hợp tìm thấy và không tìm thấy công thức trong cơ sở dữ liệu.
- Xử lý và chuẩn hóa dữ liệu recipe trước khi truyền cho AI thông qua các Function Node.
- Phát triển logic tính toán nguyên liệu còn thiếu bằng JavaScript.
- Thiết kế Prompt cho nhánh AI trả lời khi tìm thấy công thức và nhánh AI sinh công thức mới.
- Xử lý và chuẩn hóa JSON trả về từ LLM để đồng bộ với giao diện người dùng.

---

## Quy trình hoạt động

### 1. Kiểm tra kết quả tìm kiếm

Workflow nhận kết quả từ node tìm kiếm công thức.

Node **IF** kiểm tra giá trị `mode`.

- `mode = found`: chuyển sang nhánh sử dụng công thức có sẵn.
- Ngược lại: chuyển sang nhánh AI tạo công thức mới.

---

### 2. Chuẩn hóa dữ liệu công thức

Node **Format Recipe Output**

- Lấy recipe đầu tiên từ workflow.
- Chuẩn hóa dữ liệu.
- Đổi trường `id` thành `recipe_id`.
- Chuẩn bị dữ liệu cho các bước tiếp theo.

---

### 3. Tính nguyên liệu còn thiếu

Node **Calculate Missing Ingredients**

So sánh:

- Nguyên liệu cần cho món ăn
- Nguyên liệu người dùng hiện có

Sau đó xác định danh sách nguyên liệu còn thiếu bằng JavaScript.

---

### 4. Sinh phản hồi bằng AI

#### Trường hợp tìm thấy công thức

AI sẽ:

- Giới thiệu tên món ăn
- Kiểm tra người dùng đã đủ nguyên liệu hay chưa
- Liệt kê các nguyên liệu còn thiếu
- Đề xuất nguyên liệu thay thế (nếu có)
- Trả về hướng dẫn nấu ăn

#### Trường hợp không tìm thấy công thức

AI tạo một công thức mới dựa trên nguyên liệu người dùng cung cấp.

---

### 5. Chuẩn hóa dữ liệu AI

Node **Clean & Parse AI JSON Response**

Thực hiện:

- Làm sạch Markdown (` ```json `)
- Parse chuỗi JSON trả về từ LLM
- Kiểm tra dữ liệu thiếu
- Bổ sung các trường mặc định
- Trả về đúng cấu trúc JSON mà giao diện Loveable sử dụng.

---

## Công nghệ sử dụng

- n8n
- JavaScript
- OpenRouter Chat Model
- Supabase
- Vector Search
- Retrieval-Augmented Generation (RAG)

---

## Cấu trúc Repository

- **Slide báo cáo**: Tóm tắt về dự án và luồng xử lý trên n8n.
- **mini chef.json**: File code xuất từ n8n.
  
---

## Demo

Website: https://yourminichef.lovable.app/

---

## Kết quả

- Xây dựng thành công workflow AI hỗ trợ gợi ý công thức nấu ăn.
- Áp dụng logic điều kiện, xử lý dữ liệu và Prompt Engineering trong n8n.
- Chuẩn hóa dữ liệu AI để tích hợp với giao diện người dùng.
