# Real Estate Price in Ho Chi Minh City
Phân tích và xây dựng mô hình dự báo giá bất động sản tại khu vực Thành phố Hồ Chí Minh

## Giới thiệu

Đây là dự án xây dựng mô hình Machine Learning nhằm dự đoán giá bất động sản theo mét vuông tại TP. Hồ Chí Minh dựa trên dữ liệu rao bán nhà đất.

Dự án tập trung vào việc xây dựng pipeline Feature Engineering, xử lý dữ liệu, tối ưu mô hình và phân tích khả năng giải thích (Explainable AI) để nâng cao độ chính xác và khả năng tổng quát hóa của mô hình.

---

## Vai trò của tôi

- Xây dựng pipeline Feature Engineering với hơn 30 đặc trưng mới từ dữ liệu thời gian, vị trí, tiện ích và các đặc trưng tương tác.
- Áp dụng Log Transformation, K-Fold Target Encoding và Interaction Features nhằm cải thiện khả năng tổng quát hóa của mô hình.
- Tham gia đánh giá và tối ưu các mô hình LightGBM, XGBoost và CatBoost bằng 5-Fold Cross Validation.
- Tham gia xây dựng mô hình Weighted Ensemble.
- Phân tích khả năng giải thích của mô hình bằng SHAP (Feature Importance, Dependence Plot và Waterfall Plot).

---

## Kết quả

| Metric | Value |
|--------|------:|
| R² | **0.9017** |
| MAE | **10.32 triệu VNĐ/m²** |
| MdAPE | **5.90%** |
| Overfitting Gap | **0.0077** |

Mô hình đạt khả năng tổng quát hóa tốt trên tập kiểm tra với khoảng cách rất nhỏ giữa Cross Validation và Test.

---

## Kỹ thuật sử dụng

- Python
- Pandas
- NumPy
- Scikit-learn
- LightGBM
- XGBoost
- CatBoost
- SHAP

---

## Nội dung Repository

```
Data
EDA
Feature Engineering
Training
Evaluation
Models
```

---

## Cấu trúc thư mục
- Crawler.py: file code crawl data từ trang batdongsan.com
- KT_EDA.ipynb: file code và kết quả EDA
- data_final_processed.zip: file data sau khi loại bỏ outlier
- KT_code_model.ipynb: file code và kết quả mô hình dự báo giá bất động sản
- K234161858_VuLePhuongThuy_BaoCaoKienTap: file báo cáo tổng cho đồ án, phần tôi làm nằm từ trang 92 --> 120 và toàn bộ phần 3 (trang 129 --> 141)

---

## Hướng phát triển
- Sử dụng thêm trường description và title cho mô hình dự báo
- Tích hợp thêm dữ liệu thị trường theo thời gian thực
- Xây dựng dashboard trực quan hóa dữ liệu
