# 🎮 Vẽ Bóng Trên Màn Hình Bitmap - RARS Project

## 📝 Đề Bài

Viết chương trình vẽ một quả bóng hình tròn di chuyển trên màn hình mô phỏng **Bitmap Display** của **RARS**.

### 🎯 Yêu Cầu:

- Thiết lập màn hình kích thước `512x512` pixel, mỗi pixel có kích thước `1x1`.
- Điều khiển bóng bằng bàn phím với **Keyboard and Display MMIO Simulator**:
  - `W`: Di chuyển lên
  - `S`: Di chuyển xuống
  - `A`: Di chuyển sang trái
  - `D`: Di chuyển sang phải
  - `Z`: Tăng tốc độ
  - `X`: Giảm tốc độ
- Bóng bắt đầu tại vị trí **chính giữa màn hình**.
- Khi bóng chạm cạnh màn hình, bóng sẽ **bật ngược lại**.
- Mỗi lần di chuyển, cần **xóa bóng ở vị trí cũ** và **vẽ lại tại vị trí mới** (xóa = vẽ lại bằng màu nền).

---

## 🧠 Mục Tiêu Tổng Quát

1. **Vẽ quả bóng tròn** trên màn hình Bitmap.
   - _(Mở rộng)_: Cho phép tùy chỉnh **độ dày đường viền**.
2. **Bóng di chuyển** theo hướng do người dùng điều khiển (`W`, `A`, `S`, `D`).
3. **Xử lý va chạm**: Khi chạm vào cạnh tường, bóng tự động **đổi hướng di chuyển**.
4. **Chức năng điều chỉnh nâng cao**:
   - `Z / X`: Tăng / Giảm tốc độ di chuyển
   - `Q / E`: Giảm / Tăng kích thước bóng _(mở rộng)_
   - `R / T`: Giảm / Tăng độ dày viền _(mở rộng)_
   - `Space`: **Tạm dừng / tiếp tục** chuyển động của bóng _(mở rộng)_

---

## 🛠️ Công Nghệ Sử Dụng

- **Ngôn ngữ**: Assembly RISC-V
- **Môi trường giả lập**: [RARS](https://github.com/TheThirdOne/rars)
  - Bitmap Display plugin
  - Keyboard and Display MMIO Simulator plugin

---

## ▶️ Hướng Dẫn Chạy Chương Trình

1. Mở RARS.
2. Bật các plugin sau:
   - `Bitmap Display`
   - `Keyboard and Display MMIO Simulator`
3. Cấu hình Bitmap Display:
   - Kích thước: `512x512`
   - Pixel Size: `1x1`
4. Chạy chương trình.
5. Dùng các phím `W`, `A`, `S`, `D`, `Z`, `X`, `Q`, `E`, `R`, `T`, `Space` để điều khiển.

---

## 📌 Ghi Chú

- Đảm bảo bật `Keyboard MMIO` trước khi chạy để các phím có hiệu lực.
- Tăng / giảm tốc độ là điều chỉnh số chu kỳ chờ giữa mỗi lần di chuyển.
- Khi kích thước bóng thay đổi, va chạm sẽ được tính theo kích thước mới.

---

## 👨‍💻 Tác Giả

- **Tên**: Hieu7825
- **Dự án học phần**: Thực hành Kiến trúc Máy tính - Học kỳ 2, 2024
