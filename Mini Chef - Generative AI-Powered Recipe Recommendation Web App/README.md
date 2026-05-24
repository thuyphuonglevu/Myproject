# Mini Chef – AI Recipe Recommendation System

## Tổng quan
Mini Chef là hệ thống gợi ý công thức nấu ăn bằng AI dựa trên nguyên liệu người dùng cung cấp. Hệ thống sử dụng semantic search, vector embedding và workflow automation để tìm hoặc tạo recipe phù hợp theo thời gian thực.

---

## Mục tiêu
- Đề xuất công thức phù hợp với nguyên liệu người dùng có sẵn
- Tìm kiếm recipe bằng vector similarity search
- Generate recipe mới nếu không tìm thấy kết quả phù hợp
- Chuẩn hóa output JSON để tích hợp frontend

---

## Công nghệ sử dụng
- n8n
- HuggingFace Embeddings
- OpenRouter API
- Qwen 2.5 72B Instruct
- Supabase
- pgvector
- JavaScript
- REST API

---

## Kiến trúc hệ thống

### 1. User Input Processing
- User nhập nguyên liệu từ frontend
- Webhook nhận request và kích hoạt workflow
- Ingredients được join thành text query để embedding

### 2. Embedding & Vector Search
- Sử dụng `sentence-transformers/all-MiniLM-L6-v2`
- Generate embedding vector cho nguyên liệu người dùng
- Lưu query embedding vào Supabase Vector Store
- Thực hiện semantic search bằng pgvector

### 3. Recipe Matching Logic
- Lấy top recipe có similarity score cao nhất
- Áp dụng penalty cho recipe có quá ít nguyên liệu
- Tính score = similarity × ingredient factor
- Nếu score < threshold → AI generate recipe mới

### 4. AI Recipe Adaptation
- So sánh nguyên liệu người dùng với recipe gốc
- Tính toán nguyên liệu còn thiếu
- Gợi ý substitution phù hợp nếu có
- Rewrite cooking steps theo nguyên liệu hiện có

### 5. Response Formatting
- Chuẩn hóa output JSON từ LLM
- Parse và validate response structure
- Trả dữ liệu trực tiếp về frontend qua webhook response

---

## Workflow Pipeline

```bash
Webhook
   ↓
Join Ingredients
   ↓
Generate Embedding
   ↓
Supabase Vector Search
   ↓
Pick Best Recipe Match
   ↓
 ┌───────────────┬────────────────┐
 │               │                │
Found Recipe   Low Similarity   No Match
 │               │                │
 ↓               ↓                ↓
Adapt Recipe   Generate Recipe   Generate Recipe
 │               │                │
 └──────→ JSON Response ←────────┘
```

---

## Chức năng chính
- Gợi ý công thức nấu ăn dựa trên ngữ nghĩa
- Tạo công thức nấu ăn bằng AI
- Tìm kiếm bằng độ tương đồng vector
- Phát hiện nguyên liệu còn thiếu
- Đề xuất nguyên liệu thay thế
- Điều chỉnh các bước nấu ăn theo nguyên liệu hiện có
- Chuẩn hóa đầu ra JSON có cấu trúc

---

## Logic xử lý nổi bật

### Recipe Selection Logic
- Chọn recipe có similarity score cao nhất
- Penalize recipe có ít ingredient để tránh kết quả quá đơn giản
- Randomization giúp tăng tính đa dạng recommendation

### Ingredient Matching
- Normalize ingredient format trước khi so sánh
- So sánh user ingredients với recipe ingredients
- Tự động xác định missing ingredients

### AI Response Control
- Sử dụng strict JSON-only prompting
- Validate và clean AI output trước khi trả về frontend
- Đảm bảo response luôn đúng schema yêu cầu

---

## Vai trò trong dự án
**Project Member – Workflow Logic & AI System Integration**

- Tham gia thiết kế luồng xử lý end-to-end cho hệ thống recommendation
- Xây dựng workflow automation bằng n8n kết hợp semantic search và AI generation
- Phát triển logic recipe matching dựa trên vector similarity score
- Xây dựng pipeline xử lý và chuẩn hóa AI JSON response
- Tối ưu output formatting và trải nghiệm hiển thị kết quả

---

## Kết quả
- Xây dựng hệ thống semantic recipe recommendation theo thời gian thực
- Tối ưu workflow AI generation và vector retrieval
- Tăng độ chính xác recommendation bằng similarity scoring logic
- Chuẩn hóa output phục vụ frontend integration và user experience
