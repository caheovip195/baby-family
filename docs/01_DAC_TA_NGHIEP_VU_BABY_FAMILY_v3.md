# BABY FAMILY — TÀI LIỆU ĐẶC TẢ NGHIỆP VỤ & THIẾT KẾ SẢN PHẨM

> **Phiên bản:** 3.0 (thay thế v2.0 Multi-Child)  
> **Ngày:** 06/10/2026  
> **Đối tượng đọc:** Product Owner • BA • UX/UI Designer • QA • Content • Vận hành/CSKH • Dev (đọc để hiểu nghiệp vụ)  
> **Tài liệu đi kèm:** `02_TAI_LIEU_KY_THUAT_BABY_FAMILY_v3.md` (kiến trúc, DB, API, Flutter, triển khai)  
> **Tagline:** *“Cùng con lớn lên — Giữ mãi yêu thương”* (EN: *Grow together. Remember forever.*)

---

## MỤC LỤC

- [0. Thông tin tài liệu & những thay đổi so với v2.0](#0-thông-tin-tài-liệu--những-thay-đổi-so-với-v20)
- [1. Tổng quan sản phẩm](#1-tổng-quan-sản-phẩm)
- [2. Thị trường mục tiêu & đặc thù gia đình Việt](#2-thị-trường-mục-tiêu--đặc-thù-gia-đình-việt)
- [3. Mô hình gia đình & thuật ngữ](#3-mô-hình-gia-đình--thuật-ngữ)
- [4. Vai trò & ma trận quyền](#4-vai-trò--ma-trận-quyền)
- [5. Gói dịch vụ: Dùng thử 3 tháng • House • Family](#5-gói-dịch-vụ-dùng-thử-3-tháng--house--family)
- [6. Hành trình người dùng tổng thể](#6-hành-trình-người-dùng-tổng-thể)
- [7. Đặc tả chức năng theo module](#7-đặc-tả-chức-năng-theo-module)
- [8. Kiến trúc thông tin & điều hướng](#8-kiến-trúc-thông-tin--điều-hướng)
- [9. Đặc tả chi tiết từng màn hình](#9-đặc-tả-chi-tiết-từng-màn-hình)
- [10. Nguyên tắc thiết kế & Design System](#10-nguyên-tắc-thiết-kế--design-system)
- [11. Giọng văn, nội dung & thông báo](#11-giọng-văn-nội-dung--thông-báo)
- [12. Quy tắc nghiệp vụ toàn cục (BR)](#12-quy-tắc-nghiệp-vụ-toàn-cục-br)
- [13. Ngoại lệ & Edge cases](#13-ngoại-lệ--edge-cases)
- [14. Use cases & Acceptance criteria](#14-use-cases--acceptance-criteria)
- [15. Chỉ số sản phẩm (KPI)](#15-chỉ-số-sản-phẩm-kpi)
- [16. Phạm vi MVP & Roadmap](#16-phạm-vi-mvp--roadmap)
- [17. Phụ lục: Catalog nội dung](#17-phụ-lục-catalog-nội-dung)
- [18. Danh sách quyết định cần PO chốt](#18-danh-sách-quyết-định-cần-po-chốt)

---

## 0. Thông tin tài liệu & những thay đổi so với v2.0

### 0.1 Cách đọc tài liệu

Mỗi tính năng được mô tả theo khung **7 câu hỏi**: *Ai dùng? — Bắt đầu từ đâu? — Muốn đạt gì? — Luồng chính? — Quy tắc nghiệp vụ? — Ngoại lệ? — Kết quả/Trạng thái?*  
Mỗi màn hình có **mã màn** (ví dụ `HOME-01`) dùng chung với tài liệu kỹ thuật (route Flutter, API) và với file thiết kế Figma. Mỗi quy tắc có mã `BR-xxx`, mỗi tiêu chí nghiệm thu có mã `AC-xxx`.

Ký hiệu phạm vi: **[MVP]** làm ở bản 1.0 • **[1.1] [1.2] [2.0]** các phase sau • **[PO]** cần Product Owner chốt.

### 0.2 Những vấn đề đã phát hiện ở v2.0 và cách xử lý trong v3.0

| # | Vấn đề ở v2.0 | Mức độ | Cách xử lý trong v3.0 |
|---|---|---|---|
| 1 | **Không có phân chia gói cụ thể**: chỉ ghi “Free / Family Pro” với các giới hạn “hợp lý”, không có giá, quota, luồng nâng/hạ cấp. | Cao | Chốt (khách hàng xác nhận): **Dùng thử miễn phí 3 tháng** khi gia đình đủ Bố + Mẹ → bắt buộc mua **House 399.000đ/năm** hoặc **Family 599.000đ/năm**. Không có gói Free vĩnh viễn. Đặc tả quota, nâng/hạ cấp, người trả tiền, hết hạn, hoàn tiền (mục 5). |
| 2 | Ông bà (Family Circle) có thể dùng ở mọi gói → không có lý do nâng cấp rõ ràng. | Cao | **Family Circle chỉ có ở gói Family.** Gói House chỉ dành cho Bố + Mẹ. Hạ gói → người thân bị *tạm dừng*, không bị xoá. |
| 3 | Hai tài liệu mâu thuẫn **state machine nhiệm vụ** (nghiệp vụ: Suggested/Accepted/Snoozed/Reassigned…; kỹ thuật: DRAFT/SCHEDULED/ACTIVE…). | Cao | Hợp nhất 1 state machine duy nhất (mục 7.13.5), dùng chung cho cả 2 tài liệu. |
| 4 | **Visibility** không thống nhất (nghiệp vụ có 5 mức gồm “Selected members”, kỹ thuật chỉ có `family/parents_only`). | Cao | Chốt 3 mức MVP: `Chỉ mình tôi` / `Bố mẹ` / `Cả nhà` (Family Circle của các bé được gắn). “Chọn người cụ thể” để phase 2.0. |
| 5 | Grant Family Circle có `child_id = null` = “toàn family” → mâu thuẫn quy tắc “chia sẻ theo từng bé” và tự động lộ bé mới sinh. | Cao | Bỏ grant cấp Family. Quyền **luôn theo từng bé / từng thai kỳ**. Khi thêm bé mới, app *gợi ý* chia sẻ, Bố/Mẹ phải xác nhận từng người. |
| 6 | Object Memory ở kỹ thuật vẫn có `child_id` (single) → mâu thuẫn N-N. | Trung bình | Memory chỉ liên kết bé qua bảng N-N. Milestone gắn **đúng 1 bé**. |
| 7 | Thứ tự onboarding mâu thuẫn (nghiệp vụ: chọn vai trò trước đăng nhập; kỹ thuật: đăng nhập trước). | Trung bình | Chốt: **Welcome → Đăng nhập → Tạo/Tham gia → Vai trò → Giai đoạn → Hồ sơ bé → Mời bạn đời**. |
| 8 | Không có **đăng nhập bằng số điện thoại** — trong khi ông bà ở VN thường không quen Gmail/Apple ID. | Cao | Thêm đăng nhập **SĐT + OTP** (SMS/Zalo ZNS), song song Apple & Google. |
| 9 | Invite TTL 24–72h quá ngắn cho ông bà. | Trung bình | Lời mời bạn đời: 7 ngày; lời mời người thân: 14 ngày; có thể gửi lại. |
| 10 | Thiếu **đặc thù văn hoá Việt**: đầy tháng, thôi nôi, âm lịch, cách xưng hô Bố/Ba/Cha – Mẹ/Má, ông bà nội/ngoại, chia sẻ qua Zalo. | Cao | Bổ sung mục 2 và catalog cột mốc VN (đầy tháng, thôi nôi, Tết đầu tiên, cắt tóc máu…), hiển thị âm lịch, nhãn xưng hô tuỳ chọn. |
| 11 | Không đề cập **ảnh nhạy cảm của bé** (ảnh tắm, cởi trần) — rủi ro lớn về an toàn trẻ em & chính sách Store. | Cao | Quy tắc gợi ý visibility “Bố mẹ” cho album tắm bé, quyền tải xuống tách riêng, không có link chia sẻ công khai, quy trình báo cáo CSAM (mục 7.24). |
| 12 | Không có **luồng duyệt ảnh do người thân đăng**. | Trung bình | Thêm tuỳ chọn “Duyệt ảnh người thân trước khi hiển thị” (mặc định BẬT). |
| 13 | Nhiều con số bỏ ngỏ: số mission/ngày, điểm Hearts, thời gian mood hết hạn, thời gian lưu Conflict, thùng rác… | Trung bình | Chốt giá trị mặc định cụ thể (cấu hình được ở Admin). |
| 14 | Không có **nhật ký** như một tính năng rõ ràng (khách hàng yêu cầu “bố mẹ ghi nhật ký”). | Cao | Tách 3 loại: *Nhật ký của bé* (chia sẻ), *Thư gửi con / Time capsule*, *Nhật ký riêng của tôi* (trong Papa & Mama). |
| 15 | Thiếu **Design System** (màu, font, radius, spacing, icon, motion, dark mode, accessibility). | Cao | Mục 10 đặc tả đầy đủ token thiết kế. |
| 16 | Danh sách màn hình chỉ ở mức khu vực, không có đặc tả từng màn. | Cao | Mục 9 đặc tả ~110 màn: thành phần, hành động, trạng thái, quyền, điều hướng. |
| 17 | v2.0 cho phép dùng app khi mới có 1 Parent, chưa rõ khi bạn đời không tham gia. | Cao | Chốt (khách hàng xác nhận): **bắt buộc chọn vai trò** sau đăng nhập; Bố/Mẹ **bắt buộc mời bạn đời**; **mọi tính năng (kể cả tạo bé) chỉ mở khi đủ Bố + Mẹ**; người thân chỉ dùng được khi được mời vào gia đình (mục 7.2, BR-050…056). |
| 18 | Firebase Dynamic Links đã ngừng hoạt động (08/2025) — tài liệu cũ chưa tính tới. | Trung bình | Link mời dùng domain riêng + Universal Links/App Links (xem tài liệu kỹ thuật). |
| 19 | Chưa nói rõ khi **hai bố mẹ cùng mua gói**, khi người trả tiền rời gia đình, khi hoàn tiền. | Trung bình | Mục 5.6 – 5.9. |
| 20 | Thiếu tính năng **Lịch tiêm/khám**? — cố ý không làm (y tế). | — | Giữ nguyên: không làm tracker y tế trong MVP; chỉ cho “Sự kiện gia đình” dạng ghi chú chung. Tăng trưởng (cân nặng/chiều cao) chỉ *ghi lại*, không đánh giá — phase 1.2. |

### 0.3 Quyết định đã được khách hàng xác nhận (06/10/2026)

| # | Quyết định | Ảnh hưởng chính |
|---|---|---|
| C-01 | Sau khi đăng nhập **bắt buộc chọn vai trò**: Bố / Mẹ / Người thân | ONB-03, BR-050 |
| C-02 | Chọn Bố → **bắt buộc mời Mẹ** (và ngược lại). Chưa có đủ Bố + Mẹ thì **không dùng được bất kỳ tính năng nào, kể cả tạo bé** | 6.1, 7.2, ONB-07, ONB-WAIT, BR-051/052 |
| C-03 | Người thân (ông bà…) cũng không dùng được gì cho tới khi được Bố/Mẹ mời vào gia đình | 6.3, CIR-WAIT, BR-053 |
| C-04 | Chỉ khi gia đình **đủ Bố + Mẹ** mới được nâng cấp gói; **Bố hoặc Mẹ** mua đều được | 5.6, BR-055 |
| C-05 | **Dùng thử miễn phí 3 tháng**; hết 3 tháng **bắt buộc** nâng cấp lên House hoặc Family | 5.2–5.4, SUB-07, BR-054/056 |
| C-06 | 2 gói: **House 399.000đ/năm** (Bố + Mẹ), **Family 599.000đ/năm** (mở rộng ông bà, người thân theo dõi bé) | 5.3 |

| C-07 | Dùng thử 3 tháng **không mời được người thân**, chỉ giới hạn **10 GB** | 5.3, 7.4, BR-007 |
| C-08 | Hết hạn → dữ liệu **giữ nguyên ~12 tháng** rồi mới xoá, **có báo trước** | 5.4, BR-036, BR-058 |
| C-09 | **Tạm thời chưa cho phép rời gia đình** (Bố/Mẹ không rời, không tách bạn đời) | 7.25.2, BR-057 |
| C-10 | Gói vẫn bán trên Store; khi gia đình tạo thành công (đủ Bố + Mẹ) hệ thống **tự động cấp 3 tháng dùng thử**; hết 3 tháng **thông báo Bố Mẹ phải nâng cấp** | 5.4, BR-054/056 |
| C-11 | Người nuôi con một mình / không dùng smartphone **không phải đối tượng mục tiêu** | 2.2, 13.1 |
| C-13 | **Nhãn mặc định của Bố/Mẹ là “Papa” và “Mama”** (mọi ngôn ngữ); khu vực riêng của hai người tên **“Papa & Mama”** | 2.3, 3.2, ONB-03, 7.27 |
| C-14 | **Nhiệm vụ = bảng nhiệm vụ hằng ngày** lấy từ thư viện định sẵn; Papa và Mama mỗi ngày **cùng số lượng** nhiệm vụ (+ việc Cùng nhau); chia tab **Của tôi / Của bạn đời / Cùng nhau**; mỗi nhiệm vụ có Hearts; **người làm tự bấm hoàn thành** | 7.13, CARE-01…06, BR-019 |
| C-15 | **Hearts của mỗi người chỉ người đó thấy**, không hiển thị cho bạn đời; Hearts của cả hai góp chung vào **Cây gia đình** | 7.14, CARE-09, BR-018 |
| C-16 | **Nhờ vả là tính năng riêng (Lời nhờ)**, không nằm trong nhiệm vụ; nhiệm vụ chỉ tự thêm cho mình hoặc Cùng nhau | 7.16.2, US-03/04, BR-020, BR-067…070 |
| C-12 | **Hệ thống phải hỗ trợ đa ngôn ngữ** (app, server, thông báo, nội dung hệ thống). Ra mắt: Tiếng Việt (mặc định) + English; thêm ngôn ngữ không cần sửa code màn hình | 7.27, 11.3, BR-060…066 |

> Lưu ý duy nhất về C-09: Apple/Google **bắt buộc** app có chức năng xoá tài khoản. Vì vậy nếu Bố hoặc Mẹ xoá tài khoản, người còn lại vẫn giữ gia đình ở trạng thái `PARTNER_LEFT` (chỉ xem & tải về, có thể mời bạn đời mới). Đây là đường thoát duy nhất, không phải tính năng “rời gia đình”.

### 0.4 Nguyên tắc giữ nguyên từ v2.0 (vẫn là “source of truth”)

1. Family = **Bố + Mẹ** (Parent Pair) + 0..N Thai kỳ + 0..N Bé. Không tạo Family theo từng bé.
2. Ông bà/người thân thuộc **Family Circle** — được chia sẻ, **không phải chủ sở hữu**, không có nhiệm vụ, không thấy Papa & Mama Space.
3. Memory gắn được **nhiều bé**, chỉ lưu 1 bản, 1 luồng bình luận.
4. Nhiệm vụ là **bảng việc hằng ngày chia đều** cho Papa / Mama / Cùng nhau, gắn **Một bé / Nhiều bé / Cả nhà / Hai vợ chồng**; nhiệm vụ không giao cho bạn đời — nhờ vả dùng **Lời nhờ**.
5. Papa & Mama Space **độc lập với bé đang chọn**.
6. Private by default, không có feed công khai, không chấm điểm “bố tốt/mẹ tốt”, AI chỉ gợi ý.

---

## 1. Tổng quan sản phẩm

### 1.1 Tầm nhìn

**Baby Family** là *không gian riêng tư của gia đình* xoay quanh em bé — từ khi mẹ mang thai đến những năm đầu đời và lâu hơn nữa. App giúp gia đình:

1. **Lưu giữ** hành trình của con (ảnh, video, nhật ký, thư, cột mốc).
2. **Cùng nhau chăm con** — biến việc chăm con từ “ai nhớ thì làm” thành phối hợp có kế hoạch qua *nhiệm vụ thực tế*.
3. **Giữ kết nối Bố – Mẹ** khi cả hai mệt mỏi vì con nhỏ.
4. **Kéo ông bà, người thân** vào hành trình của cháu một cách an toàn (gói Family).

> Luồng giá trị cốt lõi: **CẢM XÚC/HOÀN CẢNH → HÀNH ĐỘNG NHỎ → KHOẢNH KHẮC → KÝ ỨC → GẮN KẾT**  
> Ví dụ: Mẹ báo “mệt” → Mẹ gửi **lời nhờ** “tắm cho bé tối nay” → Bố nhận và chụp ảnh khi tắm → ảnh thành ký ức → Mẹ gửi lời cảm ơn → ông bà thả tim.

### 1.2 Bốn trụ cột

| Trụ cột | Giá trị | Tính năng lõi |
|---|---|---|
| 📸 **Ký ức của con** (Baby Memories) | Không đánh rơi khoảnh khắc không lặp lại | Thai kỳ, album, timeline, cột mốc, nhật ký, thư gửi con, recap, “Ngày này năm xưa” |
| 🤝 **Cùng chăm con** (Parent Care) | Chia sẻ trách nhiệm, không cần nhắc bằng lời | Bảng nhiệm vụ hằng ngày chia đều Papa/Mama/Cùng nhau, Hearts riêng góp vào Cây gia đình, lịch, nhắc, thống kê chăm con |
| 💞 **Papa & Mama** (Couple Connection) | Nói được “mình đang thế nào” trước khi căng thẳng | Check-in cảm xúc, **lời nhờ**, lời cảm ơn, nhật ký riêng, Cầu nối khi bất đồng |
| 👵 **Vòng tròn gia đình** (Family Circle) | Ông bà đồng hành mà không cần mạng xã hội | Chia sẻ theo từng cháu, bình luận/thả tim, đăng ảnh có duyệt, bản tin cho ông bà |

### 1.3 Nguyên tắc sản phẩm không được phá vỡ

| Mã | Nguyên tắc | Biểu hiện cụ thể |
|---|---|---|
| P1 | **Riêng tư mặc định** | Không có hồ sơ bé công khai, không tìm kiếm người lạ, không link công khai, không quảng cáo nhắm mục tiêu theo dữ liệu bé. |
| P2 | **Không biến chăm con thành cuộc thi** | Không leaderboard Bố vs Mẹ; điểm là của *cả gia đình*; không trừ điểm. |
| P3 | **Không tự động chia sẻ tâm sự** | Mood, nhật ký riêng, nội dung xung đột chỉ chia sẻ khi người viết bấm *Gửi*. |
| P4 | **AI chỉ hỗ trợ** | Không chẩn đoán, không phán xử đúng/sai, không tự gửi tin. App dùng tốt khi tắt AI. |
| P5 | **Không ép buộc** | Nhiệm vụ không giao cho nhau; luôn Đổi / Bỏ khỏi hôm nay được. Lời nhờ luôn có “Hôm nay không được”. Không bao giờ bị phạt. |
| P6 | **Ghi lại trong vài giây** | Tạo ký ức ≤ 3 thao tác; hoàn thành nhiệm vụ 1 chạm. |
| P7 | **Kín đáo trên màn hình khoá** | Thông báo nhạy cảm không lộ nội dung (vd. không ghi “Mẹ đang giận bạn”). |
| P8 | **Dành cho người lớn** | App cho bố mẹ/người lớn; không thiết kế như game cho trẻ; không đăng ký vào Kids Category. |
| P9 | **Không giữ ký ức làm “con tin”** | Hết hạn dùng thử/gói → app bị khoá sử dụng, nhưng ký ức **không bị xoá** và người dùng **luôn tải về được** toàn bộ dữ liệu. |
| P10 | **Không phải app y tế** | Không tư vấn y khoa, không đánh giá phát triển “nhanh/chậm”, không chẩn đoán. |

### 1.4 Ngoài phạm vi

- Mạng xã hội công khai cho trẻ em; hồ sơ bé công khai; follower.
- Tracker y tế sâu (ăn/ngủ/tã chi tiết, thuốc, lịch tiêm có khuyến nghị) — có thể là sản phẩm/phase riêng sau khi đánh giá pháp lý.
- Chấm điểm “chất lượng hôn nhân/làm cha mẹ”.
- Tài khoản cho trẻ em.
- Co-parenting sau ly hôn, gia đình tái hôn (phase riêng).

---

## 2. Thị trường mục tiêu & đặc thù gia đình Việt

### 2.1 Thị trường

- **Ra mắt:** Việt Nam (tiếng Việt mặc định, tiếng Anh đi kèm). Phát hành **App Store (iOS 15+)** và **Google Play (Android 8+)**.
- **Mở rộng:** người Việt ở nước ngoài (ông bà ở VN, con cháu ở nước ngoài → cần hỗ trợ múi giờ khác nhau).

### 2.2 Persona

| Persona | Mô tả | Nhu cầu | Nỗi đau | Tính năng ưu tiên |
|---|---|---|---|---|
| **A – Mẹ bỉm sữa (28–34t)** | Sau sinh, nghỉ thai sản, dùng Zalo/Facebook nhiều | Lưu ảnh con nhanh; được chồng chủ động phụ | Phải nhớ mọi việc; ảnh con lẫn trong Zalo | Tạo ký ức nhanh, nhiệm vụ chia đều, lời nhờ |
| **B – Bố đi làm (30–36t)** | Đi làm cả ngày, muốn tham gia nhưng không biết bắt đầu | Biết hôm nay cần làm gì; có kỷ niệm riêng với con | Bị coi là “không quan tâm”; khó nói “mình kiệt sức” | Nhiệm vụ rõ ràng, check-in, ảnh “Bố & con” |
| **C – Mẹ bầu lần đầu** | Thai 8–30 tuần | Lưu ảnh bụng, siêu âm, chuẩn bị đồ | Lo lắng, cần chồng đồng hành | Nhật ký thai kỳ, checklist chuẩn bị, thư gửi con |
| **D – Ông bà (55–70t)** | Ở quê hoặc khác thành phố, dùng điện thoại Android, quen Zalo | Xem cháu mỗi ngày | Chữ nhỏ, thao tác phức tạp, không có email | Đăng nhập SĐT, chữ lớn, bản tin cháu, thả tim |
| **E – Gia đình 2 con** | Con lớn 3t, con nhỏ 4 tháng | Không lẫn ảnh/nhiệm vụ giữa 2 bé | Quá tải, ít thời gian cho con lớn | Chuyển bé nhanh, nhiệm vụ nhiều bé, ảnh anh/chị/em |
| **F – Cặp đôi căng thẳng** | Cả hai mệt, dễ cãi nhau | Một cách trung lập để nói nhu cầu | Tranh luận khi đang mệt | Cầu nối (Conflict Bridge), viết lại câu nói nhẹ nhàng |

### 2.3 Đặc thù văn hoá cần đưa vào sản phẩm

| Đặc thù | Áp dụng vào app |
|---|---|
| **Xưng hô đa dạng**: Papa/Bố/Ba/Cha/Tía – Mama/Mẹ/Má/Mạ/U | Khi chọn vai trò, cho chọn *nhãn gọi* (mặc định **“Papa”/“Mama”**). Toàn app dùng nhãn này: “Ba có nhiệm vụ mới”. Dữ liệu nội bộ vẫn là `PARENT_A/PARENT_B` + nhãn. |
| **Ông bà nội / ngoại** | Quan hệ Family Circle có sẵn: Ông nội, Bà nội, Ông ngoại, Bà ngoại, Cô, Dì, Chú, Bác, Cậu, Mợ, Thím, Anh/chị họ, Người giúp việc/Bảo mẫu, Khác. |
| **Cột mốc truyền thống** | Catalog có: *Đầy tháng*, *Đầy 100 ngày (bách nhật)*, *Thôi nôi (1 tuổi)*, *Tết đầu tiên*, *Cắt tóc máu*, *Trung thu đầu tiên*, *Lần đầu về quê nội/ngoại*. |
| **Âm lịch** | Hồ sơ bé hiển thị ngày sinh âm lịch (tuỳ chọn); nhắc *đầy tháng/thôi nôi* theo cả âm và dương (gia đình chọn cách tính). Sự kiện có thể chọn ngày âm lịch. |
| **Zalo là kênh chính** | Chia sẻ link mời qua Zalo/Messenger/SMS (share sheet hệ thống). Đăng nhập SĐT + OTP (gửi qua Zalo ZNS/SMS). |
| **Ông bà ở xa, gửi ảnh qua nhóm chat** | Bản tin “Hôm nay cháu…” (digest) 1 lần/ngày thay vì từng thông báo. |
| **Người giúp việc/bảo mẫu chăm bé** | Vai trò “Người chăm sóc tin cậy” có thể đăng ảnh (cần duyệt), không xem Papa & Mama. |
| **Ngại nói thẳng cảm xúc** | Check-in bằng biểu tượng + câu mẫu, không bắt viết dài. |

---

## 3. Mô hình gia đình & thuật ngữ

### 3.1 Sơ đồ mô hình

```
FAMILY (Gia đình) ─────────────────────────────────────────────────────────
│
├── PARENT PAIR (Bố + Mẹ) ── tối đa 2 người, là "chủ" gia đình
│     ├── Parent A (người tạo)  – nhãn: Bố/Ba/... hoặc Mẹ/Má/...
│     └── Parent B (được mời)
│
├── BỐ & MẸ SPACE (Couple Space) ── chỉ Parent A ↔ Parent B
│     ├── Check-in cảm xúc, Lời nhờ, Lời cảm ơn
│     ├── Nhật ký riêng (của từng người)
│     ├── Nhiệm vụ hai vợ chồng
│     └── Cầu nối khi bất đồng
│
├── THAI KỲ [0..N] ── #1, #2, ... (một thai kỳ có thể sinh 1..N bé)
│
├── BÉ [0..N] ── mỗi bé: hồ sơ, timeline, cột mốc, nhiệm vụ, màu nhận diện
│
├── KÝ ỨC (Memory) [0..N] ── thuộc Family, gắn 0..N bé (N-N)
├── BẢNG NHIỆM VỤ NGÀY ── Nhiệm vụ (Mission) [0..N]: chủ = Papa / Mama / Cùng nhau; gắn 1 bé / nhiều bé / cả nhà / hai vợ chồng
├── CÂY GIA ĐÌNH (Family Hearts) ── tổng Hearts của Papa + Mama (Hearts từng người chỉ người đó thấy)
│
├── FAMILY CIRCLE (Vòng tròn gia đình) [0..12] ── CHỈ GÓI FAMILY
│     └── mỗi người: quan hệ + quyền theo TỪNG bé / thai kỳ
│
└── GÓI DỊCH VỤ (Subscription) ── gắn với Family, không gắn với từng người
```

### 3.2 Thuật ngữ (Glossary)

| Thuật ngữ (VN) | Tên kỹ thuật | Định nghĩa |
|---|---|---|
| Gia đình | Family | Đơn vị lõi do Bố + Mẹ tạo; chứa thai kỳ, bé, ký ức, nhiệm vụ, gói. |
| Bố / Mẹ | Parent (slot A/B) | Hai người quản lý gia đình. Nhãn hiển thị mặc định **Papa / Mama**, người dùng đổi được. Trong tài liệu, “Bố/Mẹ” chỉ **vai trò**; trên app hiển thị bằng nhãn gọi của từng người. |
| Bạn đời | Partner | Parent còn lại so với người đang dùng. |
| Papa & Mama Space | Couple Space | Không gian riêng của 2 Parent. |
| Vòng tròn gia đình | Family Circle | Người thân được Bố/Mẹ chia sẻ quyền xem/bình luận/đăng theo từng bé. |
| Quyền chia sẻ | Circle Grant | Quyền của 1 người thân đối với 1 bé hoặc 1 thai kỳ: Xem / Bình luận / Đóng góp. |
| Thai kỳ | Pregnancy Journey | Hành trình trước sinh, đánh số #1, #2… |
| Bé | Child | Hồ sơ một em bé đã chào đời. |
| Ký ức | Memory | Một khoảnh khắc: ảnh/video/âm thanh/chữ hoặc kết hợp. |
| Cột mốc | Milestone | “Lần đầu” hoặc dấu mốc nổi bật của **một** bé, gắn với một ký ức. |
| Nhật ký của bé | Diary entry | Ký ức dạng chữ dài (có thể kèm ảnh), viết về bé. |
| Thư gửi con | Letter | Thư Bố/Mẹ viết cho con; có thể hẹn ngày mở (Time capsule). |
| Nhật ký riêng | Private journal | Ghi chép cá nhân trong Papa & Mama Space, chỉ người viết thấy. |
| Album | Album | Bộ sưu tập ký ức do người dùng tạo (vd. “Đà Lạt 2026”). |
| Nhiệm vụ | Mission | Một việc chăm con/quan tâm bạn đời của **một Parent** hoặc **Cùng nhau**, có Hearts; người làm tự bấm hoàn thành. |
| Bảng nhiệm vụ ngày | Daily board | Bộ nhiệm vụ hệ thống bày mỗi sáng, Papa và Mama cùng số lượng. |
| Chuỗi nhiệm vụ | Mission series | Nhiệm vụ lặp lại (hằng ngày, theo thứ…). |
| Hearts / Cây gia đình | Hearts / Family tree | Điểm của từng Parent (chỉ người đó thấy), cộng chung thành Cây gia đình lớn dần. |
| Huy hiệu | Badge | Ghi nhận thói quen tích cực, chỉ mang tính trang trí. |
| Thống kê chăm con | Care stats | Thống kê mức gia đình các hoạt động *được ghi trong app*, không chia theo người. |
| Check-in | Mood check-in | Tín hiệu ngắn về cảm xúc/năng lượng. |
| Lời nhờ | Request | Việc cụ thể hoặc nhu cầu gửi bạn đời; tính năng riêng, không phải nhiệm vụ. |
| Lời cảm ơn | Appreciation | Lời ghi nhận gửi bạn đời. |
| Cầu nối | Conflict Bridge | Luồng giao tiếp có cấu trúc khi bất đồng. |
| Bé đang chọn | Child Context | Bộ lọc “Tất cả” hoặc 1 bé, áp dụng cho Trang chủ/Ký ức/Chăm con. |
| Tổng kết | Recap | Câu chuyện ngày/tuần/tháng/năm. |
| Người trả tiền | Payer | Parent đã mua gói qua Apple/Google. |

---

## 4. Vai trò & ma trận quyền

### 4.1 Danh sách vai trò

| Vai trò | Ai | Số lượng/Family | Gói |
|---|---|---|---|
| **Parent** (Bố/Mẹ) | Người tạo + bạn đời đã chấp nhận lời mời | 1–2 | Mọi gói |
| **Circle – Người xem** (Viewer) | Ông bà, người thân | 0–12 (chung) | Chỉ Family |
| **Circle – Người bình luận** (Commenter) | Như trên | | Chỉ Family |
| **Circle – Người đóng góp** (Contributor) | Người thân, bảo mẫu tin cậy | | Chỉ Family |
| **Admin nội bộ** | Nhân viên CSKH, kiểm duyệt, nội dung, billing | — | — |

> Một người thân có thể có **quyền khác nhau cho từng bé**: ví dụ Bà nội *Bình luận* với Hana nhưng *không được chia sẻ* Haru.

### 4.2 Ma trận quyền chi tiết (người dùng trong app)

Ký hiệu: ✅ được • ❌ không • 🔸 có điều kiện

| Chức năng | Parent | Circle Viewer | Circle Commenter | Circle Contributor |
|---|---|---|---|---|
| Xem hồ sơ bé được chia sẻ | ✅ mọi bé | 🔸 bé được grant | 🔸 bé được grant | 🔸 bé được grant |
| Thấy tên/sự tồn tại của bé KHÔNG được chia sẻ | ✅ | ❌ | ❌ | ❌ |
| Tạo/sửa/lưu trữ hồ sơ bé, thai kỳ | ✅ | ❌ | ❌ | ❌ |
| Xem ký ức (visibility = Cả nhà) | ✅ | 🔸 nếu gắn ≥1 bé được grant hoặc là “Khoảnh khắc gia đình” | 🔸 | 🔸 |
| Xem ký ức “Papa & Mama” | ✅ | ❌ | ❌ | ❌ |
| Xem ký ức “Chỉ mình tôi” | 🔸 chỉ người tạo | ❌ | ❌ | ❌ |
| Tạo ký ức | ✅ | ❌ | ❌ | 🔸 chỉ gắn bé được grant; có thể cần duyệt |
| Sửa ký ức | 🔸 của mình; của người khác chỉ sửa *gắn bé/visibility/ẩn* | ❌ | ❌ | 🔸 của mình (khi chưa duyệt hoặc trong 24h) |
| Xoá ký ức | 🔸 của mình; của người thân → “Gỡ khỏi gia đình” | ❌ | ❌ | 🔸 của mình |
| Thả cảm xúc (reaction) | ✅ | ✅ | ✅ | ✅ |
| Bình luận | ✅ | ❌ | ✅ | ✅ |
| Xoá bình luận | 🔸 của mình + mọi bình luận trong gia đình | ❌ | 🔸 của mình | 🔸 của mình |
| Tải ảnh/video gốc về máy | ✅ | 🔸 nếu Parent bật “Cho phép tải” | 🔸 | 🔸 |
| Tạo/xem cột mốc | ✅ tạo + xem | 🔸 xem | 🔸 xem | 🔸 xem |
| Nhiệm vụ (thêm, hoàn thành), Lời nhờ | ✅ | ❌ | ❌ | ❌ |
| Cây gia đình, huy hiệu | ✅ | 🔸 chỉ thấy cây (không chi tiết ai làm gì) — [PO] | 🔸 | 🔸 |
| Thống kê chăm con | ✅ | ❌ | ❌ | ❌ |
| Papa & Mama Space (mọi thứ) | ✅ (dữ liệu riêng của bạn đời chỉ khi được chia sẻ) | ❌ | ❌ | ❌ |
| Lịch sự kiện gia đình | ✅ | 🔸 sự kiện được đánh dấu “Mời cả nhà” | 🔸 | 🔸 |
| Mời/gỡ người thân, đổi quyền | ✅ | ❌ | ❌ | ❌ |
| Mời bạn đời | ✅ (khi còn trống slot) | ❌ | ❌ | ❌ |
| Mua/quản lý gói | ✅ | ❌ | ❌ | ❌ |
| Xuất dữ liệu gia đình | ✅ | ❌ | ❌ | ❌ |
| Báo cáo nội dung/thành viên | ✅ | ✅ | ✅ | ✅ |
| Chặn người khác | ✅ | ✅ | ✅ | ✅ |
| Rời gia đình | ❌ tạm thời không hỗ trợ (chỉ có xoá tài khoản — 7.25) | ✅ | ✅ | ✅ |
| Xoá tài khoản | ✅ | ✅ | ✅ | ✅ |

### 4.3 Quyền của Admin nội bộ

| Vai trò admin | Được làm | Không được làm |
|---|---|---|
| CSKH (Support) | Tra cứu tài khoản/gia đình theo ticket (metadata: tên, số bé, gói, trạng thái); gửi lại lời mời; xem lịch sử gói | Xem ảnh/ký ức/nội dung Papa & Mama |
| Kiểm duyệt (Moderator) | Xem **nội dung bị báo cáo** trong phạm vi case; ẩn/gỡ; cảnh báo; khoá tài khoản | Xem nội dung không bị báo cáo; xem Papa & Mama Space (trừ nội dung chính người dùng gửi kèm báo cáo) |
| Nội dung (Content) | Quản lý catalog nhiệm vụ, cột mốc, mood, câu gợi ý, huy hiệu, banner | Dữ liệu người dùng |
| Billing Ops | Xem trạng thái gói, đồng bộ lại với Store | Tạo gói “giả” không audit |
| Super Admin | Quản trị admin, cấu hình, feature flag | Mọi truy cập nội dung đều phải qua case + lý do + audit |

**Quy tắc:** mọi thao tác admin có `lý do` và ghi audit log; truy cập nội dung người dùng chỉ qua *case* (báo cáo/yêu cầu hỗ trợ có đồng ý của người dùng).

---

## 5. Gói dịch vụ: Dùng thử 3 tháng • House • Family

> ✅ **Đã được khách hàng xác nhận (06/10/2026):**
> 1. Chỉ có **2 gói trả phí**: **House 399.000đ/năm** (Bố + Mẹ) và **Family 599.000đ/năm** (Bố + Mẹ + ông bà, người thân).
> 2. **Không có gói Free vĩnh viễn.** Mỗi gia đình được **dùng thử miễn phí 3 tháng**; hết 3 tháng **bắt buộc** nâng cấp lên House hoặc Family mới tiếp tục dùng.
> 3. Chỉ được nâng cấp (mua gói) khi gia đình **đã có đủ Bố và Mẹ**; **Bố hoặc Mẹ** mua đều được.

### 5.1 Triết lý định giá

- Gói gắn với **Gia đình**: một người trả, cả nhà dùng.
- Bán **sự tiện lợi, dung lượng và mở rộng gia đình** (ông bà, người thân ở gói Family).
- Hết hạn → khoá sử dụng, nhưng **không xoá ký ức** và luôn cho **tải dữ liệu về / xoá tài khoản** (bắt buộc theo quyền dữ liệu cá nhân và chính sách Store).
- Nhánh an toàn (safety) trong Papa & Mama, báo cáo nội dung, xoá tài khoản, xuất dữ liệu **không bao giờ** bị khoá.

### 5.2 Vòng đời quyền sử dụng của một gia đình

```
Đăng nhập → chọn vai trò → (Bố/Mẹ) tạo gia đình → mời bạn đời
     │
     ▼
[CHƯA KÍCH HOẠT]  — chỉ có 1 Parent: KHÔNG dùng được tính năng nào (kể cả tạo bé)
     │  bạn đời chấp nhận lời mời
     ▼
[DÙNG THỬ 90 NGÀY]  — tự động cấp khi gia đình đủ Bố + Mẹ; tính năng như gói House, giới hạn 10 GB, chưa mời người thân
     │  mua House/Family (bất kỳ lúc nào trong 90 ngày, Bố hoặc Mẹ)          │ hết 90 ngày không mua
     ▼                                                                        ▼
[HOUSE] / [FAMILY]  ◄─────────── mua gói ────────────────────────────── [HẾT HẠN — KHOÁ]
     │  hết hạn / huỷ / hoàn tiền (sau ân hạn)                                ▲
     └────────────────────────────────────────────────────────────────────────┘
```

| Trạng thái quyền sử dụng | Khi nào | Được làm gì |
|---|---|---|
| **Chưa kích hoạt** (`INCOMPLETE`) | Gia đình mới có 1 Parent | Chỉ: xem/gửi lại/thu hồi lời mời bạn đời, sửa tên gia đình, cài đặt tài khoản, đăng xuất, xoá tài khoản. **Không** tạo bé/thai kỳ, ký ức, nhiệm vụ, mời người thân, mua gói. |
| **Dùng thử** (`TRIAL`) | 90 ngày kể từ khi đủ Bố + Mẹ | Tính năng như gói **House** (Bố + Mẹ), giới hạn **10 GB**, **không mời người thân** (5.3) |
| **House** / **Family** | Đã mua, đang hiệu lực (gồm thời gian ân hạn thanh toán của Store) | Theo gói |
| **Hết hạn** (`EXPIRED`) | Hết dùng thử mà chưa mua, hoặc gói hết hạn/huỷ/hoàn tiền | **Khoá**: màn hình bắt buộc nâng cấp (SUB-07). Chỉ được: mua gói, khôi phục giao dịch, **xuất/tải dữ liệu**, xoá tài khoản, hỗ trợ, đăng xuất. Người thân thấy “Gia đình tạm dừng” (CIR-05). Thông báo đẩy dừng (trừ thông báo về gói). |

### 5.3 Bảng tính năng & giới hạn

| Nhóm | Tính năng | **Dùng thử 3 tháng** | **House** 399.000đ/năm | **Family** 599.000đ/năm |
|---|---|---|---|---|
| Giá | | 0đ (1 lần/gia đình) | ≈ 33.000đ/tháng | ≈ 50.000đ/tháng |
| **Gia đình** | Bố + Mẹ | ✅ (bắt buộc đủ 2) | ✅ | ✅ |
| | Số bé / thai kỳ | Không giới hạn | Không giới hạn | Không giới hạn |
| | **Ông bà, người thân (Family Circle)** | ❌ | ❌ | ✅ tối đa **12 người** |
| | Quyền theo từng bé, duyệt ảnh người thân, bản tin cho ông bà | — | — | ✅ |
| **Ký ức** | Số ký ức | Không giới hạn | Không giới hạn | Không giới hạn |
| | Dung lượng | **10 GB** | **50 GB** | **200 GB** |
| | Ảnh mỗi ký ức | 30 | 30 | 50 |
| | Video | ≤ 3 phút, 1080p | ≤ 3 phút, 1080p | ≤ 10 phút, 1080p |
| | Ghi âm | ≤ 5 phút | ≤ 5 phút | ≤ 10 phút |
| | Lưu ảnh chất lượng gốc | ❌ (nén chất lượng cao) | ❌ (nén chất lượng cao) | ✅ |
| | Album, nhật ký, cột mốc, thư gửi con / time capsule | ✅ | ✅ | ✅ |
| **Chăm con** | Bảng nhiệm vụ hằng ngày, thư viện, lặp lại, Hearts, Cây gia đình, huy hiệu | ✅ | ✅ | ✅ |
| | Thống kê chăm con | ✅ | ✅ | ✅ |
| **Papa & Mama** | Check-in, lời nhờ, cảm ơn, nhật ký riêng, Cầu nối | ✅ | ✅ | ✅ |
| **AI** [1.2] | Lượt/tháng | 30 | 100 | 300 |
| **Tổng kết** | Recap tuần/tháng; chia sẻ với người thân | ✅ (không có người thân) | ✅ (không có người thân) | ✅ |
| | Year Story / Sách của con [2.0] | Xem trước | ✅ | ✅ + bản cho ông bà |
| **Dữ liệu** | Xuất ZIP, khoá ứng dụng | ✅ | ✅ | ✅ |

> Dùng thử: **không mời được người thân**, giới hạn **10 GB** (đã chốt). Muốn mời ông bà → nâng cấp gói Family ngay trong thời gian dùng thử. Mọi con số cấu hình được ở Admin.

### 5.4 Quy tắc dùng thử 3 tháng

| Quy tắc | Giá trị |
|---|---|
| Bắt đầu | Thời điểm gia đình **đủ Bố + Mẹ** (bạn đời chấp nhận lời mời và được xác nhận). Không bắt đầu khi mới đăng ký. |
| Thời lượng | **90 ngày** (hiển thị “3 tháng”), kết thúc lúc 23:59 ngày thứ 90 theo giờ gia đình. |
| Cách cấp | **Tự động** khi gia đình tạo thành công (đủ Bố + Mẹ) — hệ thống Baby Family cấp, **không cần mua trên Store, không cần nhập thẻ**. Gói House/Family vẫn bán trên Store như bình thường; người dùng có thể mua bất cứ lúc nào. |
| Mỗi gia đình | 1 lần. |
| Chống lạm dụng | Nếu **Bố hoặc Mẹ** đã từng dùng hết/đang dùng thử ở một gia đình khác (cùng tài khoản, cùng SĐT, cùng Apple/Google ID) → gia đình mới **không** được dùng thử, phải mua gói ngay sau khi đủ Bố + Mẹ. |
| Nhắc trước khi hết | Ngày 60, ngày 83 (còn 7 ngày), ngày 88 (còn 2 ngày), ngày cuối: banner + thông báo cho **cả Bố và Mẹ**: “Còn 7 ngày dùng thử. Chọn gói để tiếp tục lưu giữ hành trình của Hana.” |
| Mua trong thời gian dùng thử | Gói có hiệu lực ngay; thời gian dùng thử còn lại **không cộng dồn** (chu kỳ năm tính từ ngày mua) — **[PO]** có thể chọn cộng dồn bằng cách dùng *offer* của Store. |
| Hết dùng thử | Trạng thái **Hết hạn — Khoá** (5.2). |
| Hết 3 tháng | Thông báo cho **cả Bố và Mẹ**: “3 tháng dùng thử đã kết thúc. Nâng cấp gói để tiếp tục lưu giữ hành trình của con.” → app khoá ở SUB-07. |
| Sau khi hết hạn | Dữ liệu **giữ nguyên khoảng 12 tháng** kể từ ngày khoá. Báo trước khi xoá: **30 ngày** và **7 ngày** (push + email/SMS nếu có), và nhắc nâng cấp hằng tháng (tối đa 1 lần/tháng). Trong thời gian này luôn xuất/tải dữ liệu được. Hết 12 tháng không gia hạn → xoá toàn bộ dữ liệu gia đình. |

> **Lưu ý Store:** dùng thử do server cấp (không qua IAP) giúp người dùng không phải nhập thẻ — tỉ lệ kích hoạt cao hơn. App phải hiển thị rõ ở onboarding và paywall: *“Dùng thử miễn phí 3 tháng. Sau đó cần đăng ký gói House hoặc Family để tiếp tục sử dụng.”* Không dùng *Introductory Offer* của Store. Chi tiết kỹ thuật: tài liệu kỹ thuật mục 6.5 và 18.

### 5.5 Sản phẩm trên Store

| Product ID (gợi ý) | Gói | Chu kỳ | Giá niêm yết | Nhóm subscription |
|---|---|---|---|---|
| `bf_house_yearly` | House | 1 năm | 399.000đ | `baby_family_premium` (cấp 2) |
| `bf_family_yearly` | Family | 1 năm | 599.000đ | `baby_family_premium` (cấp 1 — cao hơn) |

- Cả 2 gói trong **cùng một nhóm subscription** → mỗi Apple ID chỉ có 1 gói hoạt động và nâng/hạ cấp theo cơ chế Store.
- Giá VND chọn theo *price point* có sẵn trên Store; nếu không có đúng 399.000đ/599.000đ thì chọn mức gần nhất **[PO]**.
- Doanh thu thực nhận (ước tính): Apple/Google thu 15% (Small Business Program / subscription) → ~339.000đ và ~509.000đ trước thuế; thuế với giao dịch qua Store cần kế toán xác nhận.
- Khuyến mãi: *promo/offer code* (KOL, đối tác phòng khám sản…), *win-back offer* cho gia đình đã hết hạn.
- Gói tháng: không có ở MVP (có thể thêm sau nếu tỉ lệ chuyển đổi năm thấp).

### 5.6 Ai được mua & quyền lợi

- **Điều kiện mua:** gia đình đã đủ **Bố + Mẹ** (trạng thái Dùng thử / Hết hạn / House). Khi gia đình chưa kích hoạt → không hiển thị nút mua.
- **Bố hoặc Mẹ** đều mua được; người thân không bao giờ thấy paywall mua gói (họ chỉ thấy thông báo “Gia đình tạm dừng” khi hết hạn).
- Gói áp dụng cho **cả gia đình** (Bố, Mẹ, người thân nếu gói Family).
- Màn Gói hiển thị: gói hiện tại, **người thanh toán** (Bố/Mẹ), ngày gia hạn, kênh mua (App Store/Google Play).
- Chỉ **người thanh toán** huỷ/đổi được gói (vì gói nằm trong tài khoản Store của họ); người còn lại thấy hướng dẫn “Hãy nhờ Mẹ đổi gói trong App Store”.

### 5.7 Nâng cấp / Hạ cấp

| Tình huống | Hành vi |
|---|---|
| **Dùng thử → House/Family** | Hiệu lực ngay khi Store xác nhận. Mua Family → mở chức năng mời người thân ngay. |
| **Hết hạn → House/Family** | Mở khoá ngay; người thân được khôi phục (nếu chọn Family). |
| **House → Family** (cùng người trả) | Nâng cấp ngay; Store tự tính phần chênh lệch (Apple: prorate; Google: replacement mode “charge prorated price”). |
| **House → Family** (người còn lại muốn nâng) | App hiện: “Gói House đang do Mẹ thanh toán. Để tránh trả 2 lần, hãy nhờ Mẹ nâng cấp.” + nút *Gửi lời nhắn cho Mẹ* (thông báo trong app). Nếu vẫn tự mua → cảnh báo trùng gói; sau khi mua, hệ thống nhắc người kia huỷ gói cũ. |
| **Family → House** | Có hiệu lực **khi hết chu kỳ hiện tại**; trước đó cảnh báo “X người thân sẽ tạm dừng truy cập từ ngày dd/mm”. |
| **Gói hết hạn/huỷ/hoàn tiền** | → **Hết hạn — Khoá** (sau thời gian ân hạn của Store nếu là lỗi thanh toán). |

### 5.8 Hết hạn, ân hạn, vượt dung lượng

| Tình huống | Hành vi |
|---|---|
| **Ân hạn** (gia hạn thanh toán lỗi) | Giữ nguyên quyền lợi trong thời gian ân hạn của Store (bật Billing Grace Period). Banner: “Thanh toán gia hạn chưa thành công. Kiểm tra phương thức thanh toán để không gián đoạn.” |
| **Hết hạn** | Khoá toàn app (SUB-07) cho Bố/Mẹ; người thân thấy CIR-05. Không xoá dữ liệu. Nhiệm vụ lặp, nhắc nhở, recap, gợi ý **tạm dừng**; mở khoá lại → tiếp tục (không tạo bù nhiệm vụ đã qua). |
| **Vượt dung lượng gói** | Không xoá gì. Chặn *tải lên ảnh/video mới*; vẫn tạo ký ức dạng chữ, bình luận, nhiệm vụ, Papa & Mama. Gợi ý nâng gói / dọn thùng rác. |
| **Family → House** | Người thân chuyển **Tạm dừng** (CIR-05), không mất quyền đã cấp; nâng lại Family → khôi phục ngay. |
| **Dùng thử có > 10 GB?** | Không thể (bị chặn tải lên ở 10 GB). Mua House (50 GB)/Family (200 GB) → mở lại tải lên. |

### 5.9 Edge cases gói & dùng thử

| Case | Quy tắc |
|---|---|
| Hai bố mẹ cùng mua (2 Apple ID) | Hệ thống dùng gói cao hơn; người mua sau nhận thông báo: “Gia đình đã có gói. Bạn có thể huỷ gói của mình trong App Store để không bị trừ tiền lần sau.” + hướng dẫn xin hoàn tiền. Trước khi mua, app luôn kiểm tra và ẩn nút mua nếu gia đình đã có gói ≥ gói đang chọn. |
| Người trả tiền **xoá tài khoản** | Gia đình giữ quyền lợi tới hết chu kỳ đã trả; không tự gia hạn cho gia đình cũ. Parent còn lại được nhắc 14 ngày trước hết hạn để tự mua (khi gia đình lại đủ Bố + Mẹ). |
| Một Parent xoá tài khoản trong thời gian dùng thử | Đồng hồ dùng thử **vẫn chạy**; gia đình về `PARTNER_LEFT` cho tới khi có bạn đời mới. |
| Khôi phục mua hàng (Restore) trên máy mới | Nút “Khôi phục giao dịch” ở paywall & màn gói. |
| Mua trên iOS, dùng trên Android | Quyền lợi gắn gia đình nên dùng được mọi nền tảng; quản lý/huỷ ở Store gốc. |
| Apple **Family Sharing** | Tắt cho các sản phẩm. |
| Tạo gia đình mới để “lách” dùng thử | Bị chặn bởi quy tắc chống lạm dụng 5.4. |
| Đổi giờ hệ thống trên máy để kéo dài dùng thử | Không ảnh hưởng — thời hạn tính trên server. |

### 5.10 Paywall — điểm xuất hiện

1. **Bắt buộc** khi Hết hạn (SUB-07, không đóng được).
2. Banner nhắc dùng thử (ngày 60, 83, 88, 90).
3. Bấm “Mời người thân” khi đang dùng thử hoặc ở gói House (→ gợi ý gói Family).
4. Vượt dung lượng / video dài hơn giới hạn gói.
5. Hết lượt AI.
6. Màn Gia đình > Gói (chủ động).

Paywall bắt buộc có (theo Store): tên gói, giá, chu kỳ, “tự động gia hạn, huỷ bất kỳ lúc nào trong cài đặt Store”, link *Điều khoản* & *Chính sách quyền riêng tư*, nút *Khôi phục giao dịch*; và dòng “Dùng thử miễn phí còn N ngày” khi đang dùng thử.

---

## 6. Hành trình người dùng tổng thể

### 6.1 Hành trình người tạo gia đình (Parent A)

```
Cài app → Welcome (3 slide) → Đăng nhập (Apple/Google/SĐT) → Hồ sơ cơ bản
  → BẮT BUỘC chọn vai trò:  [Bố]  [Mẹ]  [Người thân (ông bà, cô dì chú bác…)]
  → (Bố/Mẹ) Chọn cách gọi (Bố/Ba/Cha… | Mẹ/Má/Mạ…)
  → Tên gia đình (gợi ý sẵn, sửa được)
  → BẮT BUỘC mời bạn đời: chia sẻ link/QR/mã qua Zalo/Messenger/SMS (không có nút "Để sau")
  → Màn CHỜ BẠN ĐỜI (ONB-WAIT): app khoá mọi tính năng; xem trạng thái lời mời, gửi lại, đổi cách mời
        ▼  bạn đời chấp nhận (+ Parent A xác nhận lần cuối)
  → Chúc mừng "Nhà mình đã đủ Bố và Mẹ 🎉 — Bắt đầu 3 tháng dùng thử miễn phí"
  → Giai đoạn: [Đang mang thai] [Bé đã chào đời] [Đã có bé và đang mang thai]
  → Tạo thai kỳ / hồ sơ bé (một trong hai Parent làm, người kia thấy ngay)
  → Giải thích quyền riêng tư → Bật thông báo → (tuỳ chọn) Ký ức đầu tiên → TRANG CHỦ
```

### 6.2 Hành trình bạn đời (Parent B)

```
Nhận link (Zalo…) → mở link
  ├─ Chưa cài app → trang web lời mời → Store → cài → mở app → app tự nhận lời mời
  └─ Đã cài app → mở thẳng màn Lời mời
→ Đăng nhập → Hồ sơ cơ bản
→ Xem lời mời: "Lan (Mẹ) mời bạn làm BỐ trong Nhà Cà Chua" → chọn cách gọi → Chấp nhận
→ Parent A xác nhận lần cuối (nếu bật) → gia đình KÍCH HOẠT, bắt đầu dùng thử 3 tháng
→ Cùng Parent A thiết lập bé/thai kỳ (ai làm trước cũng được) → Trang chủ
```

**Trường hợp hai người cùng tự cài app (không ai mời ai):** cả hai đều chọn vai trò và đều tạo một gia đình “chờ bạn đời”. Vì gia đình chưa kích hoạt **không thể có dữ liệu** (không tạo bé/ký ức), chỉ cần một người nhập mã/mở link của người kia → gia đình rỗng của người chấp nhận lời mời **tự huỷ**, không cần gộp dữ liệu.

### 6.3 Hành trình người thân

```
Cách 1 (phổ biến): Bố/Mẹ mời (gia đình đã có gói Family)
  → chọn quan hệ (Bà nội) → chọn bé (Hana ✓, Haru ✗) → quyền (Bình luận) → gửi link qua Zalo
  → Bà mở link → cài app → đăng nhập SĐT (OTP) → "Mẹ Lan mời bà xem cháu Hana" → Chấp nhận
  → chọn cỡ chữ → Trang chủ người thân

Cách 2: Ông bà tự cài app trước
  → Đăng nhập → chọn vai trò "Người thân"
  → Màn CHỜ LỜI MỜI (CIR-WAIT): KHÔNG dùng được tính năng nào cho tới khi tham gia một gia đình
       • Nhập mã mời / quét QR / mở link mời
       • "Nhờ con mời mình": chia sẻ tin nhắn soạn sẵn kèm link tải app cho con (Zalo/SMS),
         vd. "Con ơi, mẹ đã cài Baby Family. Con mời mẹ vào xem cháu nhé: <link>"
  → Khi có lời mời → chấp nhận → Trang chủ người thân
```

> Người thân **không** tự tạo được gia đình, không tạo bé. Một người đã chọn “Người thân” vẫn có thể đổi lại thành Bố/Mẹ (khi chưa tham gia gia đình nào với vai trò người thân, hoặc qua Cài đặt > Tạo gia đình của tôi).

### 6.4 Vòng lặp hằng ngày (Parent)

| Thời điểm | Hành động | Màn |
|---|---|---|
| Sáng (7:00) | Thông báo: “Hôm nay bạn có 3 việc nhỏ cho Haru 🌱” | HOME-01 |
| Trong ngày | Chụp ảnh → tạo ký ức trong 3 chạm | MEM-04/05 |
| Khi mệt | Check-in “Mệt” + “Cần nghỉ 30 phút” | US-02/03 |
| Tối | Hoàn thành nhiệm vụ “Tắm cho bé” + đính ảnh | CARE-06 |
| Sau nhiệm vụ | Gửi lời cảm ơn | US-05 |
| 21:00 | Gợi ý “Câu chuyện hôm nay của Hana” (nếu có ≥ 2 ký ức) | REC-01 |
| Chủ nhật 19:00 | “Tuần của nhà mình đã sẵn sàng” | REC-02 |
| Ngày tròn tháng của bé | Thẻ “Hana tròn 5 tháng” + gợi ý chụp ảnh tháng | HOME-01 |

### 6.5 Vòng lặp người thân

- Thông báo tức thời khi có ảnh mới **hoặc** bản tin 1 lần/ngày lúc 19:00 (người thân chọn).
- Mở app → xem → thả tim/bình luận → Bố/Mẹ nhận thông báo gộp.

---
## 7. Đặc tả chức năng theo module

### 7.1 Tài khoản & Đăng nhập [MVP]

**Ai dùng:** mọi người dùng. **Mục tiêu:** vào app nhanh, an toàn, phù hợp người lớn tuổi.

**Phương thức đăng nhập**

| Phương thức | Nền tảng | Ghi chú |
|---|---|---|
| Sign in with Apple | iOS (bắt buộc có vì app có Google login), Android (tuỳ chọn qua web) | Có thể ẩn email (relay email) |
| Google | iOS, Android | |
| Số điện thoại + OTP | iOS, Android | OTP 6 số, gửi qua **Zalo ZNS** (ưu tiên, rẻ) → fallback **SMS brandname**. Hết hạn 5 phút. |

**Luồng chính**
1. Chọn phương thức → xác thực.
2. Nếu tài khoản mới → màn *Hồ sơ cơ bản*: tên hiển thị (bắt buộc), ảnh đại diện (tuỳ chọn), đồng ý *Điều khoản & Chính sách* (bắt buộc, có checkbox riêng cho xử lý dữ liệu cá nhân theo luật VN).
3. Nếu mở app từ link mời → sau đăng nhập đi thẳng màn Lời mời (vai trò lấy theo lời mời, không hỏi lại).
4. Nếu không có lời mời → **bắt buộc chọn vai trò** (ONB-03): **Bố** / **Mẹ** / **Người thân**. Không có lựa chọn bỏ qua.

**Quy tắc**
- Một người có thể liên kết nhiều phương thức vào 1 tài khoản (Cài đặt > Tài khoản > Phương thức đăng nhập). Không tự gộp tài khoản chỉ vì trùng email/SĐT — phải xác thực cả hai.
- OTP: tối đa 5 lần nhập sai/mã; tối đa 5 lần gửi/SĐT/giờ; chờ 60s giữa 2 lần gửi.
- Phiên đăng nhập 90 ngày không hoạt động thì hết hạn. Xem & đăng xuất từng thiết bị.
- Khoá ứng dụng bằng Face ID/vân tay/mã PIN (tuỳ chọn) — đặc biệt khi máy dùng chung.

**Ngoại lệ**
- SĐT không nhận OTP → “Gửi lại qua SMS” / “Thử cách khác”.
- Apple ẩn email → vẫn dùng bình thường; email relay chỉ dùng cho thông báo hệ thống.
- Người dùng đã xoá tài khoản (đang trong 30 ngày chờ) đăng nhập lại → hỏi “Khôi phục tài khoản?”.

---

### 7.2 Chọn vai trò, Tạo gia đình & Kích hoạt [MVP]

**Luồng** (xem 6.1 – 6.3). Chi tiết từng bước ở các màn `ONB-*`, `CIR-WAIT`.

**Quy tắc đã chốt với khách hàng**
- **BR-050 — Bắt buộc chọn vai trò** sau khi đăng nhập (trừ khi vào bằng lời mời): Bố / Mẹ / Người thân.
- **BR-051 — Bố/Mẹ bắt buộc mời bạn đời.** Sau khi tạo gia đình, Parent A phải gửi lời mời; **không có nút “Để sau”**.
- **BR-052 — Gia đình chỉ dùng được khi đủ Bố + Mẹ.** Khi mới có 1 Parent, **mọi tính năng bị khoá, kể cả tạo bé/thai kỳ**, ký ức, nhiệm vụ, mời người thân, mua gói. Người dùng chỉ ở màn Chờ bạn đời (ONB-WAIT).
- **BR-053 — Người thân chỉ dùng được khi đã tham gia một gia đình** qua lời mời của Bố/Mẹ. Chọn vai trò Người thân mà chưa có lời mời → màn Chờ lời mời (CIR-WAIT), không dùng được tính năng nào.
- **BR-054 — Dùng thử 3 tháng bắt đầu khi gia đình đủ Bố + Mẹ** (mục 5.4).

**Quy tắc khác**
- Một tài khoản chỉ là **Parent của 1 gia đình**. Có thể đồng thời là **người thân** ở gia đình khác (vd. vừa là Mẹ ở nhà mình, vừa là Cô ở nhà anh trai) → *bộ chuyển gia đình* ở avatar. **[PO]**
- Tên gia đình mặc định: “Nhà [tên người tạo]” (sau khi tạo bé có thể đổi thành “Nhà của Hana”).
- Thiết lập bé/thai kỳ diễn ra **sau khi kích hoạt**; một trong hai Parent làm, người kia thấy ngay (nếu cả hai cùng mở màn thiết lập, người thứ hai thấy dữ liệu người kia vừa tạo + cảnh báo trùng).
- Có thể chọn **cả hai**: đã có bé và đang mang thai.
- Mỗi bước có “Quay lại”; thoát giữa chừng → lần mở sau tiếp tục từ bước dở.
- Thông tin tối thiểu khi thiết lập: tên gọi bé **hoặc** nickname thai kỳ.
- Đổi vai trò khi đang chờ: Parent A ở màn Chờ có thể “Huỷ gia đình này” (gia đình rỗng, xoá ngay) để chọn lại vai trò hoặc nhận lời mời của người khác.

**Trạng thái gia đình**

| Trạng thái | Ý nghĩa | Dùng được |
|---|---|---|
| `WAITING_PARTNER` | Mới có Parent A, đã/đang mời bạn đời | Chỉ màn Chờ bạn đời, cài đặt tài khoản |
| `ACTIVE` | Đủ Bố + Mẹ | Theo trạng thái gói (Dùng thử / House / Family / Hết hạn — mục 5.2) |
| `PARTNER_LEFT` | Từng ACTIVE, một Parent đã **xoá tài khoản** (không có chức năng rời gia đình — BR-057) | Người còn lại **chỉ xem & tải về** ký ức; không tạo mới; mời bạn đời mới để dùng tiếp |
| `DELETION_SCHEDULED` | Đã yêu cầu xoá gia đình, trong 30 ngày chờ | — |
| `DELETED` | Đã xoá | — |

---

### 7.3 Mời bạn đời [MVP]

**Ai dùng:** Parent A ngay sau khi tạo gia đình (bắt buộc), hoặc Parent còn lại khi gia đình ở `PARTNER_LEFT`. **Điểm vào:** onboarding (ONB-07 → ONB-WAIT), Gia đình > Thành viên.

**Luồng**
1. Bấm “Mời Bố/Mẹ”. App gợi ý vai trò còn lại (có thể đổi nếu gia đình 2 Bố hoặc 2 Mẹ — app không giả định giới tính; nhãn do người dùng chọn).
2. Tạo lời mời → hiển thị: **link** (`babyfamily.vn/i/ABCD...`), **mã 8 ký tự**, **QR**.
3. Chia sẻ qua share sheet (Zalo, Messenger, SMS, Copy).
4. Người nhận mở → đăng nhập → thấy: tên gia đình, người mời, vai trò đề xuất, lời nhắn (gia đình chưa kích hoạt nên chưa có bé; trường hợp `PARTNER_LEFT` thì hiện tên + avatar các bé).
5. Chấp nhận / Từ chối.
6. Nếu bật **“Tôi xác nhận lần cuối”** (mặc định BẬT): Parent A nhận thông báo “Anh Minh muốn tham gia làm Bố. Xác nhận?” → Đồng ý/Từ chối. Chống trường hợp link bị chuyển nhầm người.
7. Thành công: gia đình chuyển `ACTIVE`, **bắt đầu dùng thử 3 tháng**; cả hai nhận thông báo “Nhà mình đã đủ Bố và Mẹ 🎉” và được đưa vào bước thiết lập bé/thai kỳ; Papa & Mama Space mở với màn giới thiệu quyền riêng tư.

**Quy tắc**
- Lời mời bạn đời hết hạn sau **7 ngày**, dùng **1 lần**. Tạo lời mời mới sẽ vô hiệu lời mời cũ. Hết hạn mà chưa ai nhận → màn Chờ hiện “Lời mời đã hết hạn” + nút tạo lời mời mới.
- Người nhận đang là Parent ở gia đình khác (đã kích hoạt) → **chặn** (MVP không hỗ trợ rời gia đình). Không tự gộp.
- Người nhận đang là người thân (Circle) của chính gia đình này → được phép nâng lên Parent qua lời mời bạn đời (quyền Circle bị thay bằng Parent).
- Không cho mời quá 5 lần/ngày.

**Ngoại lệ**
- Link hết hạn → “Lời mời đã hết hạn. Nhờ người mời gửi lại” + nút *Nhắn người mời* (mở Zalo/SMS không khả dụng vì không có SĐT người mời → chỉ hiển thị hướng dẫn).
- Hai người cùng tự tạo gia đình (cùng đang chờ) → người nhập mã/mở link của người kia: gia đình rỗng của mình **tự huỷ** rồi tham gia (không cần gộp vì chưa có dữ liệu).
- Người nhận đang chờ lời mời với vai trò Người thân → chấp nhận lời mời bạn đời sẽ đổi vai trò thành Parent.

---

### 7.4 Family Circle — mời ông bà, người thân [MVP – chỉ gói Family]

**Ai dùng:** Parent, khi gia đình có gói **Family** (tối đa 12 người). Dùng thử và gói House **không** mời được người thân. **Điểm vào:** Gia đình > Người thân > Mời; Trang chủ thẻ gợi ý “Mời ông bà xem cháu”.

**Luồng mời (5 bước)**
1. **Quan hệ**: Ông nội / Bà nội / Ông ngoại / Bà ngoại / Cô / Dì / Chú / Bác / Cậu / Mợ / Thím / Anh chị họ / Bảo mẫu / Khác (nhập tên gọi).
2. **Tên gọi hiển thị** (gợi ý theo quan hệ, vd. “Bà nội”).
3. **Chọn bé/thai kỳ được chia sẻ**: danh sách checkbox (mặc định chọn tất cả bé hiện có, có thể bỏ).
4. **Quyền** cho từng bé (preset chung, có thể chỉnh riêng từng bé):
   - 👀 **Xem** — xem ảnh, video, cột mốc
   - 💬 **Xem + Bình luận**
   - ➕ **Xem + Bình luận + Đăng ảnh** (Đóng góp)
   - Công tắc “**Cho phép tải ảnh về máy**” (mặc định TẮT)
5. **Xem trước & gửi**: “Bà nội sẽ thấy: Hana (Bình luận). Bà sẽ KHÔNG thấy: Haru, Papa & Mama, Nhiệm vụ.” → tạo link/QR → chia sẻ.

**Quy tắc**
- Tối đa **12 người thân** (đang hoạt động + lời mời đang chờ).
- Lời mời người thân hết hạn **14 ngày**, 1 lần dùng.
- Quyền luôn **theo từng bé/thai kỳ**; không có quyền “toàn gia đình”.
- Người thân thấy *Khoảnh khắc gia đình* (ký ức không gắn bé, visibility Cả nhà) nếu có ít nhất 1 quyền đang hoạt động.
- Papa & Mama Space, nhiệm vụ, lời nhờ, Hearts, thống kê chăm con, nhật ký riêng **luôn bị loại trừ** khỏi mọi quyền.
- **Bé mới (sinh/thêm):** app hỏi Parent: “Chia sẻ Haru với những người thân sau?” — danh sách người thân có checkbox (mặc định **không chọn**), quyền mặc định = quyền họ đang có với bé gần nhất. Riêng **bé sinh ra từ thai kỳ** đã chia sẻ → kế thừa quyền của thai kỳ (vì là cùng hành trình), có thông báo cho Parent.
- **Duyệt ảnh người thân**: Cài đặt gia đình “Duyệt ảnh do người thân đăng” (mặc định BẬT). Ký ức do Contributor đăng ở trạng thái *Chờ duyệt* — chỉ người đăng và Parent thấy; Parent Duyệt/Từ chối (kèm lý do tuỳ chọn). Quá 7 ngày không duyệt → nhắc Parent; không tự duyệt.
- Người thân **không thể** gắn bé ngoài phạm vi được chia sẻ; Parent có thể gắn thêm sau.

**Quản lý người thân**
- Xem danh sách: tên, quan hệ, bé được chia sẻ, quyền, lần hoạt động gần nhất.
- Sửa quyền (có hiệu lực ngay).
- **Tạm ẩn** một bé khỏi người thân.
- **Gỡ người thân**: xác nhận → mất quyền ngay; nội dung họ đã đăng: chọn *Giữ lại trong gia đình* (mặc định) hoặc *Gỡ toàn bộ*. Bình luận của họ vẫn giữ (hiển thị tên “Người dùng đã rời”) trừ khi chọn gỡ.

**Ngoại lệ**
- Ông bà dùng chung 1 điện thoại/1 tài khoản → cho phép đặt tên gọi “Ông bà nội” cho 1 tài khoản. Khuyến cáo nhẹ mỗi người 1 tài khoản để thông báo đúng người.
- Người thân bị gỡ mở lại link cũ → “Lời mời không còn hiệu lực”.
- Người thân đổi số điện thoại → đăng nhập phương thức khác hoặc CSKH hỗ trợ.

---

### 7.5 Thai kỳ [MVP]

Thai kỳ là “chương 0” trong hành trình của bé. **Không phải app y tế** — không đưa lời khuyên sức khoẻ.

**Hồ sơ thai kỳ**

| Trường | Bắt buộc | Ghi chú |
|---|---|---|
| Tên gọi ở nhà (nickname) | Không (mặc định “Bé Bi #1”) | “Bé Đậu”, “Cà Chua” |
| Ngày dự sinh | Không (khuyến khích) | Dùng để tính tuần thai & đếm ngược. Cho nhập *ngày dự sinh* **hoặc** *tuần thai hiện tại* (app tự quy đổi) |
| Song thai/đa thai | Không | Số bé dự kiến (1–4); có thể sửa lúc sinh |
| Ảnh bìa | Không | |
| Giới tính dự đoán | Không | Ẩn mặc định; nhiều gia đình muốn giữ bí mật/“gender reveal” |
| Người mang thai | Tự động (Parent vai trò Mẹ) | Dùng cho bộ nhiệm vụ theo giai đoạn (7.13.2); đổi được |

**Tính năng**
- **Tuần thai & đếm ngược**: “Tuần 24 • còn 112 ngày”. Thẻ nội dung vui “Bé to bằng bắp ngô” *(nội dung tham khảo, Content kiểm duyệt, có thể tắt)* [1.1].
- **Nhật ký bụng bầu**: chụp ảnh theo tuần, chế độ so sánh các tuần (lưới), nhắc chụp mỗi tuần (tuỳ chọn).
- **Ảnh siêu âm**: lưu như ký ức loại *Siêu âm*, ghi tuần thai + lời nhắn. App **không** phân tích y khoa.
- **Thư gửi con trước khi chào đời**: viết/ghi âm/quay video, có thể hẹn ngày mở.
- **Chuẩn bị đón bé**: checklist (đồ đi sinh, đồ sơ sinh, góc của bé, giấy tờ), mỗi mục có thể chuyển thành nhiệm vụ của tôi / Cùng nhau, hoặc gửi Lời nhờ cho bạn đời.
- **Cột mốc thai kỳ**: Que thử 2 vạch • Lần siêu âm đầu • Nghe tim thai • Lần đầu bé đạp • Biết giới tính (nếu gia đình muốn) • Chọn được tên — gắn thai kỳ, sau sinh trở thành cột mốc của bé (17.2).
- **Kể cùng nhau** (7.8.6) áp dụng cho ký ức thai kỳ: “Mama kể” cảm giác bé đạp, “Papa kể” lần đầu đặt tay lên bụng.
- **Đặt tên cho con** [1.1]: Papa & Mama cùng thêm tên dự định (kèm ý nghĩa), mỗi người thả tim tên mình thích; tên được cả hai thả tim nổi lên đầu; chỉ hai người thấy. Khi chọn xong → cột mốc “Chọn được tên” + điền sẵn vào luồng Bé chào đời.
- **Nhiệm vụ đồng hành thai kỳ**: catalog riêng (đi dạo cùng nhau, bạn đời chuẩn bị bữa ăn, chọn bài hát cho bé…); từ tuần 28 bộ nhiệm vụ của mẹ ưu tiên `SELF`, của bố ưu tiên `SUPPORT` (7.13.2).

**Quy tắc**
- Tuần thai tự tăng theo ngày; nếu không có ngày dự sinh → không hiển thị tuần.
- Quá ngày dự sinh 14 ngày mà chưa “Bé chào đời” → hỏi nhẹ: “Bé đã chào đời chưa? Cập nhật để bắt đầu hành trình mới.” (1 lần/tuần, có thể tắt).
- Thai kỳ có thể **Lưu trữ** (dừng hành trình) bất kỳ lúc nào. **Mất thai/không thành**: thai kỳ chuyển trạng thái *Lưu trữ riêng tư* — ngừng mọi nhắc nhở, nhiệm vụ, đếm ngược ngay; không gửi bất kỳ thông báo “chúc mừng” nào; ký ức được giữ (gia đình có thể muốn giữ) và tự chuyển visibility về “Bố mẹ” nếu Parent chọn. Ngôn ngữ phải nhẹ nhàng, không hỏi lý do. Hiển thị nguồn hỗ trợ tinh thần (tuỳ chọn). *Đây là tình huống rất nhạy cảm — UX phải review riêng.*
- Thai kỳ #2, #3 chạy song song với các bé đã có.

---

### 7.6 Bé chào đời (Birth conversion) [MVP]

**Điểm vào:** Trang chủ thai kỳ (nút “Bé đã chào đời 🎉”), thông báo gần/quá dự sinh, hồ sơ thai kỳ.

**Luồng**
1. “Bé đã chào đời” → xác nhận số bé (mặc định theo số đã khai; chọn 1–4).
2. Với **từng bé**: tên (hoặc tên ở nhà), ngày sinh (bắt buộc), giờ sinh (tuỳ chọn), giới tính (tuỳ chọn), ảnh đầu tiên (tuỳ chọn), cân nặng/chiều dài lúc sinh (tuỳ chọn, chỉ lưu).
3. Xem trước thẻ “Chào mừng Hana!”.
4. Chọn chia sẻ thông báo chào đời với người thân (nếu gói Family và có người thân được chia sẻ thai kỳ).
5. Xác nhận → hiệu ứng chúc mừng → Trang chủ bé.

**Kết quả hệ thống**
- Tạo 1..N hồ sơ bé, liên kết với thai kỳ (thứ tự sinh).
- Toàn bộ ký ức thai kỳ trở thành **phần mở đầu** trong timeline của **mỗi** bé sinh từ thai kỳ đó (không nhân bản).
- Tạo cột mốc **“Chào đời”** cho từng bé (luôn sửa được).
- Thai kỳ chuyển `COMPLETED`; ngừng đếm ngược.
- Quyền người thân của thai kỳ được kế thừa cho bé.
- Bảng nhiệm vụ chuyển sang catalog **sơ sinh**; 6 tuần đầu bộ của mẹ ưu tiên `SELF` (nghỉ ngơi, hồi phục), bộ của bố ưu tiên `SUPPORT`/`CARE`; gợi ý chuyển mức “Nhẹ” cho cả nhà (vẫn bằng nhau).
- Nhắc *Đầy tháng* (30 ngày, có lựa chọn tính âm lịch).

**Quy tắc & ngoại lệ**
- Sinh sớm/muộn: dùng ngày sinh thật, **không** đánh giá y khoa (“sinh non” không hiển thị như nhãn).
- Bấm nhầm/thoát giữa chừng: thao tác là *idempotent* — thử lại không tạo bé trùng.
- Khai 1 bé nhưng thực tế sinh đôi → trong hồ sơ thai kỳ “Thêm bé sinh cùng thai kỳ” (có xác nhận).
- Nhập sai ngày sinh → sửa trong hồ sơ bé; nhãn tuổi trên timeline cập nhật; ngày gốc của ký ức **không đổi**.

---

### 7.7 Hồ sơ bé & quản lý nhiều bé [MVP]

**Thông tin hồ sơ**

| Nhóm | Trường | Bắt buộc | Ai thấy |
|---|---|---|---|
| Nhận diện | Tên, tên ở nhà, ảnh đại diện | Tên hoặc tên ở nhà | Parent + người thân được chia sẻ |
| Màu nhận diện | 1 trong 8 màu pastel (tự gán, đổi được) | Tự động | Như trên |
| Ngày sinh | Dương lịch (bắt buộc với bé đã sinh), giờ sinh, hiển thị âm lịch | Ngày sinh | Parent; người thân thấy tuổi, không thấy giờ sinh (tuỳ chọn) |
| Câu chuyện tên | Ý nghĩa tên, ai đặt | Không | Theo visibility |
| Sở thích | Món thích, đồ chơi, bài hát | Không | Như trên |
| Ảnh bìa timeline | | Không | |

**Tuổi hiển thị**

| Tuổi | Định dạng |
|---|---|
| 0–13 ngày | “5 ngày tuổi” |
| 2–12 tuần | “6 tuần 3 ngày” |
| 3–23 tháng | “8 tháng 12 ngày” |
| ≥ 2 tuổi | “2 tuổi 4 tháng” |
| Thai kỳ | “Tuần 24 + 3 ngày” |

Trong ký ức luôn ghi *tuổi tại thời điểm ký ức* (“Hana • 5 tháng 2 ngày”) tính theo ngày xảy ra.

**Thêm bé** (Gia đình > Các con > Thêm): “Bé đã chào đời” hoặc “Đang mong bé” → **không** tạo gia đình mới, **không** thay đổi dữ liệu bé cũ.

**Bộ chuyển bé (Child Switcher)**
- Chip trên thanh đầu ở Trang chủ, Ký ức, Chăm con: `[Tất cả] [🟠 Hana] [🟢 Haru] [🤰 Thai #3]`.
- Nhớ lựa chọn gần nhất cho từng thiết bị.
- Papa & Mama Space, Cài đặt **không** phụ thuộc bé đang chọn.
- Người thân chỉ thấy bé được chia sẻ; nếu chỉ có 1 bé → ẩn switcher.

**Lưu trữ (archive) bé** — dùng cho trường hợp tạo nhầm/trùng: bé ẩn khỏi switcher, ký ức chỉ gắn riêng bé đó bị ẩn theo, ký ức chung với anh/chị/em vẫn hiện ở bé kia. Khôi phục được. **Xoá vĩnh viễn** bé: chỉ khi bé đã lưu trữ ≥ 7 ngày, xác nhận 2 lần, nội dung chỉ thuộc riêng bé đó vào thùng rác 30 ngày.

**Phát hiện trùng**: thêm bé có tên + ngày sinh trùng bé đang có → cảnh báo “Có thể Mẹ đã thêm Hana rồi. Vẫn tạo?”.

---

### 7.8 Ký ức (Memory) & Album [MVP]

#### 7.8.1 Loại ký ức

| Loại | Nội dung | Ví dụ |
|---|---|---|
| **Khoảnh khắc** | 1–N ảnh/video (+ chữ) | Bé cười lần đầu |
| **Nhật ký** | Chữ dài (có định dạng nhẹ), có thể kèm ảnh | “Hôm nay con lần đầu đi nhà trẻ…” |
| **Giọng nói** | Ghi âm (+ chữ) | Bố hát ru, tiếng con bập bẹ |
| **Câu nói của con** | Một câu ngắn con nói (≤ 280 ký tự) + tuổi + ngữ cảnh, hiển thị dạng thẻ trích dẫn; có thể kèm ghi âm | “Mẹ ơi, trăng đi theo con!” — Hana, 2 tuổi 4 tháng |
| **Ảnh tháng** | Ảnh chính của bé trong một tháng tuổi (7.8.7) | “Haru tròn 5 tháng” |
| **Kỷ vật** | Ảnh một đồ vật + câu chuyện | Vòng tay sơ sinh, đôi giày đầu tiên, lọn tóc máu |
| **Thư gửi con** | Thư; có thể hẹn ngày mở | “Gửi con năm 18 tuổi…” |
| **Siêu âm / Bụng bầu** | Ảnh + tuần thai | |
| **Cột mốc** | Khoảnh khắc + thẻ cột mốc | Bước đi đầu tiên |
| **Từ nhiệm vụ** | Tạo khi hoàn thành nhiệm vụ có đính ảnh | “Đi công viên cùng Bố” |
| **Câu chuyện ngày** | Tổng hợp (thủ công hoặc AI) | “Một ngày của Hana” |

Mỗi ký ức có thể thêm (tuỳ chọn, thu gọn trong màn soạn):
- **Ai ở đó** — chọn từ thành viên gia đình (Papa, Mama, Bà nội…) hoặc gõ tên; **không nhận diện khuôn mặt** (7.22).
- **Cảm xúc của khoảnh khắc** — 1 trong: 🥰 Thương • 😂 Vui • 🥹 Xúc động • 😮 Bất ngờ • 😴 Bình yên • 💪 Tự hào.
- **Góc nhìn thứ hai** của bạn đời (7.8.6).

#### 7.8.2 Tạo ký ức

**Điểm vào:** nút **+** giữa thanh điều hướng, Album, hoàn thành nhiệm vụ, thẻ gợi ý, chia sẻ từ app Ảnh của máy vào Baby Family (Share Extension) [1.1].

**Luồng (≤ 3 chạm cho trường hợp phổ biến)**
1. Chọn ảnh/video từ thư viện (photo picker hệ thống, chọn nhiều) **hoặc** chụp mới **hoặc** chọn “Viết” / “Ghi âm”.
2. Màn soạn:
   - **Bé trong khoảnh khắc** — mặc định = bé đang chọn ở switcher; nếu đang ở “Tất cả” và gia đình có > 1 bé → bắt buộc chọn: các bé (nhiều) **hoặc** “Khoảnh khắc gia đình” (không gắn bé).
   - **Ngày xảy ra** — mặc định lấy từ ngày chụp ảnh đầu tiên (EXIF), nếu không có → hôm nay. Cho chọn lùi ngày.
   - **Chú thích** — tuỳ chọn; có câu gợi ý (“Điều gì khiến con cười hôm nay?”).
   - **Ai nhìn thấy** — mặc định theo cài đặt gia đình (xem 7.23).
   - Nâng cao (thu gọn): Đánh dấu cột mốc, Ai ở đó, Cảm xúc của khoảnh khắc, Thêm vào album, Địa điểm (gõ chữ, không GPS), Tắt bình luận.
3. **Lưu** → ký ức hiện ngay với ảnh đang tải (tiến trình) → tải nền kể cả khi thoát app.

**Quy tắc**
- Ít nhất 1 trong: ảnh/video/âm thanh/chữ.
- Tự lưu **bản nháp** khi thoát giữa chừng; mất mạng → xếp hàng gửi khi có mạng.
- Ảnh trùng (đã tải lên trước đó trong gia đình) → hỏi “Ảnh này đã có trong ký ức ngày 12/3. Vẫn thêm?”.
- Vị trí GPS trong ảnh **luôn bị xoá** trên máy chủ. Ngày chụp được giữ lại làm gợi ý ngày xảy ra.
- Tải lên vượt quota → giữ bản nháp, hiện paywall/hướng dẫn.
- Ảnh HEIC (iPhone) được chuyển sang JPEG trước khi tải lên.

**Trạng thái ký ức**

| Trạng thái | Ý nghĩa |
|---|---|
| `DRAFT` | Nháp, chỉ người tạo thấy (lưu cục bộ + server) |
| `PROCESSING` | Đang tải/xử lý media; người tạo thấy, người khác chưa thấy |
| `PENDING_REVIEW` | Do người thân đăng, chờ Parent duyệt |
| `PUBLISHED` | Hiển thị theo visibility |
| `REJECTED` | Parent từ chối (người đăng thấy lý do) |
| `ARCHIVED` | Ẩn khỏi feed/timeline, còn trong thư viện “Đã ẩn” |
| `TRASHED` | Thùng rác 30 ngày, khôi phục được |
| `PURGED` | Đã xoá vĩnh viễn |

#### 7.8.3 Sửa / Xoá

- Người tạo sửa: chú thích, ngày, bé gắn, visibility, album, thêm/bớt ảnh.
- Parent sửa ký ức của người khác: chỉ *gắn bé*, *visibility*, *ẩn*, *gỡ khỏi gia đình*. Không sửa chú thích của người khác.
- **Bỏ gắn 1 bé** khỏi ký ức chung → ký ức biến mất khỏi timeline bé đó, vẫn còn ở bé khác & gia đình. Nếu thay đổi làm người thân mất/được quyền xem → cảnh báo ngắn trước khi lưu: “Bà ngoại sẽ không thấy ảnh này nữa”.
- **Xoá** → vào thùng rác 30 ngày (của người xoá + Parent). Cảnh báo nếu ký ức gắn nhiều bé: “Ảnh sẽ mất khỏi timeline của Hana và Haru”. Bình luận/reaction đi theo ký ức.
- Ký ức đã dùng trong Recap: khi xoá, recap tự loại bỏ ký ức đó ở lần hiển thị sau.

#### 7.8.4 Bộ sưu tập & Album

- **Bộ sưu tập tự động** (MEM-22, không cần tạo, mỗi bé có riêng):

| Bộ sưu tập | Nội dung |
|---|---|
| **Con lớn từng tháng** | Ảnh tháng (7.8.7) |
| **Những lần đầu** | Cột mốc đã ghi (MEM-12) |
| **Câu nói của con** | Thẻ trích dẫn theo tuổi, có thể nghe lại ghi âm |
| **Giọng nói** | Tiếng cười, bập bẹ, bố mẹ hát ru… |
| **Thư gửi con** | Thư đã mở + phong bì còn niêm phong |
| **Kỷ vật** | Đồ vật & câu chuyện |
| **Cả hai cùng kể** | Ký ức có góc nhìn của cả Papa & Mama |
| **Ảnh chung anh chị em** | Ký ức gắn ≥ 2 bé |
| Video • Yêu thích • Từ người thân • Thai kỳ #N | Như tên |

- **Album tự tạo**: tên + ảnh bìa; ký ức có thể nằm trong nhiều album. Visibility của album **không** ghi đè visibility từng ký ức (album chỉ là bộ sưu tập; người xem chỉ thấy ký ức họ có quyền).
- **Yêu thích**: cá nhân (mỗi người một danh sách, riêng tư) + **“Ảnh đẹp nhất của nhà mình”** — ký ức được **cả hai** Parent bấm yêu thích tự vào bộ sưu tập chung này (chỉ Papa & Mama thấy).

#### 7.8.5 Tải về & chia sẻ ra ngoài

- Parent: tải ảnh/video gốc (gói Family) hoặc bản chất lượng cao.
- Người thân: chỉ khi được bật “Cho phép tải”.
- **Chia sẻ ra ngoài app** (Zalo/Facebook): chỉ Parent; xuất file ảnh qua share sheet (không có link công khai). Hiển thị lời nhắc nhẹ lần đầu: “Ảnh sẽ rời khỏi không gian riêng của gia đình”.

#### 7.8.6 Kể cùng nhau — Góc nhìn thứ hai [MVP]

Một khoảnh khắc thường có **hai người** chứng kiến. Bạn đời có thể thêm **góc nhìn của mình** vào ký ức của người kia thay vì tạo ký ức trùng.

- Trên MEM-07 (ký ức do bạn đời tạo): nút **“Thêm góc nhìn của bạn”** → ô chữ (≤ 1.000 ký tự) + tối đa 10 ảnh/video + ghi âm (tuỳ chọn).
- Hiển thị: ký ức có 2 phần “Mama kể” / “Papa kể”, mỗi phần có avatar & thời gian; trên timeline thẻ có huy hiệu nhỏ **“Cả hai cùng kể”**.
- Mỗi ký ức tối đa **1 góc nhìn/Parent** (sửa được). Người thân không thêm góc nhìn (họ dùng bình luận).
- Visibility của góc nhìn **kế thừa ký ức gốc**, không thể rộng hơn (BR-071). Người tạo ký ức gốc không sửa/xoá được góc nhìn của bạn đời, chỉ có thể **ẩn khỏi người thân**.
- Xoá ký ức gốc → góc nhìn vào thùng rác theo.
- Gợi ý nhẹ (tối đa 1 lần/ngày, có thể tắt): khi bạn đời đăng một cột mốc → “Bạn cũng ở đó chứ? Kể thêm góc nhìn của bạn nhé.”
- Hearts: thêm góc nhìn có nội dung = +2 (tính chung giới hạn “Tạo ký ức” 5 lần/ngày); xoá góc nhìn không thu hồi Hearts.

#### 7.8.7 Ảnh tháng của con [MVP]

Truyền thống chụp **ảnh mỗi tháng** của các gia đình Việt được làm thành bộ sưu tập riêng.

- **Nhắc**: đúng **ngày tròn tháng** (theo ngày sinh; tuỳ chọn âm lịch) lúc 9:00 → thẻ trên Trang chủ “Hôm nay Haru tròn 6 tháng 🎉 — Chụp ảnh tháng” (không push nếu đã có ảnh tháng). Thai kỳ: **ảnh bụng theo tuần** (mỗi 4 tuần hoặc mỗi tuần — tuỳ chọn).
- **Chụp** (MEM-21): camera có **khung hướng dẫn** (bóng mờ ảnh tháng trước để đặt cùng tư thế/góc), **sticker tháng** (“6 tháng”, nhiều mẫu, chuẩn ngôn ngữ), nền màu của bé; hoặc chọn ảnh có sẵn.
- **Mỗi bé mỗi tháng tuổi có đúng 1 ảnh tháng chính** (có thể đổi ảnh khác làm ảnh chính; ảnh cũ vẫn là ký ức thường) — BR-072. Tháng 0 = ảnh chào đời; từ 12 tháng trở đi chuyển sang **ảnh 3 tháng/lần** (tuỳ chọn giữ hằng tháng).
- **Bộ sưu tập “Con lớn từng tháng”** (MEM-20): lưới 12 ô/năm (ô chưa có = khung mờ, chạm để thêm), **so sánh 2 tháng** cạnh nhau, tự ghép **collage** 4/9/12 ảnh để lưu/chia sẻ; **video tua nhanh** các ảnh tháng [1.1].
- Ảnh tháng là **bìa của chương tháng** trên timeline (7.10).
- Bỏ lỡ ngày tròn tháng → vẫn thêm được trong cả tháng tuổi đó; không có thông báo tiêu cực.
- Chỉ **Papa/Mama** tạo hoặc đổi ảnh tháng chính; người thân chỉ xem. Ảnh bụng bầu mặc định nhắc **mỗi tuần** (đổi được thành mỗi 4 tuần).

#### 7.8.8 Gợi ý ghi lại (Memory prompts) [MVP]

- Mỗi ngày tối đa **1 gợi ý** cho mỗi Parent trên Trang chủ, theo tuổi/giai đoạn từng bé, ví dụ: “Con đang mê món đồ chơi nào?”, “Ghi lại tiếng cười của Haru tuần này”, “Hana đã nói câu gì làm bạn bật cười?”.
- Chạm → mở đúng loại ký ức (Câu nói, Giọng nói, Khoảnh khắc…) với câu hỏi điền sẵn làm gợi ý.
- **Bỏ qua** / **Gợi ý khác** (tối đa 3 lần/ngày) / **Tắt gợi ý** (Cài đặt). Không bao giờ có câu gây tội lỗi kiểu “Đã 5 ngày bạn chưa lưu ký ức”.
- Catalog gợi ý do Content quản lý (17.6), đa ngôn ngữ, không lặp trong 30 ngày.

#### 7.8.9 Hôm nay của con [MVP]

- Tất cả ký ức có **ngày xảy ra = hôm nay** của từng bé được gom thành **“Hôm nay của Hana”**.
- Trên Trang chủ: **dải tròn kiểu “story”** — mỗi bé một vòng tròn (ảnh mới nhất), viền màu bé khi có ảnh **mình chưa xem** do bạn đời/người thân đăng; chạm → xem dạng trình chiếu toàn màn hình (vuốt qua lại, thả cảm xúc nhanh, trả lời bằng bình luận).
- Mục đích: người đi làm cả ngày (thường là một trong hai bố mẹ) **xem ngay con hôm nay thế nào** chỉ trong vài giây.
- Cuối ngày (21:00, tuỳ chọn) nếu hôm nay có ≥ 3 ký ức → gợi ý “Gói lại thành Câu chuyện ngày của Hana?” (REC-01).
- Người thân thấy “Hôm nay của cháu” chỉ với ký ức họ có quyền xem.

---

### 7.9 Nhật ký, Thư gửi con & Time capsule [MVP]

**Nhật ký của bé** — ký ức dạng chữ dài; trình soạn thảo đơn giản (đậm, nghiêng, danh sách, chèn ảnh); có câu gợi ý theo tuổi (“Con đã nói được từ nào mới?”); có thể đặt tiêu đề; hiển thị trên timeline như thẻ chữ.

**Thư gửi con**
- Người viết: Parent (Circle Contributor có thể viết thư nếu gói Family — **[PO]**, khuyến nghị CÓ: “Thư của bà gửi cháu” rất giá trị).
- Nội dung: chữ / giọng nói / video.
- **Hẹn ngày mở** (Time capsule): chọn ngày (vd. sinh nhật 18 tuổi) hoặc sự kiện (“Khi con vào lớp 1” = ngày người dùng tự chọn). Trước ngày mở: thẻ niêm phong trên timeline (“💌 Thư của Bố — mở vào 12/03/2043”); **chỉ người viết** đọc/sửa được; Parent khác thấy *có thư* nhưng không đọc được nội dung (tôn trọng bất ngờ) — **[PO]**.
- Đến ngày mở: thông báo cho cả Bố/Mẹ; thư mở cho những ai theo visibility.
- Quy tắc lưu trữ dài hạn: time capsule **không bị xoá khi hết gói**; nằm trong file xuất dữ liệu.

**Nhật ký riêng** (trong Papa & Mama Space, mục 7.16): không gắn bé, chỉ người viết thấy.

---

### 7.10 Timeline [MVP]

Timeline kể câu chuyện theo thời gian, không chỉ là lưới ảnh.

**Cấu trúc**
- Header: avatar + tên bé + tuổi hiện tại (hoặc “Cả nhà” khi chọn Tất cả).
- Bộ lọc chip: `Tất cả` • `Cột mốc` • `Ảnh & video` • `Nhật ký` • `Thư` • `Thai kỳ` • `Từ người thân`.
- Nhóm theo **tháng tuổi** (chế độ bé) hoặc **tháng/năm** (chế độ Tất cả). Thanh cuộn nhanh theo năm/tháng ở cạnh phải.
- Mỗi thẻ hiển thị: ảnh/nhiều ảnh dạng lưới, chú thích rút gọn, tuổi bé tại thời điểm đó, avatar bé được gắn (khi ở chế độ Tất cả), biểu tượng visibility, số reaction/bình luận.

**Chương tháng (chế độ bé)** — mỗi tháng tuổi mở đầu bằng **thẻ chương**:
- Bìa = ảnh tháng (nếu chưa có: khung mờ “Thêm ảnh tháng 6”).
- Tiêu đề “Tháng thứ 6 của Haru” + khoảng ngày; số ký ức, những lần đầu, câu nói trong tháng; chạm “Xem lại tháng này” → trình chiếu tự động các ký ức của tháng [1.1].
- Cuối chương có thể có thẻ **Tổng kết tháng** (REC-03) nếu đã tạo.

**Thẻ đặc biệt**
| Thẻ | Khi nào |
|---|---|
| Phân cách tuần/tháng thai | Trong phần thai kỳ |
| Chào đời | Ngày sinh |
| Tròn tháng (“Hana tròn 5 tháng”) | Ngày tròn tháng, kèm nút Chụp ảnh tháng (7.8.7) |
| Đầy tháng / 100 ngày / Thôi nôi | Ngày tương ứng |
| Cột mốc | Nổi bật, có huy hiệu |
| Sinh nhật | |
| Tổng kết tuần/tháng | Khi recap được lưu |
| Thư niêm phong | Đến/chưa đến ngày mở |
| Câu nói của con | Thẻ trích dẫn lớn, nền màu bé |
| Cả hai cùng kể | Ký ức có góc nhìn của cả Papa & Mama |

**Quy tắc**
- Sắp xếp theo **ngày xảy ra** (không theo ngày đăng). Ký ức lùi ngày chèn đúng vị trí; feed Trang chủ thì sắp theo ngày đăng.
- Ký ức gắn nhiều bé chỉ hiển thị **1 thẻ** ở chế độ Tất cả.
- Ảnh chụp liên tục cùng ngày cùng người đăng (≥ 4 ký ức trong 2 giờ) → gộp thành nhóm “6 khoảnh khắc chiều nay” (mở ra xem từng cái).
- Bình luận không làm thay đổi thứ tự timeline.
- Ghim: Parent ghim tối đa 3 ký ức đầu timeline mỗi bé.

---

### 7.11 Cột mốc (Milestone) [MVP]

**Nguyên tắc:** cột mốc là *kỷ niệm*, không phải *chuẩn phát triển*. Không hiển thị “bé chậm/nhanh hơn bình thường”, không có độ tuổi “chuẩn” trong catalog hiển thị cho người dùng.

**Nhóm cột mốc** (catalog đầy đủ ở Phụ lục 17.2)
- 🇻🇳 **Truyền thống Việt**: Đầy tháng, 100 ngày, Thôi nôi, Tết đầu tiên, Trung thu đầu tiên, Cắt tóc máu, Lần đầu về quê.
- 😊 **Cảm xúc**: Nụ cười đầu tiên, Cười thành tiếng, Nhận ra Bố/Mẹ, Vẫy tay.
- 🤸 **Vận động**: Lẫy, Ngồi, Bò, Đứng, Bước đi đầu tiên.
- 🗣 **Ngôn ngữ**: Bập bẹ, Gọi “Bố/Mẹ”, Từ đầu tiên, Câu đầu tiên.
- 🍚 **Ăn uống**: Ăn dặm lần đầu, Món đầu tiên, Tự cầm thìa.
- 🦷 **Cơ thể**: Chiếc răng đầu tiên, Lần cắt tóc đầu tiên.
- 🌏 **Trải nghiệm**: Lần đầu đi biển, đi máy bay, đi công viên, đi nhà trẻ.
- 👨‍👩‍👧 **Gia đình**: Lần đầu gặp ông bà, Lần đầu gặp em, Sinh nhật đầu tiên.
- ✏️ **Tự tạo**.

**Luồng ghi cột mốc**
1. Từ Timeline > “+ Cột mốc” / Màn tạo ký ức > “Đánh dấu cột mốc” / thẻ gợi ý.
2. Chọn cột mốc từ catalog (tìm kiếm) hoặc tự tạo.
3. Chọn **1 bé** (cột mốc luôn thuộc 1 bé; sinh đôi cùng lẫy → tạo 2 cột mốc, có thể dùng chung 1 ký ức).
4. Ngày, ảnh/video, câu hỏi gợi ý: “Ai ở đó?”, “Con phản ứng thế nào?”, “Bố mẹ cảm thấy gì?”.
5. Lưu → thẻ cột mốc nổi bật + hiệu ứng chúc mừng + thông báo cho bạn đời & người thân được chia sẻ.

**Bảng “Những lần đầu”** của mỗi bé: lưới cột mốc đã có (ảnh) và chưa có (mờ, có thể ẩn toàn bộ phần chưa có nếu gia đình muốn).

**Quy tắc**
- Mỗi template cột mốc chỉ ghi **1 lần/bé** (trừ tự tạo); ghi lại → hỏi “Thay thế cột mốc cũ?”.
- Gia đình có thể tắt toàn bộ gợi ý cột mốc.
- Cột mốc truyền thống có ngày tính sẵn (đầy tháng = ngày sinh + 1 tháng; tuỳ chọn âm lịch) và nhắc trước 3 ngày.

---

### 7.12 Bảng tin gia đình, Bình luận, Cảm xúc [MVP]

**Bảng tin (Feed)** nằm ở Trang chủ (phần “Mới trong nhà”) và là màn chính của người thân.

| Nội dung trong feed | Parent | Người thân |
|---|---|---|
| Ký ức/cột mốc mới (theo quyền) | ✅ | ✅ |
| Ký ức người thân đăng (đã duyệt) | ✅ | ✅ |
| Thông báo chào đời, sinh nhật | ✅ | ✅ |
| “Ngày này năm xưa” | ✅ | ✅ (chỉ nội dung được phép) |
| Ảnh tháng, Câu nói của con, góc nhìn thứ hai | ✅ | ✅ theo visibility ký ức gốc |
| Nhiệm vụ hoàn thành có ảnh (đã thành ký ức) | ✅ | ✅ nếu visibility Cả nhà |
| Huy hiệu/Cây gia đình lớn | ✅ | 🔸 [PO] |
| Mood, lời nhờ, Hearts, xung đột, nhật ký riêng | ❌ không bao giờ | ❌ |

**Cảm xúc (reaction)**: ❤️ Thương • 😍 Đáng yêu • 😂 Buồn cười • 🥹 Xúc động • 👏 Giỏi quá. Mỗi người 1 reaction/ký ức (đổi được).

**Bình luận**
- Chữ (≤ 1.000 ký tự) + emoji. Không gửi ảnh trong bình luận (MVP).
- Trả lời 1 cấp (reply).
- Sửa trong 15 phút; xoá bất kỳ lúc nào (của mình). Parent xoá được mọi bình luận trong gia đình.
- Tắt bình luận theo từng ký ức.
- Nhắc tên (@Bà nội) [1.1].

**Thông báo gộp**: “Bà nội và 2 người khác đã thả tim ảnh của Hana” (gộp trong 30 phút).

---
### 7.13 Nhiệm vụ hằng ngày (Daily Missions) [MVP]

Nhiệm vụ là điểm khác biệt chính: mỗi ngày Papa và Mama có một **danh sách việc nhỏ, rõ ràng, chia đều** để cùng chăm con — giống một **“Cây nhiệm vụ của ngày”**: mỗi việc xong là một chiếc lá, cả nhà xong hết thì cây nở hoa. Nhiệm vụ **không phải công cụ giao việc** cho nhau; muốn nhờ bạn đời thì dùng **Lời nhờ** (7.16.2). *(Đã chốt C-14, C-15, C-16.)*

#### 7.13.1 Khái niệm

| Khái niệm | Mô tả |
|---|---|
| **Bảng nhiệm vụ hôm nay** | Toàn bộ nhiệm vụ của gia đình trong một ngày (theo múi giờ gia đình), chia 3 tab: **Của tôi** • **Của {bạn đời}** (vd. “Của Mama”) • **Cùng nhau** |
| **Chủ nhiệm vụ** | Một Parent (Papa *hoặc* Mama) hoặc **Cùng nhau**. Không có “Ai cũng được”, không có “giao cho bạn đời” |
| **Thư viện nhiệm vụ** | Danh sách nhiệm vụ định sẵn do đội Content soạn (17.1): tên, mô tả, giai đoạn bé/thai kỳ, category, vai trò phù hợp, thời lượng, **Hearts** |
| **Nguồn** | `SYSTEM` (hệ thống bày mỗi sáng) • `LIBRARY` (tự thêm từ thư viện) • `CUSTOM` (tự gõ) • `SERIES` (nhiệm vụ lặp) |
| **Hearts** | Điểm của từng nhiệm vụ; cộng vào **Hearts của tôi** (chỉ mình thấy) và góp vào **Cây gia đình** (7.14) |

**Gắn bé (phạm vi)** — giữ như cũ:

| Phạm vi | Gắn bé | Ví dụ | Hiển thị ở |
|---|---|---|---|
| **Một bé** | đúng 1 | Tắm cho Haru | Chăm con (Haru + Tất cả) |
| **Nhiều bé** | ≥ 2 | Đọc sách cho Hana & Haru | Cả hai bé + Tất cả |
| **Cả nhà** | 0 | Cả nhà đi công viên | Tất cả |
| **Hai ta** | 0 | 15 phút trò chuyện không điện thoại | Tab Cùng nhau + Papa & Mama |

**Category & Hearts mặc định** (mỗi template có thể đặt riêng 1–10, cấu hình ở Admin):

| Category | Ví dụ | Hearts |
|---|---|---|
| `CARE` – Chăm sóc | Thay tã, tắm, chuẩn bị đồ | 3–5 |
| `BONDING` – Gắn kết | Đọc sách, hát, nói chuyện | 5 |
| `PLAY` – Vui chơi | Peekaboo, xếp hình, tummy time | 5 |
| `OUTDOOR` – Ra ngoài | Đi dạo, công viên | 5 |
| `MEMORY` – Lưu kỷ niệm | Chụp ảnh tháng, ghi âm giọng bé | 3 |
| `SUPPORT` – Hỗ trợ bạn đời | Chuẩn bị bữa tối cho mẹ bầu, cho bạn đời 30 phút nghỉ | 5–8 |
| `SELF` – Chăm bản thân | Nghỉ trưa 30 phút, đi bộ nhẹ, uống đủ nước (mẹ bầu/sau sinh) | 3–5 |
| `PREP` – Chuẩn bị | Chuẩn bị túi đi sinh | 3–5 |
| `HOME` – Việc nhà liên quan bé | Giặt đồ bé, dọn góc chơi | 3 |
| `TOGETHER` – Cả nhà | Cả nhà đi dạo | 8–10 |
| `COUPLE` – Hai ta | 15 phút trò chuyện | 5 |
| `CUSTOM` – Tự gõ | | **2** (cố định) |

#### 7.13.2 Bày bảng nhiệm vụ mỗi ngày (định mức bằng nhau)

- Mỗi sáng **05:00 giờ gia đình**, hệ thống bày bộ nhiệm vụ `SYSTEM` cho **từng Parent** + nhiệm vụ **Cùng nhau**. Gia đình vừa kích hoạt giữa ngày → bày ngay.
- **Mức** (CARE-12, áp dụng **cho cả nhà**, Papa hoặc Mama đổi đều được, người kia nhận thông báo trung tính):

| Mức | Mỗi Parent | Cùng nhau |
|---|---|---|
| Nhẹ | 2 | 0–1 |
| **Vừa** (mặc định) | **3** | 1 |
| Nhiều | 4 | 1 |

- **Nguyên tắc cân bằng** (BR-019): hai bộ luôn **cùng số lượng** và **tổng Hearts lệch nhau ≤ 2** (mức Vừa ≈ 12–15 Hearts/người). Mục tiêu: công bằng về công sức, không chỉ về số việc.
- **Chọn nhiệm vụ theo:** tuổi từng bé / tuần thai • **vai trò & giai đoạn** • category người dùng tắt • không lặp lại trong 14 ngày • nhiều bé thì phân đều giữa các bé (mỗi bé ít nhất 1 việc/ngày nếu mức cho phép) • thời tiết/ngày lễ [phase sau].
- **Vai trò & giai đoạn** (vẫn giữ số lượng bằng nhau, chỉ đổi *nội dung*):

| Giai đoạn | Bộ của mẹ | Bộ của bố |
|---|---|---|
| Thai kỳ đến tuần 27 | Gắn kết với bé, lưu kỷ niệm, chuẩn bị, 1 việc `SELF` | Hỗ trợ mẹ bầu, chuẩn bị, gắn kết |
| Thai kỳ từ tuần 28 & 6 tuần đầu sau sinh | **Ưu tiên `SELF`** (nghỉ ngơi, đi bộ nhẹ, ăn uống) + việc gắn kết nhẹ | **Ưu tiên `SUPPORT` / `CARE`** |
| Sau 6 tuần | Như nhau, theo tuổi bé | Như nhau, theo tuổi bé |

  *Không gán việc theo giới*: “mẹ/bố” ở đây là vai trò sinh học trong thai kỳ/hậu sản; ngoài giai đoạn đó catalog dùng chung cho mọi Parent. **Người mang thai** mặc định là Parent có vai trò Mẹ; đổi được trong hồ sơ thai kỳ (trường *Người mang thai*).
- **Thao tác với nhiệm vụ hệ thống:** **Đổi** (CARE-05: hiện 3 lựa chọn có Hearts ±1 để giữ cân bằng; tối đa 3 lần/người/ngày — BR-019 được đảm bảo **lúc bày bảng**; sau khi đổi có thể lệch thêm tối đa ±3, chấp nhận được) • **Bỏ khỏi hôm nay** (không bị phạt, không báo bạn đời). Không có bước Nhận/Từ chối.
- Một Parent tắt bớt category → hệ thống vẫn bày đủ số lượng từ category còn lại.

#### 7.13.3 Tự thêm nhiệm vụ (CARE-03)

1. **Việc gì?** — chọn từ **Thư viện** (Hearts theo template) hoặc **tự gõ** (`CUSTOM`, 2 Hearts).
2. **Cho bé nào?** — Một bé / Nhiều bé / Cả nhà / Hai ta (mặc định bé đang chọn).
3. **Ai làm?** — **Tôi** hoặc **Cùng nhau** (“Hai ta” luôn là Cùng nhau). **Không có lựa chọn bạn đời** — dưới mục có dòng gợi ý: *“Muốn nhờ Mama một việc? Gửi lời nhờ →”* (mở US-03, điền sẵn việc đã chọn).
4. **Khi nào?** — Hôm nay / Ngày mai / Chọn ngày; khung giờ (tuỳ chọn); **Lặp lại** (7.13.6).
5. **Nhắc** — Không / Đúng giờ / Trước 15–30–60 phút.
6. **Gợi ý lưu kỷ niệm** (bật/tắt).
7. **Lưu**.

- Nhiệm vụ tự thêm **không tính vào định mức** hằng ngày (định mức chỉ áp dụng cho bộ `SYSTEM`).
- Nhiệm vụ **Cùng nhau** do một người tạo hiện ngay ở tab Cùng nhau của cả hai (người kia nhận 1 thông báo trung tính, gộp nếu nhiều).
- Chống “cày điểm”: `CUSTOM` tính Hearts tối đa **3 lần/người/ngày**; trần **75 Hearts/người/ngày** (BR-069).

#### 7.13.4 Hoàn thành nhiệm vụ

1. **Chủ nhiệm vụ tự bấm** ô tròn trên thẻ → hoàn thành ngay (1 chạm) + rung nhẹ + một chiếc lá mọc trên **Cây hôm nay** + “+5 💗” bay lên (chỉ người bấm thấy số).
2. Bottom sheet CARE-06 (có thể bỏ qua): “Lưu lại khoảnh khắc này?” → chụp/chọn ảnh, ghi chú → tạo **ký ức** gắn sẵn bé của nhiệm vụ (+2 Hearts khi có ảnh).
3. **Hoàn tác** trong 10 giây (snackbar; server chấp nhận tới 30 giây để bù trễ mạng) → thu hồi Hearts (bút toán ngược, không hiển thị “bị trừ”).

**Quy tắc**
- Chỉ **chủ nhiệm vụ** được bấm hoàn thành (BR-024). Bạn đời **không làm hộ** được; nếu thật sự đã làm giúp thì người chủ tự bấm (tin tưởng nhau).
- **Cùng nhau:** một trong hai bấm “Xong cùng nhau” → hoàn thành cho cả hai; **mỗi người đều nhận đủ Hearts** của nhiệm vụ. Người kia được báo nhẹ và có thể bấm 💛.
- Nhiệm vụ Nhiều bé hoàn thành **1 lần**, Hearts **1 lần/người**; lịch sử của từng bé đều ghi “Cùng với em Haru”. Bé vắng mặt → bỏ bé đó trước khi bấm Xong.
- **Không cần bằng chứng**: đính ảnh là tuỳ chọn.
- Bạn đời thấy dấu ✓ trên tab “Của Papa/Mama” và có nút **💛 Cảm ơn** nhanh (tạo lời cảm ơn ngắn, 7.16.3).

#### 7.13.5 State machine nhiệm vụ (chuẩn duy nhất cho nghiệp vụ & kỹ thuật)

```
 [hệ thống bày 05:00] ─┐
 [tự thêm / lặp]  ─────┴──► TODO ──Hoàn thành──► DONE
                             │  ▲                  │
                             │  └──Hoàn tác (10s)──┘
                             ├──Đổi / Bỏ khỏi hôm nay / Xoá──► REMOVED
                             └──Hết ngày 23:59──► EXPIRED ──Ghi muộn (đến hết ngày hôm sau)──► DONE (late)
```

| Trạng thái | Ý nghĩa | Ai thấy |
|---|---|---|
| `TODO` | Chưa làm (có thể có giờ/nhắc) | Cả hai Parent (tab tương ứng) |
| `DONE` | Đã xong (cờ `late` nếu ghi muộn) | Cả hai — Hearts chỉ chủ nhiệm vụ thấy |
| `EXPIRED` | Hết ngày chưa làm | Chỉ chủ nhiệm vụ, trong lịch sử, màu trung tính |
| `REMOVED` | Đã đổi / bỏ khỏi hôm nay / xoá | Không hiển thị (chỉ lưu nhật ký) |

> Thay cho 9 trạng thái cũ (SUGGESTED/PENDING/DECLINED/AWAITING_CONFIRM/…). Mọi việc liên quan đến “nhờ”, “nhận”, “từ chối” thuộc **Lời nhờ** (7.16.2).

**Hết ngày:** lúc 21:00 (nếu bật) hỏi nhẹ với **nhiệm vụ tự thêm** chưa làm: “Chuyển *Đọc sách* sang ngày mai?” [Chuyển] [Thôi]. Nhiệm vụ `SYSTEM` hết hạn **im lặng** (sáng mai đã có bộ mới). Không bao giờ có thông báo tiêu cực, không trừ điểm.

#### 7.13.6 Nhiệm vụ lặp lại

- Chỉ cho **nhiệm vụ tự thêm**: Hằng ngày • Ngày thường • Cuối tuần • Chọn thứ • Mỗi N ngày • Hằng tháng (ngày X).
- Hệ thống tạo trước các lần lặp cho 14 ngày tới; không tính vào định mức.
- Sửa 1 lần lặp → hỏi “Chỉ lần này” / “Lần này và các lần sau”.
- **Tạm dừng chuỗi** (đi công tác, về quê): chọn khoảng ngày. Không trừ điểm.
- Hearts từ nhiệm vụ lặp: tối đa 1 lần/chuỗi/ngày.

#### 7.13.7 Hiển thị theo tab

| Tab | Thấy gì | Thao tác |
|---|---|---|
| **Của tôi** | Nhiệm vụ của tôi hôm nay (hệ thống + tự thêm), **Hearts của tôi hôm nay** ở đầu tab, Hearts từng nhiệm vụ | Hoàn thành, Đổi, Bỏ khỏi hôm nay, Sửa (tự thêm) |
| **Của {bạn đời}** | Danh sách nhiệm vụ của bạn đời + dấu ✓ khi xong. **Không hiển thị Hearts** | Chỉ xem; 💛 Cảm ơn trên việc đã xong |
| **Cùng nhau** | Nhiệm vụ Cùng nhau / Hai ta | Xong cùng nhau |

- Đầu màn CARE-01 luôn có **Cây hôm nay** (dùng chung): mỗi việc xong của bất kỳ ai = 1 chiếc lá; khi **cả hai** hoàn thành hết bộ hệ thống và việc Cùng nhau → cây **nở hoa** 🌸 (“Hôm nay nhà mình đã chăm con thật tròn đầy”). Chỉ đếm số việc, **không hiển thị Hearts**.
- Lời nhờ đang mở **không nằm trong tab nhiệm vụ**; CARE-01 chỉ có 1 dòng nhỏ “1 lời nhờ đang mở →” mở US-04.

#### 7.13.8 Bàn giao ca (Handoff) [1.1]

Bố/Mẹ bấm “Bàn giao” → ghi nhanh tình trạng bé (đã ăn lúc…, đã ngủ lúc…, ghi chú tự do) → bạn đời nhận thẻ tóm tắt. Nếu cần bạn đời làm tiếp việc gì → gửi kèm **Lời nhờ**. Không phải tracker y tế.

---

### 7.14 Hearts & Cây gia đình [MVP]

#### 7.14.1 Hearts của tôi (riêng tư)

- Mỗi Parent có **Hearts của riêng mình**. **Chỉ chính người đó thấy** (CARE-01 tab Của tôi, CARE-06, CARE-09). Bạn đời, người thân, recap, thông báo, xuất dữ liệu gia đình **không bao giờ** hiển thị Hearts của người khác (BR-018).
- Hearts của Papa + Mama **góp chung** vào **Cây gia đình**.
- Bảng điểm (cấu hình ở Admin):

| Hành động | Hearts (cho người làm) | Giới hạn |
|---|---|---|
| Hoàn thành nhiệm vụ | Theo template (1–10) | Lặp: 1 lần/chuỗi/ngày |
| Hoàn thành nhiệm vụ tự gõ (`CUSTOM`) | 2 | 3 lần/người/ngày |
| Nhiệm vụ Cùng nhau | Đủ Hearts **cho mỗi người** | |
| Đính ảnh khi hoàn thành | +2 | 5 lần/người/ngày |
| Hoàn thành **Lời nhờ một việc** (7.16.2) | +5 | |
| Tạo ký ức có nội dung | +2 | 5 lần/người/ngày |
| Ghi cột mốc | +5 | |
| Gửi lời cảm ơn | +2 | 3 lần/người/ngày |
| Lời nhờ “Mình đang cần…” (ôm, động viên…) | **0** — tình cảm không quy đổi điểm | |
| Người thân thả tim/bình luận | 0 | |
| Bỏ / hết hạn / từ chối lời nhờ | **0** | **Không bao giờ âm** |
| **Trần** | | **75 Hearts/người/ngày** |

- Hoàn tác → thu hồi Hearts tương ứng (ledger ghi bút toán ngược, không hiển thị “bị trừ”).
- Khu vực cá nhân hiển thị tích cực: “Tuần này bạn góp 120 💗 cho cây nhà mình” — màn này **không nhắc tới bạn đời**.
- *Lưu ý thiết kế:* bạn đời vẫn có thể *đoán* gián tiếp (thấy dấu ✓). Nguyên tắc không phải giấu tuyệt đối mà là **không bao giờ đặt hai con số cạnh nhau để so sánh**.

#### 7.14.2 Cây gia đình (cấp độ)

- Cây = tổng Hearts của Papa + Mama, hiển thị bằng **hình ảnh, cấp độ và thanh tiến độ (%)** tới cấp sau. **Không hiển thị tổng Hearts theo ngày/tuần** của gia đình.

| Cấp | Tên | Hearts tích luỹ | Phần thưởng (trang trí) |
|---|---|---|---|
| 1 | 🌱 Hạt mầm | 0 | — |
| 2 | 🌿 Mầm non | 100 | Sticker gói 1 |
| 3 | 🪴 Cây non | 300 | Khung ảnh tháng |
| 4 | 🌳 Cây xanh | 700 | Theme màu “Rừng xanh” |
| 5 | 🌸 Cây trổ hoa | 1.500 | Theme “Hoa anh đào” |
| 6 | 🍊 Cây kết trái | 3.000 | Thẻ Recap đặc biệt |
| 7 | 🏡 Cây cổ thụ | 6.000+ | Mỗi 3.000 tiếp theo: một “quả” mới trên cây |

- Mỗi ngày cây nở hoa (7.13.7) được lưu thành một **bông hoa** trên cây lớn (bộ sưu tập “Những ngày tròn đầy”).
- Hearts **không đổi thành tiền/quà**, không mở khoá tính năng thiết yếu.
- Không có streak gây tội lỗi. Có thể hiển thị “Tuần này cây nhà mình nở 4 bông hoa” (đếm ngày, không đếm điểm, không so sánh).
- **Phiếu yêu thương** (đổi Hearts lấy phần thưởng do hai người tự đặt cho nhau) — **[Backlog]**, cân nhắc sau khi có số liệu sử dụng.

#### 7.14.3 Huy hiệu

Danh sách ở Phụ lục 17.4. Nguyên tắc: tên tích cực, mô tả hành vi (không mô tả con người), không có huy hiệu “Bố/Mẹ tốt nhất”, không so với gia đình khác. Huy hiệu là của **gia đình** (trừ huy hiệu Grandparent ghi nhận người thân).

---

### 7.15 Thống kê chăm con của nhà mình [1.1 – gói House/Family]

> Chỉ phản ánh hoạt động **được ghi trong app**, ở **mức gia đình**. Không có phân chia theo người (đã bỏ “Cân bằng chăm sóc theo người” vì mâu thuẫn với C-15).

**Hiển thị (CARE-11)**
- Số nhiệm vụ cả nhà đã hoàn thành trong tuần theo category (biểu đồ cột): Chăm sóc 12 • Gắn kết 8 • Ra ngoài 3 • Hỗ trợ nhau 4 • Cùng nhau 5.
- Theo từng bé (chọn ở switcher); số ngày cây nở hoa trong tuần.
- Disclaimer cố định: *“Chỉ dựa trên hoạt động ghi trong app. Còn rất nhiều điều bố mẹ làm cho nhau mà app không đếm được.”*

**Quy tắc**
- Không phân chia theo người, không gợi ý “ai làm ít hơn”.
- Không dùng làm dữ liệu cho Cầu nối hay AI.
- Người thân không thấy; không gửi push.
- Nhiệm vụ “Hai ta” không tính vào chăm con.

---

### 7.16 Papa & Mama Space (Couple Space) [MVP]

Không gian riêng **chỉ dành cho hai Parent**, độc lập với bé đang chọn. Màu chủ đạo riêng (tím oải hương) và biểu tượng 🔒 “Chỉ hai bạn” để luôn nhận biết đây là vùng riêng tư.

**Trạng thái khoá:** gia đình chưa đủ 2 Parent → màn giới thiệu + nút Mời bạn đời.

**Khối chức năng**

| Khối | Chức năng | Phase |
|---|---|---|
| **Hôm nay của hai ta** | Mood của tôi, mood bạn đời đã chia sẻ, lời nhờ đang mở, câu hỏi kết nối trong ngày | MVP |
| **Check-in cảm xúc** | 7.16.1 | MVP |
| **Lời nhờ** | 7.16.2 (tính năng riêng, tách khỏi Nhiệm vụ) | MVP |
| **Lời cảm ơn** | 7.16.3 | MVP |
| **Nhật ký riêng** | 7.16.4 | MVP |
| **Nhiệm vụ hai ta** | Catalog COUPLE (7.13) | MVP |
| **Cầu nối** | 7.17 | 1.1 (không AI) / 1.2 (AI viết lại) |
| **Tuần của hai ta** | Tổng kết check-in, hỗ trợ, cảm ơn (chỉ hai người xem) | 1.1 |
| **Ngày của hai ta** | Kỷ niệm ngày cưới/ngày quen (nhắc) | 1.1 |

#### 7.16.1 Check-in cảm xúc

1. Chọn cảm xúc (biểu tượng lớn): 😊 Ổn • 🙂 Bình thường • 😪 Mệt • 🥱 Kiệt sức • 😣 Căng thẳng • 😢 Buồn • 😠 Khó chịu • 🤯 Quá tải • 🥺 Cô đơn • 🤗 Cần được quan tâm.
2. Năng lượng 1–5 (tuỳ chọn, thanh pin).
3. “Mình cần…” (tuỳ chọn): Nghỉ ngơi • Giúp trông con • Yên tĩnh • Một cái ôm • Nói chuyện • Được động viên.
4. Ghi chú (tuỳ chọn, ≤ 500 ký tự).
5. **Chia sẻ với bạn đời** (mặc định: theo cài đặt cá nhân — lần đầu hỏi) / **Chỉ mình tôi**.
6. Nếu chia sẻ: chọn phần nào chia sẻ (cảm xúc ✓, năng lượng ✓, nhu cầu ✓, ghi chú ☐ — ghi chú mặc định **không** chia sẻ).

**Quy tắc**
- Mood hiện tại hết hiệu lực sau **6 giờ** hoặc 0:00, cái nào đến trước; sau đó chỉ còn trong lịch sử của người tạo (và của bạn đời nếu đã chia sẻ).
- Bạn đời phản hồi nhanh: 👀 “Mình thấy rồi” • 💬 “Cần gì không?” • 🙋 “Để mình lo” (tạo Lời nhờ đã nhận, 7.16.2) • 🤗 “Ôm”.
- Chọn **“Khó chịu với bạn đời”** (biến thể của Khó chịu) → app **không** gửi gì, chỉ hỏi “Bạn muốn dùng Cầu nối không?”.
- Tắt chia sẻ mood bất kỳ lúc nào mà vẫn giữ liên kết bạn đời.
- Xoá lịch sử mood của mình (giữ lời cảm ơn).
- Thông báo cho bạn đời: “Mẹ vừa chia sẻ trạng thái” — không lộ cảm xúc trên màn hình khoá (mặc định).

#### 7.16.2 Lời nhờ (Requests) — tính năng riêng, tách khỏi Nhiệm vụ

Lời nhờ là cách **duy nhất** để nhờ bạn đời làm gì đó (C-16). Nằm trong Papa & Mama (US-03/US-04), có lối tắt ở Tạo nhanh (QC-01) và dòng gợi ý trong CARE-03.

**Hai nhóm**

| Nhóm | Nội dung | Ví dụ câu mẫu | Lựa chọn của bạn đời | Hearts |
|---|---|---|---|---|
| **Nhờ một việc** (`TASK`) | Chọn từ thư viện nhiệm vụ hoặc tự gõ; bé (tuỳ chọn); khi nào: Bây giờ / Hôm nay lúc… / Tối nay / Ngày mai; lời nhắn | “Tối nay anh tắm cho Haru giúp em nhé, em hơi mệt 💛” | **Nhận** • **Hôm nay không được** | +5 cho **người làm** khi xong |
| | Cần nghỉ 15/30/60 phút (trông con giúp) | “Mình cần nghỉ khoảng 30 phút. Bạn trông Haru giúp mình nhé?” | Nhận • Hôm nay không được | +5 |
| **Mình đang cần…** (`NEED`) | Cần yên tĩnh | “Mình cần yên tĩnh một chút để hồi lại.” | Đã hiểu (bật khung yên tĩnh cho người gửi) | 0 |
| | Cần một cái ôm | “Mình không cần giải pháp, chỉ cần một cái ôm.” | Gửi 🤗 • Đã làm | 0 |
| | Muốn nói chuyện | “Mình muốn nói chuyện khi cả hai bình tĩnh.” | Ngay bây giờ • Tối nay • Chọn giờ | 0 |
| | Cần động viên | “Hôm nay mình cần nghe một lời động viên.” | Gửi lời cảm ơn/động viên | 0 |

- Lời nhắn có câu mẫu; phát hiện ngôn ngữ gay gắt → gợi ý viết lại (từ điển từ khoá [MVP], AI [1.2]).
- Mức: **Bình thường** / **Sớm nhé** (không có “Khẩn cấp” — app không phải dịch vụ khẩn cấp).
- **Hôm nay không được**: lý do nhanh tuỳ chọn (“Hôm nay anh về muộn”, “Em đang trông Hana”) — **không bị phạt**, người gửi nhận thông báo trung tính và có nút “Tự mình làm” (tạo nhiệm vụ của tôi từ lời nhờ).
- Sau khi **Nhận**, người làm bấm **Đã xong** ở US-04 (hoặc ngay trên thông báo) → người gửi nhận “Papa đã tắm cho Haru 💛” + nút **Cảm ơn**; người làm nhận +5 Hearts (chỉ người đó thấy).
- Check-in: bạn đời bấm **“Để mình lo”** → tạo Lời nhờ `TASK` ở trạng thái **Đã nhận** (tự nhận, `volunteered`).

**State machine**

```
SENT ──(người nhận mở)──► SEEN ──Nhận──► ACCEPTED ──Đã xong──► DONE (+5 Hearts cho người làm, chỉ TASK)
  │                        ├──Hôm nay không được──► DECLINED
  │                        └──(NEED) Đã thấy / Gửi 🤗 / Chọn giờ──► ACKNOWLEDGED
  ├──Người gửi huỷ──► CANCELLED
  └──Quá hạn──► EXPIRED   (TASK: 2 giờ sau thời điểm hẹn — “Bây giờ” = lúc gửi; hẹn tối đa 7 ngày • NEED: 12 giờ)
```

**Quy tắc** (BR-067…070)
- Tối đa **5 lời nhờ đang mở/người gửi**.
- Bị từ chối → không gửi lại **cùng nội dung** trong 12 giờ. **Không có nút “giục”**; tối đa 1 lần nhắc do **người nhận** chọn (“Nhắc mình lúc 19:00”).
- Tôn trọng giờ yên tĩnh và trạng thái “Cần yên tĩnh” của người nhận (lời nhờ không “Sớm nhé” được giữ lại tới khi hết khung).
- Lời nhờ **không xuất hiện trong tab nhiệm vụ**; hiển thị ở US-01 “Lời nhờ đang mở”, thẻ Papa & Mama trên HOME-01, thông báo, và 1 dòng nhắc nhỏ ở CARE-01.
- `NEED` không bao giờ quy đổi Hearts. Người thân không bao giờ thấy lời nhờ.

#### 7.16.3 Lời cảm ơn (Appreciation)

1. Chọn câu mẫu hoặc viết tự do (≤ 500 ký tự), chọn sticker.
2. Có thể gắn với nhiệm vụ/ký ức cụ thể.
3. Mặc định **chỉ hai người** thấy. Tuỳ chọn “Đăng thành khoảnh khắc gia đình” → **cần bạn đời đồng ý** trước khi hiện ở feed.
4. Bạn đời thả cảm xúc / “Cảm ơn lại”.
- Bức tường cảm ơn (US-06): lịch sử lời cảm ơn hai chiều — một kho kỷ niệm đẹp của hai người.
- Gợi ý gửi cảm ơn tối đa 2–3 lần/tuần (không mỗi ngày).

#### 7.16.4 Nhật ký riêng (Private journal)

- Ghi chép cá nhân: chữ, ảnh (tuỳ chọn), cảm xúc.
- **Chỉ người viết** thấy. Không có quyền admin/bạn đời/AI nào đọc được trừ khi người viết bấm “Chia sẻ đoạn này với bạn đời” (gửi bản sao dạng tin nhắn, có xem trước chính xác).
- Có thể khoá thêm bằng Face ID.
- Không đưa vào Recap, Year Book, xuất dữ liệu chung — chỉ có trong *xuất dữ liệu cá nhân* của chính người viết.

---

### 7.17 Cầu nối khi bất đồng (Conflict Bridge) [1.1]

Tính năng nhạy cảm nhất. Mục tiêu: **giảm nhiệt → nói rõ cảm xúc/nhu cầu → chọn một bước nhỏ tiếp theo**. App không giải quyết hôn nhân thay người dùng.

#### 7.17.1 Luồng

**Giai đoạn 1 – Riêng tư (chỉ người bắt đầu)**
1. Bắt đầu từ Papa & Mama > “Tụi mình đang có chuyện” hoặc từ mood “Khó chịu với bạn đời”.
2. Chọn cảm xúc: Tổn thương • Tức giận • Kiệt sức • Bị hiểu lầm • Quá tải • Thất vọng.
3. Chọn chủ đề (tuỳ chọn): Chăm Hana • Chăm Haru • Chia việc nhà • Tài chính • Thời gian cho nhau • Gia đình hai bên • Khác.
4. “Mình cần lúc này”: Không gian riêng • Được lắng nghe • Một lời xin lỗi • Giúp đỡ thực tế • Nói chuyện bình tĩnh • Sự quan tâm.
5. Viết nháp riêng (tuỳ chọn) — **không bao giờ** được gửi nguyên văn tự động.
6. Kiểm tra an toàn (7.17.3).
7. “Bạn muốn làm gì với nội dung này?” → **Giữ riêng** (kết thúc, như một nhật ký) / **Viết lại trước khi gửi** (AI [1.2] hoặc gợi ý câu mẫu [1.1]) / **Chọn ý để chia sẻ**.
8. Xem trước **chính xác** nội dung bạn đời sẽ nhận → **Gửi lời mời**.

**Giai đoạn 2 – Lời mời**
- Bạn đời nhận: “Mẹ muốn dùng một không gian bình tĩnh để trao đổi khi bạn sẵn sàng.” (không chi tiết trên màn hình khoá).
- Lựa chọn: **Tham gia ngay** • **Để sau** (chọn thời điểm: tối nay/ngày mai/tự chọn) • **Chưa sẵn sàng** (tạm dừng, không thông báo tiêu cực).

**Giai đoạn 3 – Cùng tham gia**
1. Bạn đời cũng đi qua bước 2–7 của giai đoạn 1 (riêng tư).
2. Màn **song song** hiển thị những gì mỗi người *đã chọn chia sẻ*: “Mẹ cảm thấy: kiệt sức • Mẹ cần: giúp đỡ thực tế” | “Bố cảm thấy: bị hiểu lầm • Bố cần: được lắng nghe”.
3. Mỗi người bấm **“Mình hiểu”** hoặc **“Mình cần nói rõ hơn”** (mở thêm 1 lượt gửi ý).
4. Chọn **một bước tiếp theo**: Nghỉ 20 phút • Bố/Mẹ trông con 30 phút • Nói lại sau khi con ngủ • Nhờ nhau một việc ngày mai (Lời nhờ) • Ôm nhau • Hẹn giờ nói chuyện • Tự nhập.
5. Hai bên xác nhận bước tiếp theo (có thể tạo lời nhờ/nhắc tự động).
6. Sau thời điểm đã chọn → app hỏi: “Hai bạn muốn đóng phiên này chứ?” → cả hai đồng ý → `RESOLVED`; có thể gửi lời cảm ơn.

#### 7.17.2 Trạng thái phiên

`PRIVATE_DRAFT` → `INVITED` → `ACTIVE` ⇄ `PAUSED` → `AGREED` (đã chọn bước tiếp) → `RESOLVED` / `CLOSED` (một bên đóng) / `EXPIRED` (không hoạt động 14 ngày).

#### 7.17.3 Nhánh an toàn (Safety branch) — luôn miễn phí

- Nếu nội dung nháp có dấu hiệu sợ hãi, đe doạ, bạo lực (từ điển từ khoá tiếng Việt [1.1] + AI phân loại [1.2]) hoặc người dùng chọn “Mình cảm thấy không an toàn”:
  - **Dừng** mọi gợi ý “hãy nói chuyện trực tiếp”.
  - Hiển thị màn hỗ trợ: giữ nội dung riêng tư; số điện thoại hỗ trợ (vd. Tổng đài quốc gia bảo vệ trẻ em **111**, đường dây hỗ trợ phòng chống bạo lực gia đình theo khu vực, **113** khi khẩn cấp — Content phải xác minh danh sách trước khi phát hành); gợi ý liên hệ người tin cậy.
  - **Không thông báo** cho bạn đời rằng người dùng đã xem màn này.
  - Không lưu dấu vết trong lịch sử phiên mà bạn đời có thể thấy.
- App không kết luận có bạo lực; không định vị là dịch vụ khẩn cấp/trị liệu.

#### 7.17.4 Quy tắc

- Không tự gửi nháp; không công bố lên feed; không có điểm thắng/thua; không gamify số phiên đã giải quyết.
- Mỗi người có thể rời/tạm dừng bất kỳ lúc nào.
- **Lưu trữ ngắn**: nháp riêng và nội dung phiên tự xoá sau **30 ngày** kể từ khi đóng (tuỳ chọn 7/30/90 ngày, hoặc “Xoá ngay khi đóng”). Chỉ giữ dòng “Đã có một phiên Cầu nối ngày…” (người dùng có thể xoá luôn).
- Một bên xoá tài khoản giữa phiên → phiên đóng ngay; nội dung riêng của người xoá bị xoá, của người còn lại giữ theo thời hạn lưu.

---

### 7.18 AI hỗ trợ [1.2]

AI chỉ chạy khi **người dùng chủ động bấm**. Mọi đầu ra là **bản nháp** để người dùng sửa/bỏ/lưu. Tắt AI toàn bộ trong Cài đặt mà app vẫn dùng đầy đủ.

| Tính năng | Đầu vào (chỉ những gì user cho phép) | Đầu ra | Kiểm soát |
|---|---|---|---|
| Gợi ý chú thích | Vài từ người dùng gõ + loại ký ức + tuổi bé (không gửi ảnh ở MVP AI; gửi ảnh cần đồng ý riêng [2.0]) | 3 gợi ý chú thích | Chọn/Sửa/Bỏ |
| Câu chuyện ngày | Chú thích các ký ức + nhiệm vụ đã hoàn thành trong ngày của bé (người dùng tick chọn) | Đoạn 3–6 câu | Xem lại trước khi lưu |
| Gợi ý nhiệm vụ | Nhóm tuổi bé, category ưa thích, lịch sử 14 ngày (tổng hợp) | 3–5 nhiệm vụ | Đổi/Tắt category |
| Viết lại nhẹ nhàng | Câu người dùng chọn | 3 phiên bản: Trung tính • Ấm áp • Ngắn gọn | Không tự gửi |
| Tóm tắt Cầu nối | Chỉ các ý **đã chia sẻ** trong phiên | Bản “hiểu nhau” trung tính | Cả hai xem; không dùng nháp riêng |
| Recap tuần | Ký ức + hoạt động gia đình | Đoạn tổng kết | Sửa/Chia sẻ |

**AI tuyệt đối không**: tự gửi tin; đọc nhật ký riêng; chẩn đoán trầm cảm/rối loạn/bệnh; kết luận ai đúng/sai; chấm điểm tình yêu/hôn nhân; tư vấn y khoa cho bé; tạo nội dung công khai từ ảnh bé; bịa sự kiện không có trong dữ liệu.

**Minh bạch**: nhãn “✨ Gợi ý bởi AI” trên mọi bản nháp; nút **Báo cáo nội dung AI** (bắt buộc theo Google Play); màn giải thích dữ liệu nào được gửi cho nhà cung cấp AI (lần đầu dùng mỗi tính năng — hỏi đồng ý).

---

### 7.19 Tổng kết (Recap) [MVP: tuần; 1.1: ngày, tháng; 2.0: năm]

| Loại | Thời điểm | Phạm vi | Nội dung |
|---|---|---|---|
| **Câu chuyện ngày** | 21:00 nếu bé có ≥ 2 ký ức trong ngày (gợi ý, không tự tạo) | Theo bé hoặc cả nhà | Ảnh bìa + 3–6 câu (tự viết hoặc AI) |
| **Tuần của nhà mình** | Chủ nhật 19:00 | Cả nhà + từng bé | Số ký ức, cột mốc, hoạt động cùng nhau, 5–10 ảnh nổi bật, reaction được yêu thích, lời cảm ơn (chỉ Parent thấy phần Papa & Mama) |
| **Tháng tuổi** | Ngày tròn tháng của bé | Từng bé | “Tháng thứ 5 của Hana”: ảnh tháng, cột mốc, ảnh chọn lọc |
| **Năm / Sinh nhật** [2.0] | Sinh nhật bé / 31/12 | Từng bé hoặc cả nhà | Year Story nhiều chương; xuất PDF “Sách của con” |

**Quy tắc**
- Không bao giờ có câu so sánh “tuần này Mẹ làm nhiều hơn Bố”.
- Tuần ít hoạt động → “Một tuần bình yên 🌿”, không cảnh báo.
- Recap gia đình loại trùng ký ức chung nhiều bé; recap từng bé chỉ lấy ký ức gắn bé đó.
- Không đưa nội dung Papa & Mama, nhật ký riêng, ký ức “Chỉ mình tôi” vào recap chia sẻ.
- Parent xem lại trước khi chia sẻ recap với người thân.

---

### 7.20 Lịch & Sự kiện [MVP cơ bản]

| Loại | Ví dụ | Ai thấy |
|---|---|---|
| Nhiệm vụ | Tắm cho Haru 19:30 | Parent |
| Sự kiện của bé | Sinh nhật, đầy tháng, thôi nôi, buổi chụp ảnh | Parent + người thân nếu “Mời cả nhà” |
| Sự kiện gia đình | Ông bà lên thăm, về quê | Như trên |
| Hẹn của hai ta | Nói chuyện tối nay, hẹn hò | Chỉ Parent |
| Nhắc lưu kỷ niệm | Ảnh tháng, viết thư | Người tạo |
| Ghi chú khám/tiêm | Chỉ là ghi chú tự do (không có lịch tiêm gợi ý) | Parent |

- Tạo sự kiện: tiêu đề, loại, ngày (dương hoặc **âm lịch**), giờ/cả ngày, lặp hằng năm, bé liên quan, người tham gia, nhắc.
- Sau sự kiện của bé → gợi ý “Lưu ảnh của buổi thôi nôi?”.
- Đồng bộ lịch điện thoại [2.0].

---

### 7.21 Thông báo & Chế độ yên tĩnh [MVP]

**Nhóm thông báo** (bật/tắt riêng từng nhóm)

| Nhóm | Ví dụ | Mặc định | Nhạy cảm |
|---|---|---|---|
| Ký ức & bình luận | “Bà nội vừa bình luận ảnh của Hana” | Bật (gộp) | Không |
| Nhiệm vụ | “Hôm nay bạn có 3 việc nhỏ cho Haru 🌱” (1 lần/ngày, 7:00) • nhắc giờ do mình đặt | Bật | Không |
| Lời nhờ | “Mama nhờ bạn: Tắm cho Haru tối nay 🛁” / “Papa đã nhận lời nhờ” | Bật | Có thể ẩn |
| Papa & Mama | “Mẹ vừa chia sẻ trạng thái” / “Mẹ cần một chút hỗ trợ” | Bật sau khi giải thích | **Có** |
| Cầu nối | “Có một lời mời trò chuyện bình tĩnh” | Bật | **Có** |
| Lời cảm ơn | “Bạn nhận được một lời cảm ơn ❤️” | Bật | Có thể hiện nội dung nếu bật |
| Cột mốc & ngày đặc biệt | “Ngày mai Hana tròn 6 tháng” | Bật | Không |
| Tổng kết | “Tuần của nhà mình đã sẵn sàng” | Bật | Không |
| Người thân (chỉ Circle) | Bản tin hằng ngày 19:00 hoặc tức thì | Bản tin | Không |
| Gói dịch vụ | Hết hạn, thanh toán lỗi | Bật (không tắt được thông báo bắt buộc về thanh toán trong app) | Không |
| Khuyến mãi | | **Tắt** (chỉ bật khi đồng ý) | Không |

**Quy tắc**
- Tối đa **3 thông báo không gấp/người/ngày** (không tính lời nhờ).
- Gộp reaction/bình luận trong 30 phút.
- Một sự kiện gắn nhiều bé → **1 thông báo** (“Đọc sách cùng Hana & Haru”).
- Thông báo theo bé luôn nêu tên bé.
- **Ẩn nội dung trên màn hình khoá** (mặc định BẬT cho nhóm nhạy cảm): tiêu đề “Baby Family”, nội dung “Bạn có một cập nhật mới từ Papa & Mama”.
- **Giờ yên tĩnh**: mặc định 22:00–6:30 (cha mẹ con nhỏ có thể đổi). Trong giờ yên tĩnh, thông báo được gom gửi sau. Lời nhờ “Sớm nhé” **vẫn tôn trọng** giờ yên tĩnh của người nhận trừ khi người nhận tự bật “Cho phép lời nhờ từ bạn đời vượt giờ yên tĩnh”.
- Một người không thể bật thông báo của người kia.
- Tắt thông báo theo từng người thân (mute).
- Hộp thư thông báo trong app (NOTI-01) lưu 90 ngày.

---

### 7.22 Tìm kiếm, Lọc, “Ngày này năm xưa” [MVP cơ bản / 1.1 đầy đủ]

- **Tìm kiếm**: chữ trong chú thích/nhật ký, tên cột mốc, tên album, người đăng, tháng/năm, tuổi của bé (“6 tháng”).
- **Lọc**: loại (ảnh/video/nhật ký/thư/cột mốc), bé (Tất cả/từng bé/anh chị em/thai kỳ), người đăng, năm.
- **Ngày này năm xưa**: thẻ trên Trang chủ khi có ký ức cùng ngày các năm trước (chế độ Tất cả loại trùng; chế độ bé chỉ ký ức của bé). Có thể tắt. Không hiện ký ức đã xoá/ẩn, ký ức thai kỳ đã lưu trữ riêng tư.
- **Hồi tưởng** [1.1]: ngẫu nhiên một ký ức cũ (chỉ nội dung được phép).
- Tìm theo khuôn mặt: **không làm** (dữ liệu sinh trắc học trẻ em — rủi ro pháp lý).

---

### 7.23 Quyền riêng tư & phạm vi chia sẻ [MVP]

#### 7.23.1 Mức hiển thị của ký ức

| Mức | Biểu tượng | Ai thấy | Mặc định khi |
|---|---|---|---|
| **Chỉ mình tôi** | 🔒 | Người tạo | Nháp, ký ức muốn giữ riêng |
| **Papa & Mama** | 👫 | Hai Parent | Gói House (vì không có người thân); ảnh album “Tắm bé” |
| **Cả nhà** | 👨‍👩‍👧‍👦 | Hai Parent + người thân có quyền với **ít nhất một bé được gắn** (hoặc mọi người thân đang hoạt động nếu là Khoảnh khắc gia đình không gắn bé) | Gói Family |
| *Chọn người cụ thể* | | | [2.0] |
| *Công khai* | | **Không hỗ trợ** | — |

- Mặc định cấu hình ở Cài đặt > Quyền riêng tư > “Ai thấy ký ức mới”.
- Ký ức gắn Hana + Haru, Bà nội chỉ được chia sẻ Hana, visibility Cả nhà → Bà **thấy** ký ức, nhưng thẻ chỉ hiển thị “Hana” — **ẩn hoàn toàn** tên/avatar Haru (không hiển thị kiểu “và 1 bé khác”) — và không mở được hồ sơ Haru. Tuỳ chọn nâng cao [1.1]: “Chỉ người được chia sẻ *tất cả* các bé trong ảnh”.
- Đổi visibility bất kỳ lúc nào; thu hẹp visibility có hiệu lực ngay (ảnh biến mất khỏi máy người không còn quyền ở lần đồng bộ sau; link ảnh cũ hết hạn trong ≤ 1 giờ).

#### 7.23.2 Bảo vệ ảnh nhạy cảm của trẻ

- Album gợi ý **“Tắm bé & riêng tư”** — mặc định visibility *Bố mẹ*, không cho tải về với người thân.
- Khi Parent chọn visibility *Cả nhà* cho ảnh trong album này → nhắc 1 lần: “Ảnh này sẽ hiện với X người thân. Tiếp tục?”.
- Không có bất kỳ đường chia sẻ công khai nào trong app.
- Chính sách & Điều khoản cấm tuyệt đối nội dung khai thác/xâm hại trẻ em; có quy trình báo cáo & xử lý theo pháp luật (7.24).

#### 7.23.3 Quy tắc bảo vệ Papa & Mama Space

- Quyền quản trị gia đình **không** đồng nghĩa quyền đọc dữ liệu riêng của bạn đời.
- Mood/nhật ký/nháp xung đột thuộc người tạo cho đến khi chia sẻ.
- Không xuất hiện trong xuất dữ liệu gia đình, recap, feed, thông báo cho người thân.
- Khi một Parent xoá tài khoản: dữ liệu Papa & Mama của người đó bị xoá; người còn lại giữ phần của mình (7.25.3).

#### 7.23.4 Bảng điều khiển quyền riêng tư (Privacy dashboard)

Parent xem được trên 1 màn: ai đang thấy bé nào, ai được tải về, ai được đăng, ký ức nào đang “Cả nhà”, các thiết bị đang đăng nhập, AI đang bật tính năng nào.

---

### 7.24 Báo cáo, Chặn, Kiểm duyệt [MVP]

**Báo cáo** (từ menu ký ức/bình luận/thành viên/nội dung AI):
1. Chọn lý do: Không phù hợp • Quấy rối • Vấn đề quyền riêng tư • **Lo ngại an toàn trẻ em** • Spam • Nội dung AI có vấn đề • Khác.
2. Mô tả thêm (tuỳ chọn).
3. Tuỳ chọn “Ẩn nội dung/người này với tôi ngay”.
4. Gửi → mã báo cáo; trạng thái hiển thị trong Cài đặt > Báo cáo của tôi.
5. Nếu người báo cáo là Parent → thêm lựa chọn **Gỡ khỏi gia đình** (nội dung) / **Gỡ người thân**.
6. Sau xử lý: thông báo kết quả chung (“Chúng tôi đã xử lý báo cáo của bạn”), không lộ thông tin người bị báo cáo.

**Trạng thái báo cáo:** `NEW` → `TRIAGE` → `IN_REVIEW` → `ACTION_TAKEN` / `NO_VIOLATION` / `NEED_INFO` → `CLOSED`. Lý do “an toàn trẻ em” → ưu tiên cao nhất, SLA xử lý 24 giờ, nội dung bị **ẩn tạm thời** ngay khi có báo cáo đến khi kiểm duyệt xong.

**Chặn:**
- Chặn người thân: người bị chặn không bình luận/reaction vào nội dung của người chặn; không nhận thông báo liên quan. Nếu người chặn là Parent → khuyến nghị kèm lựa chọn gỡ khỏi gia đình.
- Người thân chặn Parent: chỉ ẩn bình luận qua lại; nội dung bé vẫn hiển thị (vì Parent là chủ). Nếu muốn ngừng hẳn → người thân Rời gia đình (7.25.1).
- Hai Parent không chặn nhau trong app (có thể tắt chia sẻ mood trong Papa & Mama).

**Hành động kiểm duyệt (admin):** không xử lý • gỡ nội dung • cảnh báo • tạm khoá • gỡ khỏi gia đình • khoá tài khoản • chuyển pháp lý/cơ quan chức năng. Mọi hành động có ghi chú lý do + audit.

---

### 7.25 Rời gia đình, Xoá tài khoản, Xuất dữ liệu [MVP]

#### 7.25.1 Người thân rời gia đình
Cài đặt > Rời gia đình → xác nhận → mất quyền ngay. Nội dung đã đăng: *giữ lại cho gia đình* (mặc định) hoặc *gỡ toàn bộ*. Parent nhận thông báo trung tính.

#### 7.25.2 Bố/Mẹ rời gia đình, tách bạn đời — **tạm thời không hỗ trợ** (BR-057)
- Bố/Mẹ **không có** nút rời gia đình hay tách liên kết bạn đời trong MVP. Có thể tắt chia sẻ mood, xoá lịch sử mood/nhật ký riêng của mình.
- Trường hợp duy nhất một Parent ra khỏi gia đình: **xoá tài khoản** (bắt buộc theo Apple/Google, 7.25.3) → gia đình chuyển `PARTNER_LEFT`.
- Tranh chấp/hoàn cảnh đặc biệt (ly hôn…) → CSKH hỗ trợ thủ công; tính năng rời gia đình/co-parenting để phase sau.

#### 7.25.3 Xoá tài khoản (bắt buộc theo Apple/Google)
1. Cài đặt > Tài khoản > Xoá tài khoản (cũng có trang web xoá tài khoản cho Google Play).
2. Màn tác động: dữ liệu riêng sẽ xoá (nhật ký riêng, mood, nháp…), nội dung đã chia sẻ (ký ức đã đăng: *giữ lại cho gia đình dưới tên “Người dùng đã rời”* hoặc *xoá*), gói đang trả (hướng dẫn huỷ ở Store — app không tự huỷ được gói Store).
3. Nếu là **Parent duy nhất** → bắt buộc chọn: *Xoá cả gia đình* (mọi bé, ký ức — sau 30 ngày) hoặc *mời người khác làm Parent trước*.
4. Nếu còn bạn đời → bạn đời tiếp tục giữ gia đình ở trạng thái `PARTNER_LEFT` (chỉ xem & tải về, có thể mời bạn đời mới); dữ liệu Papa & Mama của người xoá bị xoá.
5. Xác thực lại (OTP/Apple/Google) → xác nhận.
6. Đăng xuất mọi thiết bị ngay; tài khoản ở trạng thái **chờ xoá 30 ngày** (đăng nhập lại để khôi phục); sau 30 ngày xoá vĩnh viễn; gửi xác nhận.
- Không xoá nội dung của người khác (bình luận của bà trên ảnh của mẹ vẫn của bà).

#### 7.25.4 Xuất dữ liệu
- **Xuất gia đình** (Parent): ZIP gồm ảnh/video gốc tốt nhất hiện có + file `memories.json`/`.csv` (ngày, chú thích, bé, cột mốc) + trang HTML xem offline. Không gồm dữ liệu Papa & Mama.
- **Xuất cá nhân** (mọi người): dữ liệu do chính mình tạo, gồm nhật ký riêng, mood, lời cảm ơn đã gửi/nhận.
- Xử lý nền, gửi thông báo khi xong; link tải hết hạn 7 ngày, cần đăng nhập.

---

### 7.26 Vận hành nội dung & Chăm sóc khách hàng [MVP]

**Admin CMS — nghiệp vụ cần có**

| Module | Khả năng |
|---|---|
| Catalog nhiệm vụ | Tạo/sửa/ẩn template; category, độ tuổi (ngày tuổi min–max hoặc tuần thai), phạm vi, vai trò phù hợp, thời lượng, **mức Hearts** (cân bằng bảng ngày), câu gợi ý ký ức, bản dịch, % rollout |
| Catalog cột mốc | Như trên, gồm cột mốc truyền thống & cách tính ngày |
| Mood/Nhu cầu/Câu mẫu | Nhãn, emoji, câu mẫu theo ngôn ngữ |
| Câu gợi ý nhật ký/cảm ơn/câu hỏi kết nối | Theo độ tuổi/giai đoạn |
| Huy hiệu & Cây gia đình | Điều kiện, ảnh, ngưỡng |
| Nội dung tuần thai | “Bé to bằng…” (có review chuyên môn) |
| Thông báo | Template theo ngôn ngữ, bật/tắt |
| Banner/Thông báo hệ thống | Lịch hiển thị, đối tượng (gói, nền tảng) |
| Gói & quota | Quota theo gói, giá hiển thị, trial |
| Kiểm duyệt | Hàng đợi báo cáo, case, hành động, audit |
| CSKH | Tra cứu tài khoản/gia đình (metadata), gửi lại lời mời, lịch sử gói, yêu cầu xoá |
| Nguồn hỗ trợ an toàn | Danh sách đường dây nóng theo khu vực |
| Feature flags | Bật/tắt AI, tính năng thử nghiệm |

**CSKH — tình huống thường gặp**

| Tình huống | Hướng xử lý |
|---|---|
| Không nhận được lời mời | Kiểm tra link/hạn → gửi lại → thu hồi link cũ |
| Không thấy ảnh | Kiểm tra visibility, bé được gắn, quyền người thân, trạng thái duyệt |
| Ông bà không đăng nhập được | Hướng dẫn OTP, đổi phương thức |
| Bị gỡ khỏi gia đình | Giải thích quyền thuộc Parent; kênh khiếu nại nếu liên quan lạm dụng |
| Muốn tắt AI | Hướng dẫn Cài đặt > AI; giải thích dữ liệu |
| Mua gói nhưng chưa có quyền lợi | Khôi phục giao dịch → admin đồng bộ lại với Store |
| Trùng gói (2 người mua) | Hướng dẫn huỷ + xin hoàn tiền Apple/Google |
| Lo ngại an toàn | Không tư vấn trị liệu; cung cấp nguồn hỗ trợ |
| Xoá tài khoản | Hướng dẫn in-app/web; theo dõi trạng thái |

### 7.27 Đa ngôn ngữ [MVP]

**Mục tiêu:** mọi người trong gia đình dùng app bằng ngôn ngữ của mình (ví dụ con cháu ở nước ngoài dùng tiếng Anh, ông bà ở Việt Nam dùng tiếng Việt), và hệ thống mở rộng sang ngôn ngữ mới mà không phải sửa từng màn hình.

**Ngôn ngữ hỗ trợ**

| Giai đoạn | Ngôn ngữ | Ghi chú |
|---|---|---|
| MVP | Tiếng Việt (`vi`) — **mặc định & ngôn ngữ gốc** | Mọi nội dung soạn trước bằng tiếng Việt |
| MVP | English (`en`) | Bản dịch đầy đủ trước khi phát hành |
| 2.x (dự kiến) | Ngôn ngữ khác theo thị trường (vd. 日本語, 한국어) | Thêm bằng bản dịch + cấu hình, không đổi thiết kế |

**Phạm vi được dịch**

| Thành phần | Được dịch? | Ai dịch / nguồn |
|---|---|---|
| Giao diện app (nút, tiêu đề, thông báo lỗi, trạng thái rỗng, hướng dẫn) | ✅ | Team sản phẩm (file ngôn ngữ của app) |
| Nội dung hệ thống: catalog nhiệm vụ, cột mốc, cảm xúc/nhu cầu, câu mẫu, câu gợi ý, huy hiệu, cấp Cây gia đình, nội dung tuần thai | ✅ | Content — nhập bản dịch ở Admin |
| Thông báo đẩy, hộp thông báo, email/SMS hệ thống (OTP, xoá tài khoản) | ✅ theo ngôn ngữ **người nhận** | Template theo ngôn ngữ ở Admin |
| Thông báo lỗi từ server | ✅ theo ngôn ngữ của người gửi yêu cầu | Server |
| Đầu ra AI (gợi ý chú thích, viết lại, câu chuyện ngày) | ✅ theo ngôn ngữ người dùng đang dùng | AI được yêu cầu trả đúng ngôn ngữ |
| Paywall, tên gói, giá | ✅ (giá & tiền tệ do App Store/Google Play địa phương hoá) | Store + app |
| Điều khoản, Chính sách quyền riêng tư, trang hỗ trợ, trang xoá tài khoản | ✅ mỗi ngôn ngữ một bản | Pháp chế / Content |
| Store listing (mô tả, ảnh chụp màn hình) | ✅ vi + en | Marketing |
| **Nội dung người dùng tạo** (chú thích, nhật ký, bình luận, thư, tên bé, tên gia đình) | ❌ **Không tự dịch** — hiển thị đúng như người viết | — |

**Chọn và đổi ngôn ngữ**
1. Lần đầu mở app: dùng ngôn ngữ của thiết bị nếu được hỗ trợ; nếu không → Tiếng Việt.
2. Đổi ngôn ngữ ở **Welcome (ONB-01)** (nút chọn ngôn ngữ góc trên) và **Cài đặt > Hiển thị & Ngôn ngữ (SET-06)**. Có hiệu lực **ngay**, không cần khởi động lại app.
3. Ngôn ngữ là **lựa chọn của từng người**, không phải của gia đình: Mẹ dùng English, Bà nội dùng Tiếng Việt trong cùng một gia đình là bình thường.
4. Khi đã đăng nhập, ngôn ngữ được lưu vào tài khoản để thông báo đẩy/email gửi đúng ngôn ngữ dù người đó đang ở máy khác. Đăng xuất không làm mất lựa chọn ngôn ngữ trên máy.

**Định dạng theo ngôn ngữ**
- Ngày, giờ, số theo quy ước từng ngôn ngữ (vi: `07/10/2026`, `7 thg 10, 2026`; en: `10/7/2026`, `Oct 7, 2026`). Giờ dùng 24h ở cả hai (cấu hình được về sau).
- Tuổi bé, đếm ngược, số lượng dùng quy tắc số nhiều của từng ngôn ngữ (en: “1 day left / 3 days left”; vi: “Còn 3 ngày”).
- **Múi giờ tách biệt với ngôn ngữ**: đổi ngôn ngữ không đổi múi giờ gia đình.
- **Âm lịch** (cột mốc truyền thống, ngày âm) là tính năng văn hoá, hiển thị ở mọi ngôn ngữ nếu gia đình bật; tên cột mốc truyền thống có bản dịch kèm giải nghĩa ngắn ở tiếng Anh (vd. “Đầy tháng — 1-month celebration”).
- Nhãn gọi mặc định **Papa / Mama** giống nhau ở mọi ngôn ngữ (không dịch); nhãn người dùng tự đặt (Bố, Ba, Má, Dad, Mom…) giữ nguyên ở mọi ngôn ngữ.

**Thiếu bản dịch (fallback)**
- Giao diện app: bắt buộc đủ bản dịch mọi ngôn ngữ trước khi phát hành (kiểm tra tự động).
- Nội dung hệ thống từ Admin: thiếu bản dịch ngôn ngữ người dùng → dùng **English**, thiếu tiếp → **Tiếng Việt**. Admin cảnh báo mục nào chưa dịch; template thông báo bắt buộc đủ vi + en mới bật được.

**Quy tắc thiết kế cho đa ngôn ngữ**
- Bố cục chịu được chữ dài hơn tiếng Việt ~40%; không cắt chữ ở nút, tab, thẻ.
- Không ghép câu từ nhiều mảnh (ngữ pháp mỗi ngôn ngữ khác nhau); mỗi câu là một chuỗi dịch hoàn chỉnh có chỗ trống cho biến (tên bé, số ngày…).
- Ảnh minh hoạ không chứa chữ.

**Tiêu chí nghiệm thu:** xem AC-080…AC-086 (mục 14.2).

---
## 8. Kiến trúc thông tin & điều hướng

### 8.1 Sitemap — Parent

```
App
├── [Khởi động] SPL-01 → ONB-01 Welcome → AUTH-01..04 → ONB-03 Vai trò → ONB-06/07 → ONB-WAIT → ONB-ACT → ONB-04..10
│                 (Người thân: ONB-03 → CIR-WAIT) • INV-01..05 • SUB-07 khi hết hạn
│
├── TAB 1: Trang chủ (HOME-01 Tất cả | HOME-02 Một bé | HOME-03 Thai kỳ)
│     ├── SW-01 Bộ chuyển bé (sheet)
│     ├── NOTI-01 Hộp thông báo
│     ├── FAM-* (qua avatar góc trái: Gia đình & Cài đặt)
│     └── Thẻ: Nhiệm vụ hôm nay → CARE-01 | Ký ức mới → MEM-07 | Papa & Mama → US-01 | Recap → REC-*
│
├── TAB 2: Ký ức
│     ├── MEM-01 Timeline   ── MEM-07 Chi tiết → MEM-08 Xem ảnh/video, MEM-10 Bình luận, MEM-09 Sửa
│     ├── MEM-20 Con lớn từng tháng ── MEM-21 Chụp ảnh tháng | MEM-22 Bộ sưu tập | MEM-23 Câu nói | MEM-24 Góc nhìn | MEM-25 Hôm nay của bé
│     ├── MEM-02 Ảnh (lưới) ── MEM-03 Album → MEM-03a Chi tiết album
│     ├── MEM-12 Những lần đầu (cột mốc)
│     ├── PREG-01..04 Thai kỳ (khi chọn thai kỳ)
│     ├── MEM-15 Tìm kiếm | MEM-16 Ngày này năm xưa
│     └── MEM-17 Thùng rác | MEM-18 Nháp | MEM-19 Chờ duyệt (ảnh người thân)
│
├── TAB 3: [ + ] Tạo nhanh (QC-01 sheet)
│     ├── Ký ức → MEM-04 → MEM-05 → MEM-06
│     ├── Nhật ký → MEM-13 | Thư gửi con → MEM-14
│     ├── Cột mốc → MEM-11
│     ├── Nhiệm vụ → CARE-03
│     ├── Check-in → US-02 | Lời nhờ → US-03 | Cảm ơn → US-05
│     └── Sự kiện → CAL-02
│
├── TAB 4: Chăm con
│     ├── CARE-01 Hôm nay (tab Của tôi / Của bạn đời / Cùng nhau) ── CARE-02 Chi tiết, CARE-05 Đổi nhiệm vụ, CARE-06 Hoàn thành
│     ├── CARE-07 Lịch tuần/tháng ── CAL-02 Tạo sự kiện
│     ├── CARE-04 Thư viện nhiệm vụ
│     ├── CARE-09 Cây gia đình ── CARE-10 Huy hiệu
│     ├── CARE-11 Thống kê chăm con
│     ├── CARE-08 Lịch sử
│     └── CARE-12 Cài đặt nhiệm vụ
│
├── TAB 5: Papa & Mama (US-00 khoá | US-01 trang chính)
│     ├── US-02 Check-in | US-03 Gửi lời nhờ | US-04 Chi tiết lời nhờ
│     ├── US-05 Gửi cảm ơn | US-06 Bức tường cảm ơn
│     ├── US-07 Nhật ký riêng
│     ├── US-08..13 Cầu nối & An toàn
│     ├── US-14 Tuần của hai ta
│     └── US-15 Cài đặt Papa & Mama
│
└── Gia đình & Cài đặt (avatar góc trái trên Trang chủ)
      ├── FAM-01 Tổng quan gia đình ── CHD-01..05 Các con, FAM-02 Mời bạn đời
      ├── FAM-03 Mời người thân ── FAM-04 Chi tiết người thân, FAM-05 Lời mời đang chờ
      ├── FAM-07 Cài đặt gia đình
      ├── SUB-01..06 Gói dịch vụ
      ├── SET-01..13 Cài đặt cá nhân
      └── REC-* Tổng kết đã lưu
```

### 8.2 Thanh điều hướng dưới (Bottom navigation)

**Parent (5 mục):**

| # | Icon | Nhãn | Ghi chú |
|---|---|---|---|
| 1 | 🏠 | Trang chủ | |
| 2 | 🖼 | Ký ức | |
| 3 | ➕ (nút tròn lớn, màu chính) | — | Mở Tạo nhanh |
| 4 | ✅ | Chăm con | Chấm nhỏ khi tôi còn nhiệm vụ hôm nay (không hiện số) |
| 5 | 💞 | Papa & Mama | Chấm nhỏ khi có lời nhờ/cảm ơn mới (không hiện số) |

**Người thân (Circle) (4 mục):** 🏠 Cháu yêu (feed) • 🖼 Ký ức • ➕ Đăng ảnh (chỉ Contributor; Viewer/Commenter ẩn mục này) • 👤 Tôi (cài đặt, cỡ chữ, rời gia đình).

### 8.3 Thanh trên (App bar)

- **Trang chủ:** trái = avatar gia đình (mở Gia đình & Cài đặt) • giữa = Bộ chuyển bé (chip) • phải = 🔔 thông báo.
- **Ký ức / Chăm con:** tiêu đề tab • Bộ chuyển bé • 🔍 / lịch.
- **Papa & Mama:** tiêu đề “Papa & Mama 🔒 Chỉ hai bạn” • ⚙️. **Không có** bộ chuyển bé.

### 8.4 Deep link (người dùng thấy)

| Link | Mở |
|---|---|
| `https://babyfamily.vn/i/{code}` | Lời mời (INV-01) |
| `babyfamily://memory/{id}` | MEM-07 |
| `babyfamily://mission/{id}` | CARE-02 |
| `babyfamily://request/{id}` | US-04 |
| `babyfamily://us` | US-01 |
| `babyfamily://child/{id}` | HOME-02 |
| `babyfamily://recap/{id}` | REC-* |

Mở link tới nội dung không có quyền → màn “Nội dung không khả dụng” (không tiết lộ nội dung tồn tại hay không).

---

## 9. Đặc tả chi tiết từng màn hình

> **Quy ước:** mỗi màn mô tả *Mục đích • Ai thấy • Điểm vào • Bố cục • Hành động • Trạng thái • Quy tắc • Điều hướng*. “Trạng thái chuẩn” = Loading (skeleton) • Empty • Error (thử lại) • Offline (dữ liệu cache + banner “Đang ngoại tuyến”). Chỉ ghi khi khác chuẩn.

### 9.1 Khởi động & Tài khoản

#### SPL-01 — Splash
- **Mục đích:** khởi tạo, kiểm tra phiên, kiểm tra phiên bản bắt buộc cập nhật.
- **Bố cục:** logo + nền kem; không có chữ dài.
- **Logic điều hướng:** chưa đăng nhập → ONB-01 • có link mời đang chờ → INV-01 • chưa chọn vai trò → ONB-03 • vai trò Người thân chưa có gia đình → CIR-WAIT • gia đình `WAITING_PARTNER` → ONB-WAIT • vừa kích hoạt, chưa thiết lập bé → ONB-ACT/ONB-04 • gói **Hết hạn** → SUB-07 (Parent) / CIR-05 (người thân) • bình thường → HOME-01 (hoặc CIR-01 nếu là người thân) • có khoá ứng dụng → màn Face ID/PIN • phiên bản quá cũ → màn “Cần cập nhật” (nút Store).
- **Quy tắc:** tối đa 2 giây; nếu mất mạng nhưng có cache → vào app chế độ offline.

#### ONB-01 — Welcome
- **Bố cục:** góc trên phải: nút chọn ngôn ngữ (🌐 Tiếng Việt ▾ — mở bộ chọn, đổi ngay); 3 slide minh hoạ: (1) “Lưu giữ hành trình của con từ khi còn trong bụng mẹ” (2) “Bố mẹ cùng chăm con bằng những việc nhỏ mỗi ngày” (3) “Ông bà cùng theo dõi cháu — riêng tư, an toàn”. Chấm trang; nút **Bắt đầu**; link “Tôi có lời mời”.
- **Hành động:** Bắt đầu → AUTH-01 • Tôi có lời mời → AUTH-01 rồi INV-05 (nhập mã).

#### AUTH-01 — Đăng nhập
- **Bố cục:** logo nhỏ, tiêu đề “Chào mừng đến Baby Family”, 3 nút lớn: *Tiếp tục với Apple* (iOS hiển thị trên cùng theo HIG) • *Tiếp tục với Google* • *Dùng số điện thoại*. Dòng nhỏ: “Bằng việc tiếp tục, bạn đồng ý Điều khoản và Chính sách quyền riêng tư” (link).
- **Trạng thái:** loading trên nút đang bấm; lỗi “Không thể đăng nhập, thử lại” (snackbar).
- **Điều hướng:** thành công → tài khoản mới: AUTH-04 • tài khoản cũ: SPL logic.

#### AUTH-02 — Nhập số điện thoại
- **Bố cục:** mã quốc gia (mặc định +84, chọn được), ô số điện thoại (bàn phím số), nút **Gửi mã**. Chữ nhỏ: “Mã sẽ gửi qua Zalo hoặc SMS”.
- **Quy tắc:** chuẩn hoá số (bỏ 0 đầu), kiểm tra định dạng VN; giới hạn gửi (7.1).

#### AUTH-03 — Nhập mã OTP
- **Bố cục:** 6 ô số (tự điền từ SMS trên Android/iOS khi có), đếm ngược 60s “Gửi lại mã”, link “Gửi qua SMS thay vì Zalo”, “Đổi số điện thoại”.
- **Trạng thái:** sai mã → rung + “Mã chưa đúng, còn 4 lần thử”; hết hạn → “Mã đã hết hạn, gửi lại nhé”.

#### AUTH-04 — Hồ sơ cơ bản
- **Bố cục:** avatar (chạm để chọn ảnh, tuỳ chọn), ô “Tên của bạn” (bắt buộc, điền sẵn từ Apple/Google nếu có), checkbox “Tôi đồng ý Điều khoản sử dụng” (bắt buộc), checkbox “Tôi đồng ý cho Baby Family xử lý dữ liệu cá nhân của tôi và con tôi theo Chính sách” (bắt buộc), nút **Tiếp tục**.
- **Quy tắc:** lưu phiên bản điều khoản đã đồng ý + thời điểm.

#### INV-01 — Xem lời mời
- **Ai:** người mở link/nhập mã hợp lệ (đã đăng nhập).
- **Bố cục:** ảnh bìa + tên gia đình; avatar người mời “**Lan (Mẹ)** mời bạn tham gia”; **Vai trò**: “Bố của các bé” *hoặc* “Bà nội — xem & bình luận”; danh sách bé được chia sẻ (avatar + tên — không ảnh album); lời nhắn của người mời; khung “Bạn sẽ thấy / Bạn sẽ không thấy”; nút **Tham gia** (chính), **Từ chối** (phụ).
- **Biến thể Parent:** thêm bước chọn cách gọi (Bố/Ba/Cha…) trước khi Tham gia.
- **Điều hướng:** Tham gia → (nếu cần duyệt) INV-04 • HOME-01/CIR-01 + màn chào mừng.

#### INV-02 — Lời mời không hợp lệ
- **Biến thể:** hết hạn / đã dùng / đã bị thu hồi / không tồn tại → cùng 1 thông điệp chung “Lời mời không còn hiệu lực. Nhờ người mời gửi lại link mới nhé.” (không tiết lộ lý do chi tiết để tránh dò mã).

#### INV-03 — Bạn đang là Bố/Mẹ ở gia đình khác
- **Bố cục:** giải thích “Mỗi tài khoản chỉ là Bố/Mẹ của một gia đình”, lựa chọn: *Tham gia như người thân* (nếu lời mời là Parent → không khả dụng) • *Tìm hiểu cách rời gia đình hiện tại* • *Huỷ*.

#### INV-04 — Chờ xác nhận
- “Đã gửi yêu cầu. Lan sẽ xác nhận để hoàn tất.” + nút Đóng. Khi được xác nhận → push “Chào mừng về nhà!”.

#### INV-05 — Nhập mã mời
- Ô nhập 8 ký tự (không phân biệt hoa thường), nút Quét QR (mở camera — xin quyền camera tại đây).

### 9.2 Chọn vai trò, tạo gia đình & kích hoạt

> Thứ tự (BR-050…054): AUTH-04 → **ONB-03 Vai trò** → (Bố/Mẹ) ONB-06 Tên gia đình → **ONB-07 Mời bạn đời (bắt buộc)** → **ONB-WAIT** → (bạn đời tham gia) **ONB-ACT** → ONB-04 → ONB-05a/b → ONB-08 → ONB-10 → ONB-09 → HOME-01. (Người thân) ONB-03 → **CIR-WAIT**.

#### ONB-02 — Bắt đầu thế nào? *(bỏ — gộp vào ONB-03)*
- Màn ONB-03 có dòng “Tôi đã có mã mời” (→ INV-05) nên không cần màn riêng.

#### ONB-03 — Bạn là ai trong gia đình? (bắt buộc)
- 3 thẻ lớn: 👨 **Bố** • 👩 **Mẹ** • 👵 **Người thân** (ông bà, cô dì chú bác, người chăm bé). Dòng dưới: “Tôi đã có mã mời / link mời” → INV-05.
- Chọn Bố/Mẹ → hàng chip “Các con gọi bạn là”: **Papa** (chọn sẵn) / Bố / Ba / Cha / Tía / *Khác…* (hoặc **Mama** (chọn sẵn) / Mẹ / Má / Mạ / U / *Khác…*) → **Tiếp** (→ ONB-06).
- Chọn Người thân → **Tiếp** (→ CIR-WAIT).
- **Quy tắc:** không có nút bỏ qua; nhãn gọi đổi được trong Cài đặt.

#### ONB-06 — Tên gia đình
- Ô tên (điền sẵn “Nhà Lan”), ảnh bìa (chọn ảnh hoặc 6 hình minh hoạ). **Tạo gia đình** → tạo gia đình `WAITING_PARTNER` → ONB-07.

#### ONB-07 — Mời bạn đời (bắt buộc)
- Minh hoạ 2 người; “Mời **Bố** để bắt đầu. Baby Family cần cả Bố và Mẹ cùng tham gia.”; nút **Gửi lời mời qua Zalo/Messenger…** (share sheet, tin nhắn soạn sẵn có link), **Hiện mã QR** (bạn đời quét khi ngồi cạnh), **Sao chép link / mã 8 ký tự**. **Không có “Để sau”.**
- Công tắc “Tôi xác nhận lần cuối khi Bố tham gia” (mặc định BẬT).
- Sau khi chia sẻ (hoặc bấm “Đã gửi”) → ONB-WAIT.

#### ONB-WAIT — Chờ bạn đời
- **Ai:** Parent A khi gia đình `WAITING_PARTNER`. Mở app luôn vào màn này (không vào được tab nào).
- **Bố cục:** minh hoạ ngôi nhà đang sáng đèn; “Đang chờ **Bố** tham gia…”; trạng thái lời mời (Đã tạo lúc… • Hết hạn sau 6 ngày • *Bố đã mở link* nếu đã resolve); nút **Gửi lại lời mời**, **Hiện mã QR**, **Đổi cách mời** (tạo link mới, vô hiệu link cũ); thẻ giải thích “Sau khi Bố tham gia, nhà mình được **dùng thử miễn phí 3 tháng**”; link nhỏ: “Huỷ gia đình này” (chọn lại vai trò / nhận lời mời người khác), Cài đặt tài khoản, Đăng xuất.
- **Trạng thái:** có người chấp nhận & cần xác nhận → thẻ nổi bật “**Minh** muốn tham gia làm **Bố**” [Xác nhận] [Không phải người này]; lời mời hết hạn → “Lời mời đã hết hạn” + [Tạo lời mời mới].
- **Quy tắc:** nhắc Parent A gửi lại lời mời sau 2 ngày, 5 ngày (push nhẹ, tối đa 3 lần).

#### ONB-ACT — Nhà mình đã đủ Bố và Mẹ
- Hiệu ứng chúc mừng; “Bắt đầu **3 tháng dùng thử miễn phí** — đến hết ngày dd/mm/yyyy”; dòng nhỏ “Sau đó cần đăng ký gói House (399.000đ/năm) hoặc Family (599.000đ/năm) để tiếp tục”; nút **Thiết lập cho bé** → ONB-04. Hiển thị cho **cả hai** Parent (lần đầu mở app sau kích hoạt).
- Nếu gia đình không đủ điều kiện dùng thử (5.4 chống lạm dụng) → thay bằng “Chọn gói để bắt đầu” → SUB-01.

#### ONB-04 — Nhà mình đang ở giai đoạn nào?
- 3 thẻ: 🤰 **Đang mang thai** • 👶 **Bé đã chào đời** • 👧🤰 **Đã có bé và đang mang thai**.
- Nếu bạn đời đã thiết lập xong trước → bỏ qua, vào thẳng HOME-01 với thông báo “Ba đã thêm Hana”.

#### ONB-05a — Thai kỳ
- Ô tên ở nhà (gợi ý ngẫu nhiên: Đậu, Bơ, Cà Chua…), chọn **Ngày dự sinh** *hoặc* “Mình biết tuần thai” (tuần 4–42), số bé (1/Song thai/Ba bé), ảnh bìa (tuỳ chọn). Nút **Tiếp** / “Bỏ qua ngày dự sinh”.
- Xem trước: “Tuần 24 • còn 112 ngày gặp Bơ”.

#### ONB-05b — Hồ sơ bé
- Avatar, tên/tên ở nhà, ngày sinh (bắt buộc), giới tính (tuỳ chọn). “+ Thêm bé khác”. **Tiếp**.

#### ONB-08 — Quyền riêng tư của nhà mình
- 3 khối icon: 🔒 “Chỉ người được mời mới thấy ảnh của con” • 💞 “Papa & Mama là góc riêng — ông bà không bao giờ thấy” • 🗑 “Bạn có thể tải về hoặc xoá dữ liệu bất cứ lúc nào”. Nút **Mình hiểu rồi**.

#### ONB-09 — Ký ức đầu tiên
- “Lưu khoảnh khắc đầu tiên của Hana trong Baby Family” → **Chọn ảnh** (→ MEM-04) / “Để sau”.

#### ONB-10 — Bật thông báo (pre-permission)
- Hiển thị **ngay ở ONB-WAIT** lần đầu (để Parent A nhận được thông báo khi bạn đời tham gia) và với Parent B sau khi tham gia. Giải thích lợi ích, nút **Bật thông báo** → hộp thoại hệ thống; “Để sau”.
- **Quy tắc:** người dùng từ chối hệ thống → không hỏi lại trong 7 ngày; Cài đặt có hướng dẫn mở lại.

#### CIR-WAIT — Chờ lời mời (vai trò Người thân)
- **Ai:** người chọn “Người thân” nhưng chưa thuộc gia đình nào. Mở app luôn vào màn này.
- **Bố cục (chữ lớn mặc định):** “Bà cần được Bố/Mẹ của bé mời vào gia đình”; 3 nút lớn: **Nhập mã mời** (→ INV-05), **Quét mã QR**, **Nhờ con mời mình** (share sheet tin nhắn soạn sẵn: “Con ơi, mẹ đã cài Baby Family, con mời mẹ vào xem cháu nhé” + link tải app); link nhỏ “Tôi là Bố/Mẹ của bé” (quay lại ONB-03), Đăng xuất.
- **Quy tắc:** không dùng được tính năng nào; khi có lời mời qua link → tự mở INV-01.

### 9.3 Trang chủ & thành phần chung


#### HOME-01 — Trang chủ (chế độ “Tất cả”)
- **Ai:** Parent. **Vai trò:** trung tâm cảm xúc của cả nhà — mở app là thấy **các con hôm nay**, việc nhỏ cần làm, và ký ức mới.
- **Bố cục (trên → dưới):**
  1. App bar (8.3).
  2. **Lời chào theo thời gian**: “Chào buổi tối, Mama Lan 🌙”.
  3. **Hôm nay của các con** (7.8.9): dải vòng tròn kiểu story — mỗi bé/thai kỳ 1 vòng (ảnh mới nhất hôm nay hoặc avatar), viền màu bé nếu có ảnh mới mình chưa xem, dưới là tên + tuổi; vòng cuối **“+ Ghi lại”** mở QC-01.
  4. **Thẻ ngày đặc biệt** (tối đa 1, theo ưu tiên): tròn tháng / đầy tháng / 100 ngày / thôi nôi / sinh nhật → CTA “Chụp ảnh tháng” (MEM-21) hoặc “Ghi cột mốc”; nếu không có → **Ngày này năm xưa** (ảnh lớn + “1 năm trước, Hana…”).
  5. **Thẻ Papa & Mama (tóm tắt)**: trạng thái bạn đời đã chia sẻ (“Papa: 😪 Mệt • cần yên tĩnh”) + CTA “Để mình lo” • hoặc lời nhờ đang mở • hoặc nút check-in nhanh. *Không hiện nội dung chi tiết.*
  6. **Nhiệm vụ hôm nay**: 1 thẻ tóm tắt — Cây hôm nay (“4/8 việc của nhà mình”), tối đa 3 nhiệm vụ **của tôi** chưa làm, “💗 Hearts của tôi hôm nay” (chỉ mình thấy), link “Xem tất cả” → CARE-01.
  7. **Gợi ý ghi lại** (7.8.8): 1 thẻ câu hỏi theo tuổi bé, nút **Ghi lại** / **Gợi ý khác**.
  8. **Mới trong nhà**: feed ký ức mới (thẻ lớn có ảnh, người đăng, bé + tuổi, huy hiệu “Cả hai cùng kể” nếu có, reaction/bình luận nhanh, nút “Thêm góc nhìn của bạn” trên ký ức của bạn đời); thẻ **Câu nói của con** dạng trích dẫn; thẻ nhóm “Papa vừa thêm 6 ảnh của Haru”.
  9. **Tuần này của nhà mình** (từ thứ Hai): “12 khoảnh khắc • 2 lần đầu • 1 câu nói mới” + 4 ảnh nhỏ → REC-02.
  10. **Cây gia đình mini**: hình cây + thanh tiến độ % (không số Hearts).
- **Ưu tiên khối theo ngữ cảnh** (tối đa 8 khối trong 1 lần cuộn; khối không có dữ liệu thì ẩn):

| Ngữ cảnh | Thay đổi |
|---|---|
| Có lời nhờ đang mở / bạn đời chia sẻ “Quá tải” | Khối 5 lên ngay sau khối 3 |
| Hôm nay là ngày đặc biệt của một bé | Khối 4 hiện ảnh lớn, khối 7 ẩn |
| Buổi tối (sau 19:00) | Khối 6 thu gọn còn 1 dòng nếu đã xong hết; khối 8 lên trên khối 6 |
| Bạn đời vừa đăng ký ức mình chưa xem | Vòng tròn bé có viền màu + chấm |

- **Hành động:** kéo để làm mới; chạm vòng tròn → trình chiếu “Hôm nay của bé”; thả cảm xúc nhanh trên thẻ feed (giữ lâu chọn loại); hoàn thành nhiệm vụ ngay trên thẻ.
- **Empty (gia đình mới):** checklist bắt đầu: ☐ Thêm ảnh đầu tiên của bé ☐ Chụp ảnh tháng ☐ Hoàn thành nhiệm vụ đầu tiên ☐ Gửi lời cảm ơn đầu tiên ☐ Mời ông bà (gói Family).

#### HOME-02 — Trang chủ một bé
- **Header lớn:** ảnh bìa (mặc định ảnh tháng mới nhất), avatar viền màu bé, tên, tuổi chi tiết, ngày sinh dương + âm nhỏ, **đếm ngược** mốc tiếp theo (“Còn 3 ngày nữa tròn 6 tháng”).
- **Nút nhanh:** **+ Ký ức** • **Câu nói** • **Cột mốc** • **Thư cho con**.
- **Hôm nay của Haru**: dải ảnh ngang các ký ức hôm nay (hoặc gợi ý “Chưa có ảnh nào hôm nay”).
- **Tháng thứ 6 của Haru** (thẻ chương tháng): ảnh tháng (hoặc nút chụp), số ký ức tháng này, những lần đầu tháng này.
- **Những lần đầu gần đây**: 3 thẻ ngang + “Xem tất cả” (MEM-12) + 1 ô mờ “Lần đầu tiếp theo?” gợi ý theo giai đoạn (không ghi tuổi chuẩn).
- **Câu nói mới nhất** (bé biết nói) / **Giọng nói mới nhất** (bé nhỏ) — có nút nghe.
- **Con lớn từng tháng**: hàng ngang ảnh tháng → MEM-20.
- **Nhiệm vụ cho Haru hôm nay** (lọc theo bé, của tôi) • **Ngày này năm xưa** của bé • **Feed** lọc theo bé.
- Khối Papa & Mama **vẫn hiển thị** (không lọc theo bé).

#### HOME-03 — Trang chủ thai kỳ
- **Header**: vòng tiến độ 40 tuần (màu lavender), “Tuần 24 + 3 ngày”, “còn 109 ngày gặp Bơ”, tam cá nguyệt (“Tam cá nguyệt 2”); thẻ “Bé to bằng bắp ngô 🌽” (nếu bật, nội dung tham khảo).
- **Nút nhanh**: 📸 **Ảnh bụng tuần này** • 🩻 **Siêu âm** • 💌 **Thư cho bé** • ⭐ **Cột mốc thai kỳ**.
- **Bụng bầu theo tuần**: dải ảnh ngang theo tuần (ô tuần này chưa có = khung mờ “Chụp ngay”) → PREG-02.
- **Lần đầu của Bơ**: cột mốc thai kỳ đã có / chưa có (mờ).
- **Chuẩn bị đón bé**: thanh tiến độ “12/30 món” + 2 mục còn thiếu gần nhất → PREG-04.
- **Nhiệm vụ đồng hành** hôm nay (của tôi) • **Kể cùng nhau** gần đây • **Đặt tên cho con** [1.1].
- Từ tuần 36: thẻ nổi bật **“Bé đã chào đời 🎉”** → PREG-05.
- **Quy tắc**: thai kỳ đã lưu trữ riêng tư (PREG-06) → không hiện ở switcher và Trang chủ, không còn nhắc.
- *(Mô tả cũ giữ lại:)*
- Header: hình minh hoạ tuần thai, “Tuần 24 + 3 ngày • còn 112 ngày”, thẻ “Bé to bằng bắp ngô 🌽” (nếu bật); nút **Chụp ảnh bụng tuần này** (ảnh tháng thai kỳ, 7.8.7), **Ảnh siêu âm**, **Viết thư cho bé**; dải “Bụng bầu theo tuần”; checklist chuẩn bị (tiến độ 12/30); nhiệm vụ đồng hành; nút **Bé đã chào đời 🎉** (hiển thị nổi bật từ tuần 36).

#### SW-01 — Bộ chuyển bé (bottom sheet)
- Danh sách: “Cả nhà” (icon nhà) • từng bé (avatar, tên, tuổi, chấm màu) • thai kỳ (icon bầu, “Thai #2 • Tuần 20”) • bé đã lưu trữ (ẩn, mục “Đã lưu trữ” cuối nếu có). Dấu ✓ cho mục đang chọn. Nút “Quản lý các con” → CHD-03.
- **Quy tắc:** chọn → đóng sheet, các tab Trang chủ/Ký ức/Chăm con đổi theo; lưu lựa chọn.

#### QC-01 — Tạo nhanh (bottom sheet)
- Lưới 2 hàng icon lớn: 📷 **Ký ức** • 🗨️ **Câu nói** • 📸 **Ảnh tháng** • ⭐ **Cột mốc** • 📝 **Nhật ký** • 💌 **Thư gửi con** • ✅ **Nhiệm vụ** • 📅 **Sự kiện**; hàng riêng nền tím nhạt (Papa & Mama): 😊 **Check-in** • 🙏 **Lời nhờ** • 💐 **Cảm ơn**. Gia đình `PARTNER_LEFT` → hàng Papa & Mama hiện ổ khoá.
- Người thân Contributor: chỉ thấy *Ký ức* (và *Thư gửi cháu* nếu PO chốt).

#### NOTI-01 — Hộp thông báo
- Tab: **Tất cả** • **Papa & Mama** • **Gia đình**. Mỗi dòng: icon nhóm, nội dung, thời gian, chấm chưa đọc; gộp theo ngày. Vuốt để xoá. “Đánh dấu đã đọc tất cả”.
- **Quy tắc:** thông báo Papa & Mama chỉ hiển thị trong tab Papa & Mama và tab Tất cả của chính Parent.

### 9.4 Ký ức

#### MEM-01 — Dòng thời gian
- **Bố cục:** app bar (Bộ chuyển bé, 🔍); tab con **Dòng thời gian • Ảnh • Bộ sưu tập**; header bé (avatar, tên, tuổi, “248 ký ức • 18 lần đầu • 12 câu nói”) hoặc Cả nhà; chip lọc (7.10); **chương tháng** (7.10) chứa các thẻ; thanh cuộn nhanh năm/tháng bên phải; FAB nhỏ “+” (tạo ký ức với bé đang chọn).
- **Thẻ:** 1 ảnh lớn / lưới 2–4 ảnh (+N), video có icon ▶ và thời lượng, chú thích 3 dòng, dòng meta “Hana • 5 tháng 2 ngày • Mama kể”, huy hiệu **Cả hai cùng kể**, cảm xúc của khoảnh khắc, icon visibility, reaction & bình luận. Thẻ **Câu nói** (trích dẫn lớn, nền màu bé), thẻ **Giọng nói** (sóng âm + nút phát), thẻ **Kỷ vật**, thẻ **Thư** (phong bì).
- **Empty:** minh hoạ + “Chưa có ký ức nào của Hana. Lưu khoảnh khắc đầu tiên nhé!” [Thêm ký ức].
- **Quy tắc:** phân trang cuộn vô hạn; lưu vị trí cuộn khi quay lại.

#### MEM-02 — Ảnh (lưới)
- Tab con **Ảnh** trong Ký ức (cạnh Dòng thời gian • Bộ sưu tập). Lưới 3 cột (pinch đổi 2/3/5 cột), nhóm theo tháng, chọn nhiều (giữ lâu) → Thêm vào album / Tải về / Đổi visibility / Xoá.

#### MEM-03 — Album
- Album tự động (thẻ có ảnh bìa + số lượng) phía trên; album tự tạo phía dưới; nút “+ Album mới” (giới hạn theo gói).
- **MEM-03a Chi tiết album:** ảnh bìa, tên, số ký ức, lưới; menu: Đổi tên, Đổi bìa, Thêm ký ức, Xoá album (không xoá ký ức).

#### MEM-04 — Chọn nội dung
- Photo picker hệ thống (chọn nhiều, giới hạn theo gói) **hoặc** tab Camera **hoặc** nút “Viết” / “Ghi âm”. Xin quyền camera/micro đúng lúc bấm.
- **Quy tắc:** không xin quyền truy cập toàn bộ thư viện ảnh (dùng picker hệ thống).

#### MEM-05 — Soạn ký ức
- **Bố cục:** băng ảnh đã chọn (kéo để sắp xếp, chạm để xoá/xoay/cắt, chọn ảnh bìa); ô chú thích (gợi ý mờ) + nút ✨ (AI, 1.2); dòng **Bé trong khoảnh khắc** (chip avatar các bé, chọn nhiều + “Khoảnh khắc gia đình”); dòng **Ngày** (“Hôm nay” / ngày EXIF); dòng **Ai thấy** (🔒/👫/👨‍👩‍👧‍👦 + mô tả “Bố mẹ và 4 người thân”); “Thêm”: ⭐ Cột mốc, 📁 Album, 📍 Địa điểm (gõ chữ), 💬 Tắt bình luận. Nút **Lưu** (app bar phải).
- **Validate:** thiếu bé khi gia đình > 1 bé và đang ở “Tất cả” → nút Lưu mở sheet chọn bé.
- **Quy tắc:** thoát → hỏi “Lưu nháp?”; tự lưu nháp mỗi 10 giây.

#### MEM-06 — Đang tải lên
- Không phải màn riêng: thanh tiến độ trên thẻ ký ức trong timeline/feed + banner nhỏ “Đang tải 3/8 ảnh…”. Chạm → danh sách hàng đợi (tạm dừng/huỷ/thử lại). Lỗi → “Tải lên chưa xong. Thử lại” (giữ nháp).

#### MEM-07 — Chi tiết ký ức
- **Bố cục:** media (vuốt ngang nếu nhiều; chạm → MEM-08); dòng người đăng + thời gian đăng; tiêu đề/chú thích đầy đủ; thẻ cột mốc (nếu có); chip bé (chạm → HOME-02); ngày xảy ra + tuổi; địa điểm; album; visibility; thanh reaction (giữ lâu chọn loại); danh sách bình luận (5 gần nhất + “Xem tất cả”); ô nhập bình luận.
- **Kể cùng nhau:** dưới chú thích của người tạo là phần **“Papa kể”** (nếu có) với ảnh/ghi âm riêng; nếu chưa có và người xem là bạn đời → nút **Thêm góc nhìn của bạn** (MEM-24).
- **Ai ở đó** (chip người), **Cảm xúc của khoảnh khắc**; khối **“Cùng ngày này”** (ký ức khác cùng ngày của bé, cuộn ngang).
- **Menu (⋯):** Sửa (MEM-09) • Thêm góc nhìn của bạn (bạn đời) • Gắn/bỏ bé • Đổi người xem • Thêm vào album • Yêu thích • Tải về • Chia sẻ ra ngoài (Parent) • Ẩn khỏi bảng tin • Ghim • Báo cáo • Xoá.
- **Quy tắc:** menu hiển thị theo quyền (4.2). Ký ức Chờ duyệt → banner vàng “Đang chờ Bố/Mẹ duyệt” + (Parent) nút **Duyệt** / **Từ chối**.

#### MEM-08 — Xem ảnh/video toàn màn hình
- Nền đen, pinch zoom, vuốt xuống để đóng, vuốt ngang chuyển ảnh, video có điều khiển; nút tải về (theo quyền), chia sẻ (Parent), thông tin.
- **Quy tắc:** chặn chụp màn hình? — **Không** (không chặn được hoàn toàn & gây khó chịu). Người thân không có quyền tải → không có nút tải.

#### MEM-09 — Sửa ký ức
- Giống MEM-05, điền sẵn; trường không có quyền sửa bị khoá (hiển thị lý do).

#### MEM-10 — Bình luận
- Danh sách đầy đủ, trả lời 1 cấp, giữ lâu: Sửa (≤ 15 phút)/Xoá/Báo cáo/Sao chép. Ô nhập có emoji.
- **Trạng thái:** ký ức tắt bình luận → “Bình luận đã tắt cho ký ức này”.

#### MEM-11 — Chọn cột mốc
- Tìm kiếm; nhóm (7.11) dạng tab ngang; mỗi mục: icon + tên; mục đã ghi cho bé đang chọn có dấu ✓ (mờ); “✏️ Cột mốc riêng của nhà mình”. Chọn → MEM-05 với cột mốc điền sẵn + câu hỏi gợi ý.

#### MEM-12 — Những lần đầu
- Lưới thẻ theo nhóm: đã có (ảnh + ngày + tuổi) / chưa có (mờ, chạm → ghi). Công tắc “Ẩn cột mốc chưa có”.

#### MEM-13 — Viết nhật ký
- Trình soạn thảo toàn màn hình: tiêu đề, thân (định dạng nhẹ), chèn ảnh, câu gợi ý (chip ngẫu nhiên theo tuổi bé), bé, ngày, ai thấy. Tự lưu nháp.

#### MEM-14 — Thư gửi con
- Chọn người nhận (bé), hình thức (Viết/Ghi âm/Quay video), soạn thư, **Hẹn ngày mở** (Không / Chọn ngày / Sinh nhật thứ N), ai được đọc khi mở. Xem trước phong bì. **Niêm phong**.
- Sau niêm phong: thẻ phong bì trên timeline; người viết có thể mở để sửa (nhập lại Face ID nếu bật khoá).

#### MEM-15 — Tìm kiếm
- Ô tìm kiếm + gợi ý gần đây; bộ lọc (7.22); kết quả dạng lưới + danh sách nhật ký.

#### MEM-16 — Ngày này năm xưa
- Danh sách theo năm (“1 năm trước”, “2 năm trước”), mỗi năm các ký ức; nút “Chia sẻ lại với chú thích mới” (tạo ký ức mới tham chiếu).

#### MEM-17 — Thùng rác
- Danh sách ký ức đã xoá, “Còn 23 ngày”; Khôi phục / Xoá vĩnh viễn (xác nhận). Parent thấy mọi ký ức bị xoá trong gia đình; người thân thấy của mình.

#### MEM-18 — Nháp
- Danh sách nháp (cục bộ + server), tiếp tục soạn / xoá.

#### MEM-19 — Chờ duyệt (Parent, gói Family)
- Danh sách ký ức người thân đăng chờ duyệt; xem nhanh; **Duyệt** (có thể sửa bé gắn/visibility trước khi duyệt) / **Từ chối** (lý do tuỳ chọn: “Ảnh này nhà mình muốn giữ riêng”).

#### MEM-20 — Con lớn từng tháng
- Header bé + năm (chọn năm 1/2/3…); **lưới 3×4** ảnh tháng có nhãn “Tháng 1…12”, ô chưa có là khung mờ + nút “+”; chạm ô → xem ảnh / đổi ảnh chính.
- Thanh công cụ: **So sánh** (chọn 2 tháng → hiển thị cạnh nhau có nhãn tuổi) • **Ghép ảnh** (4/9/12 ô, nền màu bé, chữ “Haru — năm đầu tiên”) → lưu/chia sẻ (Parent) • **Video tua nhanh** [1.1].
- Thai kỳ: chế độ “Bụng bầu theo tuần”.

#### MEM-21 — Chụp ảnh tháng
- Camera toàn màn hình: **bóng mờ ảnh tháng trước** (bật/tắt, chỉnh độ mờ) để giữ cùng tư thế; chọn **sticker tháng** (dải mẫu ở dưới, chữ theo ngôn ngữ app); nút chụp / chọn từ thư viện; sau khi chụp → MEM-05 với loại *Ảnh tháng*, bé, tháng tuổi điền sẵn.
- Quyền camera xin đúng lúc bấm; ảnh gốc không chèn sticker (sticker là lớp hiển thị, có thể xuất kèm khi ghép ảnh).

#### MEM-22 — Bộ sưu tập
- Tab con thứ 3 trong Ký ức: **Dòng thời gian** • **Ảnh** • **Bộ sưu tập**.
- Lưới thẻ lớn (bìa + tên + số lượng) theo 7.8.4: Con lớn từng tháng • Những lần đầu • Câu nói của con • Giọng nói • Thư gửi con • Kỷ vật • Cả hai cùng kể • Ảnh chung anh chị em • Album tự tạo (+ Album mới).

#### MEM-23 — Ghi câu nói của con
- Sheet nhỏ: ô chữ lớn kiểu trích dẫn, bé (chip), ngày + tuổi tự tính, “Con nói khi nào?” (ngữ cảnh ngắn), nút 🎙 ghi âm kèm (tuỳ chọn), ai thấy → **Lưu** (≤ 3 chạm).

#### MEM-24 — Thêm góc nhìn của bạn
- Mở từ MEM-07: hiển thị tóm tắt ký ức gốc (ảnh + “Mama kể”), ô “Bạn nhớ gì về khoảnh khắc này?”, thêm ảnh/video/ghi âm; dòng thông tin “Người xem giống ký ức gốc” → **Lưu góc nhìn**.

#### MEM-25 — Hôm nay của bé (trình chiếu)
- Toàn màn hình kiểu story: thanh tiến độ trên cùng, ảnh/video tự chuyển (ảnh 5 giây), tên bé + tuổi + người đăng; vuốt trái/phải; thanh dưới: thả cảm xúc nhanh • “Trả lời…” (bình luận) • “Thêm góc nhìn”. Đánh dấu đã xem theo từng người.

### 9.5 Thai kỳ

#### PREG-01 — Hành trình thai kỳ
- Header tuần thai/đếm ngược; tab: **Dòng thời gian** (ký ức thai kỳ theo tuần) • **Bụng bầu** • **Siêu âm** • **Chuẩn bị**; menu: Sửa thai kỳ, Lưu trữ, Bé đã chào đời.

#### PREG-02 — Nhật ký bụng bầu
- Lưới theo tuần (ô trống “Tuần 25 — chụp ngay”); chế độ **So sánh** (chọn 2–4 tuần cạnh nhau) và **Trình chiếu** (time-lapse) [1.1]; nhắc chụp hằng tuần (công tắc).

#### PREG-03 — Ảnh siêu âm
- Lưới ảnh siêu âm theo tuần; thêm mới (ảnh/video) với tuần thai + lời nhắn.

#### PREG-04 — Chuẩn bị đón bé
- Danh sách checklist theo nhóm (Đồ đi sinh • Đồ sơ sinh • Góc của bé • Giấy tờ • Tuỳ chỉnh); mỗi mục: tick, chuyển thành nhiệm vụ (của tôi / Cùng nhau) hoặc gửi Lời nhờ, ghi chú. Thanh tiến độ. Thêm mục.

#### PREG-05 — Bé đã chào đời (luồng nhiều bước)
- **B1** “Chúc mừng gia đình! Có mấy bé?” (1/2/3/4). **B2** (lặp theo số bé) thông tin bé (7.6). **B3** xem trước thẻ chào mừng (có thể đổi ảnh). **B4** “Báo tin cho người thân?” (danh sách người thân đang được chia sẻ thai kỳ, mặc định chọn hết) **B5** hoàn tất + hiệu ứng.
- **Quy tắc:** thoát giữa chừng → giữ dữ liệu đã nhập 24h; gửi trùng → không tạo bé trùng.

#### PREG-07 — Đặt tên cho con [1.1]
- Danh sách tên dự định (tên + ý nghĩa + ai thêm), nút ❤ của từng người; tên cả hai cùng thích có nhãn “Cả hai thích”; nút **Chọn tên này** → cột mốc “Chọn được tên” (song thai: chọn được nhiều tên, tối đa bằng số bé dự kiến). Chỉ Papa & Mama thấy.

#### PREG-06 — Lưu trữ thai kỳ (nhạy cảm)
- Lựa chọn: “Tạm dừng hành trình” • “Hành trình này đã dừng lại” (mất thai). Lựa chọn thứ hai: ngôn ngữ nhẹ nhàng, không hỏi lý do; tuỳ chọn chuyển mọi ký ức về “Bố mẹ”; tắt mọi nhắc; liên kết nguồn hỗ trợ tinh thần (tuỳ chọn). Không có thông báo cho người thân.

### 9.6 Hồ sơ bé

#### CHD-01 — Hồ sơ bé
- Ảnh bìa + avatar, tên, tên ở nhà, tuổi, ngày sinh (dương + âm), giờ sinh; câu chuyện tên; sở thích; thống kê nhẹ (số ký ức, cột mốc); “Thai kỳ gốc” (nếu có); người thân được chia sẻ bé này (Parent). Nút Sửa.

#### CHD-02 — Sửa hồ sơ bé
- Form các trường 7.7; đổi màu nhận diện (8 màu); cảnh báo khi đổi ngày sinh: “Tuổi trên các ký ức sẽ được tính lại”.

#### CHD-03 — Các con
- Danh sách bé + thai kỳ (kéo để sắp xếp thứ tự hiển thị), mục đã lưu trữ; nút **+ Thêm bé**.

#### CHD-04 — Thêm bé
- “Bé đã chào đời” → form ONB-05b • “Nhà mình đang mong bé” → form ONB-05a (Thai #N). Sau khi tạo (gói Family có người thân) → sheet “Chia sẻ bé với người thân?” (7.4).

#### CHD-05 — Lưu trữ / Xoá bé
- Giải thích tác động (ký ức riêng của bé bị ẩn, ký ức chung vẫn còn ở anh/chị/em); Lưu trữ; Xoá vĩnh viễn (chỉ khi đã lưu trữ ≥ 7 ngày, nhập tên bé để xác nhận).

#### CHD-06 — Tăng trưởng [1.2]
- Ghi cân nặng/chiều cao theo ngày, biểu đồ đường **chỉ dữ liệu của bé** (không vẽ đường chuẩn WHO, không đánh giá). Disclaimer “Không thay thế tư vấn của bác sĩ”.

### 9.7 Chăm con

#### CARE-01 — Hôm nay
- **Bố cục:** app bar (Bộ chuyển bé, 📅 lịch); dải ngày tuần (chạm đổi ngày); **Cây hôm nay** (cây nhỏ có lá/hoa + “7/10 việc của nhà mình”); 1 dòng “1 lời nhờ đang mở →” (nếu có, mở US-04); **3 tab**:
  1. **Của tôi** — đầu tab: “💗 Hearts của tôi hôm nay: 12”; thẻ nhiệm vụ (ô tròn hoàn thành, tên, avatar bé, giờ, Hearts, icon lặp/nhắc, nhãn “Gợi ý hôm nay” cho nhiệm vụ hệ thống).
  2. **Của Mama/Papa** — danh sách nhiệm vụ của bạn đời, chỉ có dấu ✓ khi xong, **không hiện Hearts**; nút 💛 trên việc đã xong.
  3. **Cùng nhau** — nhiệm vụ Cùng nhau / Hai ta, nút “Xong cùng nhau”.
  - Mỗi tab có nhóm **Đã xong** (thu gọn).
- FAB “+ Thêm nhiệm vụ”.
- **Empty:** “Hôm nay chưa có việc nào. Thêm một việc nhỏ từ thư viện nhé?” + 3 gợi ý nhanh (STATE-03).
- **Quy tắc:** vuốt phải = Xong; vuốt trái = Đổi / Bỏ khỏi hôm nay. Mặc định mở tab **Của tôi**.

#### CARE-02 — Chi tiết nhiệm vụ
- Tên, category, bé, chủ nhiệm vụ, nguồn (Gợi ý hôm nay / Thư viện / Tự tạo / Lặp), thời gian, lặp, nhắc, Hearts (chỉ khi là của tôi), lịch sử (tạo lúc…, hoàn thành lúc…), ký ức liên kết. Hành động: **Hoàn thành** • **Đổi** (nhiệm vụ hệ thống) • **Bỏ khỏi hôm nay** • **Sửa / Xoá** (tự thêm) • **Tạm dừng chuỗi** • (nhiệm vụ của bạn đời: chỉ xem + 💛).

#### CARE-03 — Thêm nhiệm vụ (form 1 màn, các bước dạng section)
- Section theo 7.13.3: Việc gì (Thư viện / Tự gõ) → Cho bé nào → **Ai làm: Tôi / Cùng nhau** → Khi nào & Lặp → Nhắc → Gợi ý lưu kỷ niệm. Nút **Lưu**.
- Dòng gợi ý dưới “Ai làm”: “Muốn nhờ Mama một việc? **Gửi lời nhờ →**” (mở US-03 điền sẵn).
- **Validate:** phạm vi Một bé = đúng 1 bé; Nhiều bé ≥ 2; “Hai ta” → người làm cố định Cùng nhau.

#### CARE-04 — Thư viện nhiệm vụ
- Tìm kiếm; lọc theo category, bé (tuổi), thời lượng (5/15/30 phút); mỗi mục: tên, mô tả ngắn, thời lượng, **Hearts**; chạm → điền sẵn CARE-03 (hoặc US-03 nếu mở từ Lời nhờ).

#### CARE-05 — Đổi nhiệm vụ (bottom sheet)
- “Đổi *Đọc sách tranh 10 phút* bằng…” → 3 lựa chọn cùng bé/giai đoạn, **Hearts ±1** (giữ cân bằng); “Còn 2 lần đổi hôm nay”; nút **Bỏ khỏi hôm nay** ở cuối.

#### CARE-06 — Hoàn thành (bottom sheet)
- “Tuyệt vời! **+5 💗** cho cây nhà mình” (số Hearts chỉ người bấm thấy) + hoạt ảnh lá mọc; “Lưu lại khoảnh khắc?” [📷 Chụp] [🖼 Chọn ảnh] [Bỏ qua] (+2 💗 khi có ảnh); ô ghi chú; Hoàn tác.

#### CARE-07 — Lịch
- Chế độ Tuần (mặc định) / Tháng; mỗi ngày: chấm màu theo loại (nhiệm vụ/sự kiện/hẹn hai ta); chạm ngày → danh sách; hiển thị ngày âm lịch nhỏ dưới ngày dương (bật/tắt); FAB + Sự kiện/+ Nhiệm vụ.

#### CAL-02 — Tạo sự kiện
- Tiêu đề, loại (Của bé/Gia đình/Hai ta/Nhắc kỷ niệm/Ghi chú), ngày (công tắc Âm lịch), giờ/Cả ngày, lặp hằng năm, bé, người tham gia (Bố/Mẹ/“Mời cả nhà” – gói Family), nhắc, ghi chú.

#### CARE-08 — Lịch sử
- Danh sách theo ngày: nhiệm vụ của tôi (đã xong/hết hạn, màu trung tính) + Cùng nhau; nhiệm vụ của bạn đời chỉ hiện việc đã xong (✓, không Hearts). Lọc theo bé/category.

#### CARE-09 — Cây gia đình
- Hình cây lớn (hoạt ảnh nhẹ), cấp hiện tại, **thanh tiến độ %** tới cấp sau (không số tuyệt đối), bộ sưu tập “Những ngày tròn đầy” (số bông hoa), phần thưởng đã mở, link Huy hiệu.
- Khối **“Bạn đã góp”** (chỉ người xem thấy, có biểu tượng 🔒 “Chỉ bạn thấy”): Hearts của tôi hôm nay / tuần này / tổng, lịch sử Hearts **của tôi** (“+5 • Đọc sách cho Hana”).

#### CARE-10 — Huy hiệu
- Lưới huy hiệu đã đạt (màu) / chưa đạt (mờ + điều kiện); chạm → chi tiết + ngày đạt.

#### CARE-11 — Thống kê chăm con [1.1]
- 7.15. Bộ chọn tuần; biểu đồ category của **cả nhà**; switcher bé; số ngày cây nở hoa; disclaimer. Không có phân chia theo người.

#### CARE-12 — Cài đặt nhiệm vụ
- **Mức nhiệm vụ hằng ngày của cả nhà** (Nhẹ 2 / Vừa 3 / Nhiều 4 mỗi người — đổi áp dụng cho cả hai, báo bạn đời); category tôi muốn nhận (công tắc); giờ nhận bảng nhiệm vụ (mặc định 7:00 thông báo); hỏi chuyển nhiệm vụ tự thêm lúc 21:00; nhắc mặc định.

### 9.8 Papa & Mama

#### US-00 — Papa & Mama (bạn đời đã rời gia đình — `PARTNER_LEFT`)
- Minh hoạ hai người, giải thích 4 tính năng, khẳng định riêng tư, nút **Mời Bố/Mẹ**; nếu lời mời đang chờ: “Đã gửi lời mời • còn 5 ngày” + Gửi lại.

#### US-01 — Papa & Mama (trang chính)
- **Nền tím oải hương nhạt**, dải trên “🔒 Chỉ hai bạn nhìn thấy”.
- Khối:
  1. **Hôm nay của hai ta**: 2 ô cạnh nhau — *Tôi* (mood hiện tại hoặc nút “Hôm nay bạn thế nào?”) và *Bạn đời* (mood đã chia sẻ / “Chưa chia sẻ”), dưới ô bạn đời là các nút phản hồi nhanh.
  2. **Lời nhờ đang mở** (2 chiều).
  3. **Câu hỏi kết nối hôm nay** (1 câu, vd. “Điều nhỏ nào hôm nay làm bạn mỉm cười?”) — trả lời riêng, chỉ hiện câu trả lời của nhau khi **cả hai** đã trả lời [1.1].
  4. **Lời cảm ơn gần đây** → US-06.
  5. **Nhiệm vụ hai ta** (1–2 thẻ).
  6. Lối vào: 📓 Nhật ký riêng • 🌉 Tụi mình đang có chuyện (Cầu nối) • 📊 Tuần của hai ta.
- **Quy tắc:** không có bộ chuyển bé; không hiển thị cho người thân dưới bất kỳ hình thức nào.

#### US-02 — Check-in (bottom sheet)
- Lưới 10 cảm xúc lớn → năng lượng (5 pin) → “Mình cần…” (chip) → ghi chú → **Chia sẻ với Mẹ / Chỉ mình tôi** (segmented) + danh sách tick phần chia sẻ → Lưu.
- Chọn “Khó chịu với bạn đời” → màn hỏi Cầu nối (không lưu share).

#### US-03 — Gửi lời nhờ
- Hai nhóm thẻ: **Nhờ một việc** (Cần nghỉ 15/30/60′ • Trông con giúp • Chọn từ thư viện • Tự gõ) và **Mình đang cần…** (Yên tĩnh • Một cái ôm • Nói chuyện • Động viên) → chi tiết (bé, khi nào) → câu mẫu (sửa được) → mức Bình thường/Sớm nhé → xem trước → **Gửi cho Papa/Mama**.
- Hiện “Đang mở 2/5” nếu gần giới hạn.

#### US-04 — Chi tiết lời nhờ
- **Người nhận:** thẻ lời nhờ (avatar người gửi, lời nhắn, việc, bé, giờ) + nút **Nhận** / **Hôm nay không được** (chọn lý do nhanh); sau khi nhận: **Đã xong** / “Nhắc mình lúc…”. NEED: Đã thấy / Gửi 🤗 / Chọn giờ nói chuyện.
- **Người gửi:** trạng thái (Đã gửi → Đã xem → Đã nhận → Đã xong / Hôm nay không được), Huỷ, **Cảm ơn** khi xong; khi bị từ chối có nút “Tự mình làm”.
- Mở từ thông báo dưới dạng sheet.

#### US-05 — Gửi lời cảm ơn
- Câu mẫu (chip) / viết tự do; sticker; gắn nhiệm vụ/ký ức (tuỳ chọn); công tắc “Đề nghị đăng thành khoảnh khắc gia đình” (cần bạn đời đồng ý); Gửi.

#### US-06 — Bức tường cảm ơn
- Dạng thẻ giấy note hai màu (của tôi / của bạn đời), lọc theo tháng, reaction.

#### US-07 — Nhật ký riêng
- Danh sách bài (ngày, đoạn đầu, cảm xúc), khoá Face ID (tuỳ chọn), viết mới, “Chia sẻ đoạn này với bạn đời” (xem trước chính xác).

#### US-08 — Cầu nối: bắt đầu (riêng tư)
- Wizard 7.17.1 bước 2–7, mỗi bước 1 màn, nút “Dừng lại” luôn hiển thị; dải trên “Chỉ bạn thấy những gì bạn viết ở đây”.

#### US-09 — Viết lại nhẹ nhàng
- Câu gốc → 3 phiên bản (Trung tính/Ấm áp/Ngắn gọn) dạng thẻ, chọn → sửa → dùng. Nhãn ✨ AI + Báo cáo. Ở 1.1 (chưa AI): danh sách câu mẫu theo cảm xúc/nhu cầu.

#### US-10 — Lời mời Cầu nối (người nhận)
- “Mẹ muốn trò chuyện bình tĩnh khi bạn sẵn sàng” + những gì Mẹ đã chọn chia sẻ (nếu có) + 3 nút (Tham gia ngay/Để sau/Chưa sẵn sàng).

#### US-11 — Phiên chung
- 2 cột “Mẹ cảm thấy… cần…” | “Bố cảm thấy… cần…”, nút “Mình hiểu” / “Mình cần nói rõ hơn”; trạng thái hai bên; nút Tạm dừng.

#### US-12 — Bước tiếp theo
- Chip lựa chọn (7.17.1), xác nhận của cả hai, tạo nhắc/lời nhờ; sau đó màn “Đóng phiên?” với cảm ơn tuỳ chọn.

#### US-13 — Hỗ trợ an toàn
- Nền trung tính (không tím), thông điệp “Sự an toàn của bạn là quan trọng nhất”, danh sách đường dây hỗ trợ (bấm gọi), “Giữ riêng nội dung này”, “Thoát nhanh” (về Trang chủ). Không ghi vào lịch sử phiên.

#### US-14 — Tuần của hai ta [1.1]
- Số lần check-in, lời nhờ được hỗ trợ, lời cảm ơn, nhiệm vụ cùng nhau; không có điểm, không so sánh.

#### US-15 — Cài đặt Papa & Mama
- Mặc định chia sẻ mood (Hỏi mỗi lần/Luôn chia sẻ/Luôn riêng tư); ẩn nội dung trên màn hình khoá; khoá Face ID khi vào Papa & Mama; thời gian lưu Cầu nối (Xoá ngay/7/30/90 ngày); xoá lịch sử mood; lời nhờ vượt giờ yên tĩnh.

### 9.9 Gia đình & Người thân

#### FAM-01 — Tổng quan gia đình
- Ảnh bìa, tên gia đình (sửa); **Papa & Mama** (2 avatar, nhãn, trạng thái); **Các con** (→ CHD-03); **Người thân** (danh sách rút gọn, “+ Mời”, khoá nếu không phải gói Family với CTA nâng cấp); **Chờ duyệt** (số ký ức); **Gói**: tên gói, ngày gia hạn → SUB-03; **Quyền riêng tư** (dashboard 7.23.4); **Cài đặt gia đình**.

#### FAM-02 — Mời bạn đời
- Như ONB-07; thêm “Thu hồi lời mời”.

#### FAM-03 — Mời người thân (wizard 5 bước, 7.4)
- B1 Quan hệ (lưới chip) → B2 Tên gọi → B3 Chọn bé (checkbox) → B4 Quyền (preset + chỉnh từng bé + Cho phép tải) → B5 Xem trước (“Sẽ thấy / Sẽ không thấy”) → Gửi (share sheet: tin nhắn soạn sẵn “Bà ơi, con mời bà xem ảnh cháu Hana trên Baby Family…” + link).
- **Quy tắc:** đủ 12 người → nút Mời bị khoá với giải thích.

#### FAM-04 — Chi tiết người thân
- Avatar, tên gọi, quan hệ, phương thức đăng nhập (ẩn số/ email một phần), ngày tham gia, hoạt động gần nhất; bảng quyền từng bé (sửa trực tiếp); Cho phép tải; số ký ức đã đăng; hành động: Tạm dừng • Gỡ khỏi gia đình • Báo cáo • Tắt thông báo từ người này.

#### FAM-05 — Lời mời đang chờ
- Danh sách lời mời (loại, quan hệ, ngày tạo, hết hạn); Gửi lại link, Thu hồi.

#### FAM-06 — Xác nhận gỡ người thân
- Tóm tắt nội dung họ đã đăng; lựa chọn giữ/gỡ; xác nhận.

#### FAM-07 — Cài đặt gia đình
- Tên, ảnh bìa; múi giờ gia đình; ngôn ngữ nội dung gợi ý; hiển thị âm lịch; cách tính đầy tháng/thôi nôi (dương/âm); mặc định “Ai thấy ký ức mới”; duyệt ảnh người thân; người thân thấy Cây gia đình; tắt gợi ý cột mốc; **Xoá gia đình** (Parent, xác nhận mạnh, 30 ngày chờ).

#### FAM-08 — Chuyển gia đình
- Nếu tài khoản vừa là Parent nhà mình vừa là người thân nhà khác: danh sách gia đình, chọn để chuyển ngữ cảnh toàn app.

### 9.10 Tổng kết

#### REC-01 — Câu chuyện ngày
- Ảnh bìa (đổi được), tiêu đề, đoạn văn (soạn/AI), ảnh kèm (chọn/bỏ); Lưu (chọn ai thấy) / Bỏ.

#### REC-02 — Tuần của nhà mình
- Dạng story nhiều trang (vuốt ngang): trang số liệu tích cực → ảnh nổi bật → cột mốc → khoảnh khắc cùng nhau → (Parent) lời cảm ơn → trang kết “Tuần tới…”. Nút Chia sẻ với người thân (gói Family), Lưu vào timeline, Tải ảnh tổng kết.

#### REC-03 — Tháng tuổi
- Tương tự REC-02 cho 1 bé, kèm ảnh tháng và so sánh ảnh tháng trước.

#### REC-04 — Year Story / Sách của con [2.0]
- Chọn bé/cả nhà, năm; chương tự đề xuất; chọn/bỏ ảnh; sửa chú thích; xem trước PDF; xuất.

### 9.11 Gói dịch vụ

#### SUB-01 — Chọn gói (Paywall)
- Tiêu đề theo ngữ cảnh (“Mời ông bà cùng xem Hana” khi vào từ mời người thân); 2 thẻ gói **House** / **Family** (Family có nhãn “Phổ biến”/“Cả đại gia đình”), giá năm + quy đổi tháng; danh sách 4–6 lợi ích chính mỗi gói; bảng so sánh mở rộng; dòng trạng thái “Dùng thử miễn phí còn N ngày” (nếu đang dùng thử); nút **Đăng ký 399.000đ/năm** / **Đăng ký 599.000đ/năm**; text bắt buộc về tự gia hạn; link Điều khoản • Quyền riêng tư; **Khôi phục giao dịch**; “Để sau” (chỉ khi còn dùng thử/gói còn hạn).
- **Quy tắc:** chỉ hiện khi gia đình đủ Bố + Mẹ (BR-055); gia đình đã có gói ≥ gói đang xem → nút thành “Gói hiện tại”; người thân không bao giờ thấy màn này.

#### SUB-02 — Xác nhận mua
- Sheet của Apple/Google (hệ thống). Sau khi thành công → màn “Chào mừng đến gói Family 🎉” + gợi ý hành động (Mời ông bà).
- **Lỗi:** huỷ → quay lại SUB-01 không thông báo lỗi; thất bại → “Giao dịch chưa thành công” + thử lại; đang chờ (Android “pending”) → “Giao dịch đang được xử lý”.

#### SUB-03 — Gói của gia đình
- Gói hiện tại, trạng thái (Dùng thử – còn N ngày/Đang hoạt động/Ân hạn/Đã huỷ – hết hạn ngày…/Hết hạn), người thanh toán, kênh, ngày gia hạn; dung lượng đã dùng (thanh: Ảnh • Video • Âm thanh); số người thân/12 (chỉ gói Family); lượt AI tháng này; nút **Nâng cấp lên Family** / **Đổi gói** / **Quản lý trong App Store/Google Play** (deep link tới trang quản lý subscription); Khôi phục giao dịch.

#### SUB-04 — Nâng cấp House → Family
- So sánh nhanh + giá; nếu người xem không phải payer → hướng dẫn 5.7.

#### SUB-05 — Đạt giới hạn (sheet)
- Biến thể: dung lượng (10/50/200 GB), video dài, số người thân, AI. Nội dung: giải thích ngắn, “Ký ức của bạn vẫn an toàn”, CTA Nâng cấp, phương án thay thế (vd. “Cắt video ngắn hơn”, “Lưu dạng nhật ký chữ”).

#### SUB-06 — Banner trạng thái gói
- Trên Trang chủ (cả Bố và Mẹ): Dùng thử còn 30/7/2 ngày • Hôm nay là ngày dùng thử cuối • Thanh toán lỗi (ân hạn) — đóng được, hiện lại sau 1 ngày (khi còn ≤ 7 ngày) hoặc 3 ngày.

#### SUB-07 — Hết thời gian dùng thử / Gói đã hết hạn (bắt buộc)
- **Ai:** Bố, Mẹ khi trạng thái quyền sử dụng = Hết hạn. Toàn màn hình, **không đóng được**, thay thế mọi tab.
- **Bố cục:** ảnh bìa gia đình mờ + “3 tháng dùng thử của nhà mình đã kết thúc” (hoặc “Gói Family đã hết hạn ngày dd/mm”); thống kê ấm áp “Nhà mình đã lưu 248 ký ức, 12 cột mốc của Hana” (động lực); 2 thẻ gói House / Family (như SUB-01); **Khôi phục giao dịch**; khu vực phụ: **Tải dữ liệu về** (→ SET-08), **Hỗ trợ**, **Đăng xuất**, **Xoá tài khoản**.
- **Quy tắc:** ký ức không bị xoá; người thân thấy CIR-05; thông báo đẩy dừng (trừ thông báo về gói, tối đa 1 lần/tuần trong 4 tuần); mua thành công → mở khoá ngay, quay lại HOME-01.

### 9.12 Cài đặt cá nhân

| Mã | Màn | Nội dung chính |
|---|---|---|
| SET-01 | Cài đặt | Hồ sơ • Thông báo • Quyền riêng tư • AI • Hiển thị & Ngôn ngữ • Bảo mật & Thiết bị • Dữ liệu của tôi • Trợ giúp • Giới thiệu • Đăng xuất |
| SET-02 | Hồ sơ | Avatar, tên, nhãn gọi (Parent), phương thức đăng nhập (liên kết/huỷ liên kết Apple/Google/SĐT), múi giờ cá nhân |
| SET-03 | Thông báo | Công tắc từng nhóm (7.21), giờ yên tĩnh, ẩn nội dung màn hình khoá, bản tin người thân (giờ gửi), tắt thông báo theo người |
| SET-04 | Quyền riêng tư | Mặc định ai thấy ký ức mới (Parent), dashboard quyền (→ 7.23.4), người bị chặn |
| SET-05 | AI | Công tắc tổng; từng tính năng; giải thích dữ liệu gửi đi; lượt còn lại |
| SET-06 | Hiển thị & Ngôn ngữ | **Ngôn ngữ** (Tiếng Việt / English — tên ngôn ngữ luôn viết bằng chính ngôn ngữ đó; đổi có hiệu lực ngay, 7.27); Sáng/Tối/Theo hệ thống; **Cỡ chữ** (Bình thường/Lớn/Rất lớn — gợi ý cho ông bà); hiển thị âm lịch; giảm hiệu ứng chuyển động |
| SET-07 | Bảo mật & Thiết bị | Khoá ứng dụng (Face ID/vân tay/PIN), danh sách thiết bị đăng nhập (đăng xuất từ xa), đăng xuất mọi thiết bị |
| SET-08 | Dữ liệu của tôi | Xuất dữ liệu cá nhân; (Parent) Xuất dữ liệu gia đình; trạng thái xuất; dung lượng cache trên máy (xoá cache) |
| SET-09 | Xoá tài khoản | Luồng 7.25.3 (3–4 màn: tác động → lựa chọn gia đình → xác thực → xác nhận cuối) |
| SET-10 | Rời gia đình (người thân) | 7.25.1 |
| SET-11 | Trợ giúp | Câu hỏi thường gặp, Gửi yêu cầu hỗ trợ (form + đính kèm ảnh chụp màn hình tuỳ chọn), Báo cáo của tôi, email/hotline hỗ trợ |
| SET-12 | Giới thiệu | Phiên bản, Điều khoản, Chính sách quyền riêng tư, Giấy phép mã nguồn mở |
| SET-13 | Người bị chặn | Danh sách, bỏ chặn |

### 9.13 An toàn

#### RPT-01 — Báo cáo (sheet)
- Lý do (radio) → mô tả → “Ẩn với tôi ngay” → (Parent) “Gỡ khỏi gia đình” → Gửi → xác nhận + mã báo cáo.

#### RPT-02 — Chặn (dialog)
- Giải thích hậu quả theo ngữ cảnh (7.24) → Chặn/Huỷ.

### 9.14 Người thân (Circle)

#### CIR-01 — Cháu yêu (Trang chủ người thân)
- **Bố cục:** app bar: tên gia đình + bộ chuyển cháu (chỉ cháu được chia sẻ; ẩn nếu 1 cháu) + 🔔; lời chào “Chào Bà nội 🌸”; thẻ cháu (avatar, tuổi); **Hôm nay của cháu** (ký ức mới nhất lớn); feed; thẻ “Ngày này năm xưa”; nút reaction to rõ.
- **Chế độ chữ lớn**: cỡ chữ ≥ 18, nút ≥ 56dp, ít chữ phụ.
- **Empty:** “Bố mẹ chưa đăng ảnh mới. Bà sẽ được báo khi có nhé.”

#### CIR-02 — Trang của cháu
- Header cháu, timeline (chỉ nội dung được phép), Những lần đầu (xem), không có nhiệm vụ.

#### CIR-03 — Chi tiết ký ức (người thân)
- Như MEM-07, menu rút gọn: Tải về (nếu được phép) • Báo cáo • (của mình) Sửa/Xoá.

#### CIR-04 — Đăng ảnh (Contributor)
- MEM-04/05 rút gọn: chọn ảnh, chú thích, chọn cháu (chỉ cháu được grant với quyền Đóng góp), ngày. Không có lựa chọn visibility (mặc định Cả nhà). Sau khi gửi: “Đã gửi! Bố/Mẹ sẽ duyệt trước khi hiển thị” (nếu bật duyệt).

#### CIR-05 — Gia đình tạm dừng chia sẻ
- “Gia đình Cà Chua đang tạm dừng chia sẻ với người thân. Ảnh của cháu vẫn được giữ an toàn.” — dùng cho cả trường hợp gia đình hạ xuống gói House và gói **hết hạn**; không hiện lý do gói (tránh gây khó xử). Nút: Đóng / Rời gia đình.

#### CIR-06 — Tôi (người thân)
- Hồ sơ, cỡ chữ, thông báo (tức thì/bản tin 19:00), chuyển gia đình, trợ giúp, rời gia đình, xoá tài khoản.

### 9.15 Admin CMS (web nội bộ)

| Mã | Màn | Nội dung |
|---|---|---|
| ADM-01 | Đăng nhập | Email + mật khẩu + **2FA bắt buộc** (TOTP) |
| ADM-02 | Dashboard | KPI vận hành: báo cáo mới, case quá SLA, xoá tài khoản đang chờ, lỗi đồng bộ Store, hàng đợi xử lý media |
| ADM-03 | Tra cứu người dùng/gia đình | Tìm theo ID, SĐT (che một phần), email; xem metadata: gia đình, vai trò, số bé (không tên đầy đủ), gói, thiết bị, trạng thái; **không** hiển thị ảnh/ký ức |
| ADM-04 | Hàng đợi báo cáo | Lọc theo mức độ/lý do/trạng thái/SLA; nhận case |
| ADM-05 | Case kiểm duyệt | Nội dung bị báo cáo (chỉ nội dung đó), lịch sử báo cáo liên quan, hành động (7.24), ghi chú bắt buộc, audit |
| ADM-06 | Catalog nhiệm vụ | CRUD template, bản dịch, rollout %, xem trước |
| ADM-07 | Catalog cột mốc | CRUD, cách tính ngày truyền thống |
| ADM-08 | Nội dung gợi ý | Mood/Nhu cầu/Câu mẫu/Câu hỏi kết nối/Gợi ý nhật ký/Nội dung tuần thai — mỗi mục nhập theo từng ngôn ngữ |
| ADM-19 | Bản dịch | Bảng theo dõi tiến độ dịch mọi catalog/template theo ngôn ngữ (đã dịch / thiếu / cần duyệt), lọc mục thiếu, xuất/nhập file dịch (CSV/XLIFF) cho dịch giả |
| ADM-09 | Huy hiệu & Cây | Điều kiện, ảnh, ngưỡng |
| ADM-10 | Template thông báo | Theo ngôn ngữ, biến, bật/tắt |
| ADM-11 | Gói & Quota | Quota theo gói, cấu hình trial, sản phẩm Store |
| ADM-12 | Subscription | Lịch sử giao dịch của gia đình, sự kiện Store, “Đồng bộ lại” |
| ADM-13 | Yêu cầu xoá | Danh sách, trạng thái job, lỗi |
| ADM-14 | Feature flags & cấu hình | Cờ tính năng, giới hạn rate, điểm Hearts |
| ADM-15 | Banner/Thông báo hệ thống | Lịch, đối tượng |
| ADM-16 | Nguồn hỗ trợ an toàn | Danh sách đường dây theo khu vực |
| ADM-17 | Audit log | Mọi thao tác admin, lọc theo người/hành động |
| ADM-18 | Quản lý admin | Tài khoản, vai trò (4.3), khoá |

---
## 10. Nguyên tắc thiết kế & Design System

### 10.1 Định hướng thẩm mỹ

**Từ khoá:** *Ấm áp • Dịu dàng • Tin cậy • Ảnh là nhân vật chính • Gia đình, không trẻ con hoá.*

| Nguyên tắc | Diễn giải |
|---|---|
| **Ảnh là trung tâm** | Ảnh/video chiếm diện tích lớn, tràn viền trong thẻ; UI xung quanh tối giản để không “giành” sự chú ý. |
| **Ấm như một tổ ấm** | Nền kem ấm thay vì trắng lạnh; màu chính san hô/đào; bo góc mềm; bóng đổ nhẹ, ấm. |
| **Dành cho người lớn** | Minh hoạ tinh tế, không hoạt hình kiểu game cho trẻ; chữ rõ ràng; ít emoji trang trí trong UI chính. |
| **Riêng tư nhìn thấy được** | Mọi ký ức có biểu tượng ai thấy; Papa & Mama có màu riêng (tím oải hương) + 🔒 để luôn biết đang ở vùng riêng tư. |
| **Không phán xét** | Không dùng đỏ cho việc “chưa làm”, không có số liệu so sánh nổi bật giữa Bố – Mẹ. |
| **Nhanh và một tay** | Hành động chính ở nửa dưới màn hình; nút ≥ 48dp; tạo ký ức ≤ 3 chạm. |
| **Thân thiện với ông bà** | Chế độ chữ lớn, tương phản cao, nhãn rõ chữ (không chỉ icon). |
| **Mỗi bé một màu** | Màu nhận diện bé xuất hiện ở viền avatar, chip, chấm trên lịch — giúp nhà nhiều con không bị nhầm. |

### 10.2 Bảng màu (Color tokens)

#### Màu thương hiệu

| Token | Light | Dark | Dùng cho |
|---|---|---|---|
| `primary-50` | `#FFF4F1` | `#2A1A16` | Nền nhấn rất nhạt |
| `primary-100` | `#FFE3DC` | `#3D231D` | Nền chip được chọn, nền thẻ gợi ý |
| `primary-300` | `#F7A796` | `#C9705F` | Minh hoạ, viền nhấn |
| `primary-500` | `#EE7B67` *(San hô ấm — màu thương hiệu)* | `#F4917F` | Logo, icon nổi bật, nút FAB “+”, Hearts |
| `primary-600` | `#C2513F` | `#F7A796` | **Nút chính (nền)**, link; dùng chữ `on-primary` để đạt AA ≥ 4.5:1 |
| `on-primary` | `#FFFFFF` | `#2A1A16` | Chữ/icon trên nút chính, khớp biến `on-primary` trong Pencil |
| `primary-700` | `#A2402F` | `#FFC2B5` | Trạng thái nhấn (pressed) |
| `secondary-100` | `#E4F2EA` | `#1C2B23` | Nền nhóm Chăm con |
| `secondary-500` | `#6FAE8E` *(Xanh lá mạ)* | `#86C3A3` | Hoàn thành nhiệm vụ, Cây gia đình |
| `secondary-700` | `#3F7A5C` | `#A9D9BF` | Chữ trên nền xanh nhạt |
| `accent-100` | `#FDF1D6` | `#33291A` | Nền lời nhờ “Đang chờ bạn” |
| `accent-500` | `#F4BF5C` *(Vàng nắng)* | `#F7CD7C` | Cột mốc, ngôi sao, huy hiệu |
| `us-50` | `#F6F2FC` | `#1F1A2B` | **Nền toàn bộ Papa & Mama Space** |
| `us-100` | `#EAE2F8` | `#2C2440` | Thẻ trong Papa & Mama |
| `us-500` | `#9B85D1` *(Tím oải hương)* | `#B5A3E3` | Icon, nhấn Papa & Mama |
| `us-700` | `#6A549F` | `#D2C6F0` | Nút chính trong Papa & Mama (chữ `on-primary`) |

#### Màu trung tính (ấm)

| Token | Light | Dark | Dùng cho |
|---|---|---|---|
| `bg` | `#FFFBF7` *(kem)* | `#171412` | Nền màn hình |
| `surface` | `#FFFFFF` | `#221E1B` | Thẻ, sheet |
| `surface-variant` | `#F7F1EC` | `#2C2724` | Ô nhập, thẻ phụ |
| `border` | `#EADFD6` | `#3A3430` | Viền, đường kẻ |
| `text-primary` | `#2E2A27` | `#F5EFEA` | Chữ chính |
| `text-secondary` | `#6B625B` | `#BDB3AB` | Chữ phụ |
| `text-tertiary` | `#9C928A` | `#8A817A` | Gợi ý, placeholder (không dùng cho nội dung quan trọng) |
| `overlay` | `rgba(46,42,39,0.48)` | `rgba(0,0,0,0.6)` | Nền sau sheet/dialog |

#### Màu ngữ nghĩa

| Token | Light | Dark | Lưu ý |
|---|---|---|---|
| `success` | `#3E9B6E` | `#6FCB9C` | Thành công |
| `warning` | `#D98E1F` | `#F2B85B` | Cảnh báo (ví dụ sắp hết dung lượng) |
| `error` | `#D14B4B` | `#F08080` | **Chỉ dùng cho lỗi hệ thống/validate** — không dùng cho nhiệm vụ chưa làm |
| `info` | `#3F82BF` | `#7DB3E0` | Thông tin |

#### Màu nhận diện bé (8 màu, tự gán theo thứ tự, đổi được)

| # | Tên | Màu | Chữ trên màu |
|---|---|---|---|
| 1 | Đào | `#FFB59E` | `#2E2A27` |
| 2 | Bạc hà | `#9EDCC4` | `#2E2A27` |
| 3 | Trời | `#9CCBF2` | `#2E2A27` |
| 4 | Oải hương | `#C7B3F0` | `#2E2A27` |
| 5 | Chanh | `#F7DD86` | `#2E2A27` |
| 6 | Hồng | `#F5A8C0` | `#2E2A27` |
| 7 | Cát | `#E6C9A8` | `#2E2A27` |
| 8 | Ngọc | `#8FD8DE` | `#2E2A27` |

> Không mặc định màu theo giới tính (không ép xanh = trai, hồng = gái). Màu bé không bao giờ là cách *duy nhất* để phân biệt — luôn kèm tên/avatar.

**Kiểm tra tương phản:** mọi cặp chữ/nền phải đạt WCAG 2.2 AA (chữ thường ≥ 4.5:1, chữ lớn & icon ≥ 3:1). Designer kiểm tra lại bằng công cụ trước khi chốt Figma.

### 10.3 Typography

- **Font tiêu đề:** **Nunito** (bo tròn, ấm, hỗ trợ đầy đủ dấu tiếng Việt) — weight 700/800.
- **Font nội dung:** **Be Vietnam Pro** (thiết kế cho tiếng Việt, dễ đọc) — weight 400/500/600.
- Cả hai là Google Fonts (giấy phép OFL), **đóng gói trong app** (không tải runtime) để hoạt động offline.
- Số liệu (tuổi, giờ): Be Vietnam Pro, `tabular-nums`.

| Token | Font | Size / Line-height | Weight | Dùng cho |
|---|---|---|---|---|
| `display` | Nunito | 32 / 40 | 800 | Tên bé ở header, số Hearts lớn |
| `h1` | Nunito | 26 / 34 | 800 | Tiêu đề màn |
| `h2` | Nunito | 22 / 30 | 700 | Tiêu đề khối |
| `h3` | Nunito | 18 / 26 | 700 | Tiêu đề thẻ |
| `body-lg` | Be Vietnam Pro | 17 / 26 | 400 | Nhật ký, thư |
| `body` | Be Vietnam Pro | 15 / 22 | 400 | Nội dung chung |
| `body-strong` | Be Vietnam Pro | 15 / 22 | 600 | Nhấn mạnh |
| `label` | Be Vietnam Pro | 15 / 20 | 600 | Nút |
| `caption` | Be Vietnam Pro | 13 / 18 | 400 | Meta (thời gian, tuổi) |
| `overline` | Be Vietnam Pro | 12 / 16 | 600, chữ hoa, giãn 0.5 | Nhãn nhóm |

- Hỗ trợ **Dynamic Type / Font scale** của hệ thống tới 200%; layout không vỡ ở 130%.
- **Chế độ chữ lớn** (Cài đặt): nhân 1.2 toàn bộ scale; mặc định gợi ý cho người thân trên 55 tuổi (người dùng tự chọn).

Các biến thể chữ nhỏ theo component Pencil dùng cùng font: `text14` 14/18,
`small` 12/15, `tiny` 11/14, `micro` 10/13 (Be Vietnam Pro);
`title17` 17/23 weight 800, `title16` 16/22 weight 700,
`title20` 20/27 weight 800 (Nunito). Nhãn bottom tab 11/14, weight 500,
mục chọn weight 700; không thêm letter spacing cho chữ nhỏ.

### 10.4 Khoảng cách & lưới (Spacing)

- Hệ **4pt**: `space-1`=4, `2`=8, `3`=12, `4`=16, `5`=20, `6`=24, `8`=32, `10`=40, `12`=48, `16`=64.
- Component Pencil còn dùng `compact`=6, `itemGap`=10, `cardInset`=14, `sectionGap`=18; dùng các token này khi frame có kích thước tương ứng.
- Lề màn hình: **20** (tối thiểu 16 trên máy nhỏ ≤ 360dp).
- Khoảng cách giữa các khối trên Trang chủ: 24. Giữa các thẻ trong danh sách: 12. Padding trong thẻ: 16.
- Lưới ảnh: khoảng cách 2 (lưới Ảnh) / 4 (lưới trong thẻ).
- Vùng chạm tối thiểu: **48×48dp** (Android) / 44×44pt (iOS); chế độ chữ lớn: 56.

### 10.5 Bo góc (Border radius)

| Token | Giá trị | Dùng cho |
|---|---|---|
| `radius-xs` | 6 | Badge nhỏ, tag |
| `radius-sm` | 10 | Ảnh trong lưới thẻ, thumbnail nhỏ |
| `radius-md` | 14 | Ô nhập (input), nút phụ nhỏ |
| `radius-lg` | 16 | **Nút chính** (cao 52), thẻ nhiệm vụ |
| `radius-xl` | 20 | **Thẻ nội dung** (ký ức, thẻ Trang chủ) |
| `radius-2xl` | 28 | **Bottom sheet** (2 góc trên), dialog (24) |
| `radius-full` | 999 | Chip, avatar, FAB, segmented control |
| Lưới Ảnh (MEM-02) | 0–2 | Lưới dày đặc |

> Nguyên tắc: phần tử càng lớn bo càng nhiều; ảnh trong thẻ bo theo thẻ (bằng radius thẻ trừ padding).

### 10.6 Độ nổi (Elevation) & viền

| Mức | Bóng (light) | Dùng cho |
|---|---|---|
| `elev-0` | Không, viền 1px `border` | Thẻ phụ, ô nhập |
| `elev-1` | `0 2 8 rgba(46,42,39,0.06)` | Thẻ nội dung |
| `elev-2` | `0 6 20 rgba(46,42,39,0.10)` | Thẻ nổi, FAB |
| `elev-3` | `0 -4 24 rgba(46,42,39,0.12)` | Bottom sheet, bottom nav |

Dark mode: thay bóng bằng `surface` sáng hơn 1 bậc + viền `border`.

### 10.7 Icon & minh hoạ

- **Icon:** bộ **Lucide** (`lucide_flutter`, đồng bộ với base hanoicheck) — style outline, cỡ 24 (UI), 20 (chip), 16 (metadata), 32–48 (thẻ lớn). Nét bo tròn, hợp với Nunito. Không trộn Material/Cupertino icon trong UI sản phẩm.
- **Minh hoạ:** phong cách vẽ tay mềm, màu pastel từ bảng màu; nhân vật gia đình **đa dạng** (không gán vai trò giới: Bố bế con, Mẹ đi làm…); không dùng hình bé thật trong minh hoạ empty state.
- **Emoji:** dùng cho cảm xúc (check-in, reaction) và cột mốc; không lạm dụng trong nút/tiêu đề.
- **Logo/App icon:** gợi ý ý tưởng: ngôi nhà mái tròn + trái tim + chiếc lá (tổ ấm lớn lên) trên nền san hô; tránh hình em bé (để không bị phân loại là app cho trẻ em).

### 10.8 Thành phần (Components) cốt lõi

| Component | Đặc tả |
|---|---|
| **Button – Primary** | Cao 52, radius 16, nền `primary-600`, chữ trắng `label`; disabled: nền `border`, chữ `text-tertiary`; loading: spinner thay chữ |
| **Button – Secondary** | Viền 1.5px `primary-600`, chữ `primary-600` |
| **Button – Tertiary/Text** | Chỉ chữ `primary-600` |
| **Button – Us** | Như Primary nhưng `us-700` (trong Papa & Mama) |
| **FAB “+”** | Tròn 60, `primary-500`, icon trắng 28, `elev-2`, nổi giữa bottom nav |
| **Input** | Cao 52, radius 14, nền `surface-variant`, focus viền 2px `primary-500`, label phía trên, lỗi viền `error` + dòng mô tả |
| **Chip** | Cao 36, radius full; chọn: nền `primary-100`, chữ `primary-700`, icon ✓ |
| **Child chip / avatar** | Avatar tròn với **viền 2.5px màu bé**; chip có chấm màu + tên |
| **Card – Memory** | radius 20, `elev-1`, ảnh tràn trên, nội dung padding 16 |
| **Card – Mission** | radius 16, nền `surface`, trái: ô tròn hoàn thành 28 (viền `secondary-500`, xong → tick trắng nền `secondary-500`), giữa: tên + meta, phải: avatar người làm/bé |
| **Card – Lời nhờ** | Như Mission nhưng nền `accent-100`, viền `accent-500`; không có ô hoàn thành mà có nút Nhận / Hôm nay không được |
| **Bottom sheet** | Radius trên 28, tay kéo 36×4, padding 20; scrim light #2E2A2799 (`kColorSheetScrim2E2A27Alpha60`), dark #00000099 |
| **Dialog** | Radius 24, tối đa 2 nút; hành động phá huỷ: chữ `error` (không nền đỏ lớn) |
| **Snackbar** | Nền `text-primary`, chữ `bg`, radius 14, có nút Hoàn tác |
| **Visibility pill** | Icon 🔒/👫/👨‍👩‍👧‍👦 + chữ ngắn, `caption`, nền `surface-variant` |
| **Bottom navigation** | Cao 64 + safe area, nền `surface`, `elev-3`, icon 24 + nhãn 12, mục chọn: icon Fill `primary-600` |
| **Empty state** | Minh hoạ 160–200, tiêu đề `h3`, mô tả `body` 2 dòng, 1 nút |
| **Skeleton** | Khối `surface-variant` có shimmer nhẹ (tắt khi giảm chuyển động) |

### 10.9 Chuyển động (Motion) & phản hồi

- Thời lượng: nhỏ 150ms, chuẩn 250ms, chuyển màn 300ms; easing `easeOutCubic` (vào), `easeInCubic` (ra).
- Hoàn thành nhiệm vụ: tick vẽ nét + tim bay lên (≤ 600ms) + haptic *light*.
- Cột mốc/Chào đời: confetti màu pastel (≤ 1.5s), haptic *success*.
- Kéo để làm mới: hình chiếc lá xoay.
- Tôn trọng **Reduce Motion** của hệ thống: thay hoạt ảnh bằng fade.
- Không dùng âm thanh mặc định (bố mẹ thường dùng app khi con ngủ).

### 10.10 Accessibility

- WCAG 2.2 AA; nhãn đọc màn hình (VoiceOver/TalkBack) cho mọi icon & ảnh (“Ảnh của Hana, 5 tháng, Mẹ đăng ngày 12 tháng 3”).
- Không truyền đạt thông tin chỉ bằng màu.
- Thứ tự focus hợp lý; hỗ trợ bàn phím ngoài.
- Video có điều khiển rõ, không tự phát có tiếng.
- Tương phản cao trong chế độ chữ lớn.

### 10.11 Dark mode

- Hỗ trợ đầy đủ, theo hệ thống mặc định.
- Ảnh không bị phủ màu; nền ảnh viewer luôn đen.
- Papa & Mama ở dark mode dùng `us-50 dark` (#1F1A2B) để vẫn nhận ra vùng riêng tư.

### 10.12 Quy tắc layout theo màn

- Header lớn (collapsing) cho Trang chủ bé, Timeline, Hồ sơ bé.
- Danh sách dài luôn có trạng thái skeleton.
- Màn form dài: nút chính cố định đáy (sticky), tránh bàn phím che.
- Tablet/iPad: hỗ trợ ở chế độ phóng to bố cục điện thoại (MVP), layout 2 cột [2.0].

---

## 11. Giọng văn, nội dung & thông báo

### 11.1 Giọng văn

| Nên | Không nên |
|---|---|
| Ấm áp, ngắn gọn, như người bạn hiểu chuyện | Ra lệnh, phán xét, kỹ thuật |
| Xưng “bạn”, gọi theo nhãn người dùng chọn (Ba, Má…) | “Người dùng”, “Parent A” |
| Ghi nhận nỗ lực (“Cảm ơn bạn đã dành thời gian cho con”) | Đánh giá con người (“Bạn là người bố tuyệt vời”) |
| Lời mời (“Thử…”, “…nhé?”) | “Bạn phải”, “Bạn đã thất bại”, “Bạn quên…” |
| Trung tính khi ít hoạt động (“Một tuần bình yên”) | “Bạn đã bỏ lỡ 5 nhiệm vụ” |

### 11.2 Thông báo — câu nên/tránh

| Tình huống | Nên dùng | Tránh |
|---|---|---|
| Lời nhờ | “Mama nhờ Papa: Tắm cho Haru tối nay 🛁” | “Bạn phải tắm cho bé tối nay.” |
| Nhiệm vụ chưa làm | “Chuyển *Đọc sách* sang ngày mai nhé?” | “Bạn đã không hoàn thành nhiệm vụ.” |
| Mood | “Mama vừa chia sẻ trạng thái hôm nay.” | “Mama đang rất giận bạn.” |
| Lời nhờ “Mình đang cần…” | “Mama đang cần một chút hỗ trợ. Xem nhé?” | “Bạn đang không giúp đủ.” |
| Hearts | “Hôm nay bạn đã góp 12 💗 cho cây nhà mình” (chỉ mình thấy) | “Mama được nhiều điểm hơn bạn.” |
| Cầu nối | “Có một lời mời trò chuyện bình tĩnh khi bạn sẵn sàng.” | “Bạn đang có một cuộc cãi nhau cần giải quyết.” |
| Cảm ơn | “Bạn nhận được một lời cảm ơn ❤️” | — |
| Ảnh mới (người thân) | “Có 3 ảnh mới của Hana hôm nay 🌸” | — |
| Hết hạn gói | “Gói Family sẽ hết hạn ngày 12/10. Ký ức của nhà mình vẫn an toàn.” | “Tài khoản sắp bị khoá.” |
| Màn hình khoá (ẩn nội dung) | “Baby Family — Bạn có cập nhật mới từ Papa & Mama” | Lộ cảm xúc/nội dung |

> Câu mẫu dùng nhãn mặc định Papa/Mama; app thay bằng nhãn gọi thực tế của từng người.

### 11.3 Ngôn ngữ

- Hệ thống đa ngôn ngữ — đặc tả đầy đủ ở **7.27**. MVP: Tiếng Việt (mặc định) + English.
- Mọi câu chữ trong tài liệu này (nút, thông báo, câu mẫu) là **bản tiếng Việt gốc**; bản tiếng Anh do Content dịch theo cùng giọng văn (ấm áp, không phán xét — 11.1, 11.2).
- Định dạng theo ngôn ngữ: vi `dd/MM/yyyy`, en `MM/dd/yyyy`; giờ 24h; giá gói do Store hiển thị theo tiền tệ địa phương (`399.000 ₫`).

---

## 12. Quy tắc nghiệp vụ toàn cục (BR)

| Mã | Quy tắc |
|---|---|
| BR-001 | Mọi gia đình riêng tư; không có khám phá công khai, không link công khai. |
| BR-002 | Một Family có tối đa 2 Parent; không có Parent thứ 3. |
| BR-003 | Một tài khoản là Parent của tối đa 1 gia đình đang hoạt động; có thể là người thân ở các gia đình khác. |
| BR-004 | Papa & Mama Space chỉ tồn tại khi đủ 2 Parent đang liên kết. |
| BR-005 | Người thân (Circle) không bao giờ truy cập Papa & Mama Space, nhiệm vụ, lời nhờ, Hearts, thống kê chăm con, nhật ký riêng. |
| BR-006 | Quyền người thân luôn theo từng bé/thai kỳ; không có quyền cấp gia đình; bé mới không tự chia sẻ (trừ bé sinh từ thai kỳ đã chia sẻ). |
| BR-007 | Family Circle chỉ có ở gói Family (dùng thử và House không mời được người thân); hạ gói/hết hạn → người thân bị tạm dừng, không bị xoá. |
| BR-008 | Tối đa 12 người thân (gồm lời mời đang chờ). |
| BR-009 | Ký ức thuộc Family, gắn 0..N bé; không nhân bản media; 1 luồng bình luận. |
| BR-010 | Cột mốc thuộc đúng 1 bé. |
| BR-011 | Ký ức có visibility riêng, đổi được sau khi đăng; thu hẹp có hiệu lực ngay. |
| BR-012 | Người thân không thể gắn bé ngoài phạm vi được chia sẻ. |
| BR-013 | Người thân không thấy tên/sự tồn tại của bé không được chia sẻ, kể cả qua ký ức chung. |
| BR-014 | Ký ức do người thân đăng cần duyệt nếu gia đình bật (mặc định bật). |
| BR-015 | GPS trong ảnh luôn bị xoá trên máy chủ. |
| BR-016 | Nháp riêng tư không bao giờ tự chia sẻ. |
| BR-017 | Hearts không bao giờ âm; bỏ khỏi hôm nay / hết hạn / lời nhờ bị từ chối = 0. |
| BR-018 | Hearts của mỗi Parent **chỉ người đó thấy**; không màn hình, API, thông báo, recap hay bản xuất dữ liệu gia đình nào hiển thị Hearts của người khác hoặc so sánh hai người. Cây gia đình chỉ hiển thị cấp + % tiến độ. |
| BR-019 | Bộ nhiệm vụ hệ thống mỗi ngày: hai Parent **cùng số lượng**, tổng Hearts lệch nhau ≤ 2. |
| BR-020 | Nhiệm vụ chỉ thuộc **người tạo** hoặc **Cùng nhau**; không giao nhiệm vụ cho bạn đời — muốn nhờ dùng Lời nhờ. |
| BR-021 | Nhiệm vụ phạm vi Một bé gắn đúng 1 bé; Nhiều bé ≥ 2; Cả nhà/Hai ta = 0 bé. |
| BR-022 | Nhiệm vụ nhiều bé hoàn thành 1 lần, Hearts 1 lần/người, thông báo 1 lần. |
| BR-023 | Nhiệm vụ “Hai ta” không tính vào thống kê chăm con. |
| BR-024 | Chỉ chủ nhiệm vụ được bấm hoàn thành (Cùng nhau: một trong hai, cả hai nhận đủ Hearts); không có “làm hộ”. Người thân không có nhiệm vụ. |
| BR-025 | Thống kê chăm con chỉ ở mức gia đình, luôn kèm disclaimer, không phân chia theo người. |
| BR-026 | Không gửi push về Hearts hay thống kê chăm con. |
| BR-027 | Mood hết hiệu lực sau 6h hoặc 0:00. |
| BR-028 | Ghi chú mood mặc định không chia sẻ. |
| BR-029 | Lời cảm ơn mặc định chỉ hai người; đăng lên gia đình cần bạn đời đồng ý. |
| BR-030 | Cầu nối không tự gửi nháp, không lên feed, không có thắng/thua; tự xoá theo thời hạn lưu (mặc định 30 ngày). |
| BR-031 | Nhánh an toàn luôn miễn phí, không ép liên hệ bạn đời, không thông báo cho bạn đời. |
| BR-032 | AI chỉ chạy khi người dùng bấm; đầu ra là nháp; có thể tắt toàn bộ; có báo cáo nội dung AI. |
| BR-033 | AI không nhận nhật ký riêng, nháp xung đột chưa chia sẻ, danh bạ thành viên, vị trí. |
| BR-034 | Thông báo nhạy cảm mặc định ẩn nội dung trên màn hình khoá. |
| BR-035 | Tối đa 3 thông báo không gấp/người/ngày; sự kiện nhiều bé = 1 thông báo. |
| BR-036 | Hết hạn dùng thử/gói → khoá sử dụng (SUB-07) nhưng không xoá ký ức; luôn cho tải dữ liệu về, xoá tài khoản, liên hệ hỗ trợ. Vượt dung lượng → chỉ chặn tải lên mới. |
| BR-037 | Quyền riêng tư, báo cáo, xoá tài khoản, xuất dữ liệu cơ bản, nhánh an toàn không bao giờ sau paywall. |
| BR-038 | Gói thuộc Family; chỉ Parent mua; chỉ payer đổi/huỷ. |
| BR-039 | Xoá tài khoản không xoá dữ liệu của người khác; có 30 ngày chờ; đăng xuất mọi thiết bị ngay. |
| BR-040 | Không bên nào đơn phương xoá toàn bộ dữ liệu bé khi còn Parent kia. |
| BR-041 | Lời mời: token ngẫu nhiên, dùng 1 lần, hết hạn (7 ngày bạn đời / 14 ngày người thân), thu hồi được; lời mời hiển thị rõ vai trò & quyền trước khi chấp nhận. |
| BR-042 | Gỡ thành viên → mất quyền ngay với mọi yêu cầu mới, link ảnh cũ hết hạn ≤ 1 giờ, cache trên máy bị xoá ở lần đồng bộ sau. |
| BR-043 | Mọi thao tác admin có lý do + audit; admin không xem nội dung ngoài phạm vi case. |
| BR-044 | Báo cáo “an toàn trẻ em” ẩn nội dung tạm thời ngay, ưu tiên xử lý ≤ 24h. |
| BR-045 | Cột mốc/catalog không hiển thị độ tuổi “chuẩn” và không đánh giá phát triển. |
| BR-046 | Thai kỳ dừng lại: tắt toàn bộ nhắc & chúc mừng ngay, không thông báo cho người thân. |
| BR-047 | Bé sinh từ thai kỳ kế thừa ký ức (liên kết, không sao chép) và quyền chia sẻ của thai kỳ. |
| BR-048 | Mọi thao tác tạo ký ức/nhiệm vụ phải xác định rõ bé hoặc “cả nhà”. |
| BR-050 | Sau đăng nhập bắt buộc chọn vai trò Bố / Mẹ / Người thân (trừ khi vào bằng lời mời — vai trò theo lời mời). |
| BR-051 | Bố/Mẹ tạo gia đình bắt buộc mời bạn đời; không có lựa chọn bỏ qua. |
| BR-052 | Gia đình chưa đủ Bố + Mẹ (`WAITING_PARTNER`) không dùng được bất kỳ tính năng nào, kể cả tạo bé/thai kỳ. Khi một Parent xoá tài khoản (`PARTNER_LEFT`), người còn lại chỉ xem & tải về. |
| BR-053 | Người thân chỉ dùng app khi đã tham gia gia đình qua lời mời của Bố/Mẹ; người thân không tạo được gia đình/bé. |
| BR-054 | Mỗi gia đình được dùng thử miễn phí 90 ngày, bắt đầu khi đủ Bố + Mẹ; Parent đã từng dùng thử ở gia đình khác thì gia đình mới không được dùng thử. |
| BR-055 | Chỉ mua/nâng cấp gói khi gia đình đủ Bố + Mẹ; Bố hoặc Mẹ đều mua được; gói áp dụng cho cả gia đình. |
| BR-056 | Dùng thử 90 ngày được cấp tự động khi gia đình đủ Bố + Mẹ (không qua Store); hết hạn → thông báo Papa & Mama, bắt buộc nâng cấp mới tiếp tục sử dụng (BR-036). |
| BR-057 | Tạm thời không hỗ trợ Bố/Mẹ rời gia đình hoặc tách bạn đời; chỉ có xoá tài khoản (bắt buộc theo Store). Người thân vẫn rời được. |
| BR-058 | Gia đình hết hạn được giữ dữ liệu ~12 tháng, báo trước 30 và 7 ngày trước khi xoá vĩnh viễn. |
| BR-060 | Hệ thống hỗ trợ đa ngôn ngữ; MVP: vi (mặc định) + en. Thêm ngôn ngữ không cần sửa code màn hình. |
| BR-061 | Ngôn ngữ là lựa chọn của từng người dùng (không theo gia đình); lần đầu theo ngôn ngữ thiết bị nếu hỗ trợ, ngược lại Tiếng Việt. |
| BR-062 | Đổi ngôn ngữ có hiệu lực ngay, không cần khởi động lại; đã đăng nhập thì lưu vào tài khoản. |
| BR-063 | Thông báo đẩy, hộp thông báo, email/SMS gửi theo ngôn ngữ của **người nhận**. |
| BR-064 | Nội dung người dùng tạo không được tự động dịch. |
| BR-065 | Nội dung hệ thống thiếu bản dịch: dùng English, thiếu tiếp dùng Tiếng Việt; giao diện app phải đủ bản dịch trước khi phát hành. |
| BR-066 | Múi giờ độc lập với ngôn ngữ; ngày/số định dạng theo ngôn ngữ, ngày nghiệp vụ tính theo múi giờ gia đình. |
| BR-067 | Lời nhờ luôn có “Hôm nay không được”, không bị phạt; bị từ chối → không gửi lại cùng nội dung trong 12 giờ; không có nút giục; tối đa 5 lời nhờ đang mở/người gửi. |
| BR-068 | Lời nhờ “Mình đang cần…” không quy đổi Hearts; Lời nhờ một việc hoàn thành = +5 Hearts cho người làm. |
| BR-069 | Nhiệm vụ tự gõ (`CUSTOM`) = 2 Hearts, tối đa 3 lần tính Hearts/người/ngày; trần 75 Hearts/người/ngày. |
| BR-070 | Lời nhờ không xuất hiện trong danh sách nhiệm vụ; người thân không bao giờ thấy lời nhờ. |
| BR-071 | Góc nhìn thứ hai kế thừa visibility của ký ức gốc, không rộng hơn; mỗi Parent tối đa 1 góc nhìn/ký ức; người thân không thêm góc nhìn. |
| BR-072 | Mỗi bé mỗi tháng tuổi có đúng 1 ảnh tháng chính; đổi ảnh chính không xoá ảnh cũ. |
| BR-073 | Gợi ý ghi lại tối đa 1/ngày/Parent, không bao giờ mang nội dung gây tội lỗi; tắt được. |

---

## 13. Ngoại lệ & Edge cases

### 13.1 Gia đình & quyền

| Case | Xử lý |
|---|---|
| Mời nhầm người làm Parent | Bước “Tôi xác nhận lần cuối” chặn; nếu đã xác nhận nhầm → CSKH hỗ trợ gỡ (cần cả 2 Parent xác nhận hoặc người bị nhầm tự rời). |
| Hai người tạo 2 gia đình riêng, muốn gộp | MVP không gộp tự động; hướng dẫn 7.3. |
| Parent B không bao giờ tham gia | Gia đình ở `WAITING_PARTNER`, không dùng được (BR-052); nhắc gửi lại lời mời tối đa 3 lần; gia đình chờ > 90 ngày không có hoạt động → tự huỷ (không có dữ liệu). |
| Hai người cùng tự tạo gia đình (cùng đang chờ) | Một người nhập mã của người kia → gia đình rỗng của mình tự huỷ. |
| Người chọn nhầm vai trò Người thân | Ở CIR-WAIT bấm “Tôi là Bố/Mẹ của bé” → quay lại ONB-03. |
| Hai người chăm bé nhưng không phải vợ chồng (vd. mẹ + bà ngoại nuôi cháu) | Vẫn có thể là 2 Parent (nhãn “Mẹ” và “Bà”) — app không kiểm tra quan hệ; Papa & Mama Space có thể tắt (US-15). |
| Đổi quan hệ người thân | Chỉ đổi nhãn; không thể nâng thành Parent bằng sửa quyền (phải qua lời mời bạn đời khi còn slot). |
| Ông bà dùng chung tài khoản | Cho phép, nhãn “Ông bà nội”. |
| Người thân ở 2 gia đình (bà nội của cả nhà anh và nhà em) | Bộ chuyển gia đình (FAM-08). |
| Parent muốn chuyển sang gia đình khác | Không hỗ trợ trong MVP (BR-057); CSKH xử lý trường hợp đặc biệt. |

### 13.2 Bé & thai kỳ

| Case | Xử lý |
|---|---|
| Sinh đôi/đa thai | 1 thai kỳ → N bé; ký ức thai kỳ liên kết mọi bé. |
| Khai 1 bé, sinh đôi | “Thêm bé sinh cùng thai kỳ” có xác nhận, ghi audit. |
| Bé sinh trước/sau dự sinh | Dùng ngày sinh thật; không đánh giá. |
| Sai ngày sinh, sửa sau nhiều tháng | Nhãn tuổi tính lại; ngày ký ức không đổi; cột mốc truyền thống tính lại & hỏi có cập nhật nhắc không. |
| Ký ức xảy ra trước khi có tài khoản | Lùi ngày thoải mái (không giới hạn; cảnh báo nếu trước ngày bắt đầu thai kỳ quá 1 năm). |
| Tạo trùng bé (2 Parent cùng thêm) | Cảnh báo trùng; nếu đã tạo → công cụ “Gộp 2 hồ sơ bé” [1.1] (chuyển liên kết ký ức sang 1 bé). |
| Xoá nhầm bé | Lưu trữ trước, xoá vĩnh viễn sau ≥ 7 ngày; thùng rác 30 ngày. |
| Mất thai | 7.5, PREG-06. |
| Bé mất (trường hợp đau lòng) | Hồ sơ bé có trạng thái “Tưởng nhớ” [PO]: dừng mọi nhắc/gợi ý/sinh nhật tự động; giữ ký ức; ngôn ngữ nhẹ nhàng. Cần UX review riêng. |

### 13.3 Ký ức & album

| Case | Xử lý |
|---|---|
| Người thân đăng ảnh không phù hợp | Duyệt trước (mặc định); Báo cáo/Gỡ; gỡ người thân. |
| Ảnh có bé của gia đình khác (con hàng xóm) | Không gắn được bé ngoài gia đình; khuyến cáo trong Điều khoản về ảnh người khác. |
| Parent không muốn ông bà tải ảnh | Mặc định tắt “Cho phép tải”. |
| Bình luận bị xoá nhưng thông báo đã gửi | Mở thông báo → “Bình luận không còn”. |
| Recap chứa ký ức đã xoá | Recap tự loại ký ức đó; nếu là ảnh bìa → chọn ảnh khác. |
| Tải lên giữa chừng thì bị gỡ khỏi gia đình | Huỷ hàng đợi, xoá file tạm, báo “Bạn không còn quyền đăng”. |
| Mất mạng khi tạo ký ức | Lưu cục bộ, gửi khi có mạng (tối đa 7 ngày, sau đó nhắc). |
| Hai người sửa cùng ký ức | Người lưu sau thắng ở từng trường; hiển thị “Mẹ vừa cập nhật ký ức này”. |
| Video quá dài so với gói | Cho cắt ngắn trước khi tải hoặc nâng cấp. |
| Bỏ gắn bé làm người thân mất quyền xem | Cảnh báo trước khi lưu. |

### 13.4 Nhiệm vụ & Lời nhờ

| Case | Xử lý |
|---|---|
| Hai người cùng bấm “Xong cùng nhau” | Server ghi nhận 1 lần hoàn thành; cả hai nhận Hearts đúng 1 lần. |
| Bạn đời đã làm giúp một việc trong tab của mình | Người chủ tự bấm Xong (tin tưởng); lần sau nên dùng Lời nhờ để được ghi nhận đúng người. |
| Một người đổi nhiệm vụ liên tục để chọn việc nhẹ | Tối đa 3 lần đổi/ngày; lựa chọn đổi luôn có Hearts ±1 nên không phá cân bằng. |
| Một người tắt gần hết category | Vẫn bày đủ số lượng từ category còn lại; nếu catalog không đủ → lấy category chung (BONDING/MEMORY). |
| Đổi mức Nhẹ/Vừa/Nhiều giữa ngày | Áp dụng từ bảng ngày mai; báo bạn đời. |
| Gia đình kích hoạt lúc 20:00 | Bày ngay bộ mức Nhẹ cho hôm nay; từ mai theo mức đã chọn. |
| Muốn đánh dấu xong nhiệm vụ đã hết hạn | Cho đến hết ngày hôm sau (cờ ghi muộn), vẫn được Hearts. |
| Lời nhờ bị từ chối, người gửi gửi lại liên tục | Chặn gửi lại cùng nội dung 12h (BR-067). |
| Người nhận im lặng với lời nhờ | Hết hạn theo 7.16.2, người gửi nhận thông báo trung tính “Lời nhờ đã hết hạn — bạn có muốn tự làm không?”. |
| Lặp lại rơi vào ngày đi du lịch | Tạm dừng chuỗi theo khoảng ngày. |
| Đổi múi giờ (đi nước ngoài) | Bảng nhiệm vụ theo múi giờ **gia đình**; nhắc theo múi giờ **thiết bị** — hiển thị cả hai nếu khác. |
| Bé được lưu trữ có nhiệm vụ lặp | Tạm dừng các chuỗi của bé đó; bảng ngày mai không bày việc cho bé đó. |
| Thai kỳ dừng lại | Ngừng ngay nhiệm vụ thai kỳ; bảng ngày mai chỉ còn việc chung/`SELF` nhẹ nhàng (7.8). |

### 13.5 Papa & Mama

| Case | Xử lý |
|---|---|
| Một người dùng Papa & Mama, người kia không | Người kia không bị nhắc quá 1 lần/tuần; mood vẫn gửi được, hiển thị “chưa xem”. |
| Một người không muốn dùng Papa & Mama | Tắt chia sẻ mood/thông báo Papa & Mama; không có tách liên kết (BR-057). |
| Phiên Cầu nối đang mở thì một bên xoá tài khoản | Đóng phiên ngay; nội dung của người xoá bị xoá. |
| Nháp có nội dung nguy hiểm | Nhánh an toàn. |
| Muốn xoá lịch sử mood nhưng giữ lời cảm ơn | Hai thao tác xoá riêng. |
| Máy dùng chung với con lớn | Khoá Face ID riêng cho Papa & Mama. |

### 13.6 Gói dịch vụ

Xem 5.8 – 5.9.

---

## 14. Use cases & Acceptance criteria

### 14.1 Use cases xuyên suốt

| ID | Use case | Luồng rút gọn | Kết quả mong đợi |
|---|---|---|---|
| UC-01 | Mẹ bầu tạo gia đình, mời Bố | Đăng nhập → Vai trò Mẹ → Tên gia đình → Mời Bố qua Zalo (bắt buộc) → Chờ → Bố chấp nhận → Mẹ xác nhận → dùng thử 3 tháng → Đang mang thai → Bơ, dự sinh | 1 gia đình ACTIVE, Bố thấy thai kỳ, Papa & Mama mở khoá |
| UC-02 | Bố lưu ảnh siêu âm | + → Ký ức → ảnh → loại Siêu âm (tuần tự điền) → Bố mẹ → Lưu | Ký ức trên dòng thời gian thai kỳ |
| UC-03 | Bé chào đời | Bé đã chào đời → 1 bé → thông tin → xác nhận | Hồ sơ Hana, cột mốc Chào đời, ký ức thai kỳ ở đầu timeline Hana, nhiệm vụ sơ sinh |
| UC-04 | Mời bà nội (gói Family) | Mời người thân → Bà nội → Hana → Bình luận → Zalo → bà đăng nhập SĐT | Bà chỉ thấy Hana, bình luận được |
| UC-05 | Bố thay tã | CARE-01 tab Của tôi → chạm ô tròn → bỏ qua ảnh | DONE, +4 Hearts (chỉ Bố thấy), cây thêm 1 lá |
| UC-06 | Mẹ giao Bố tắm bé | Tạo → Haru → Bố → 19:30 → lời nhắn → Gửi → Bố Nhận → nhắc 19:15 → Xong + ảnh | Ký ức “Bố tắm cho Haru”, Mẹ nhận thông báo + nút cảm ơn |
| UC-07 | Bố không làm được | Lời nhờ của Mẹ → Hôm nay không được (“về muộn”) | DECLINED, 0 Hearts, Mẹ nhận thông báo trung tính + nút “Tự mình làm” |
| UC-08 | Cả nhà đi công viên | Nhiệm vụ Cả nhà ở tab Cùng nhau → Xong cùng nhau (mỗi người +8 Hearts) → 3 ảnh → Khoảnh khắc gia đình, Cả nhà | 1 ký ức trên feed người thân |
| UC-09 | Mẹ mệt cần nghỉ | Check-in Mệt + Cần nghỉ 30' → chia sẻ → Bố “Để mình lo” | Lời nhờ đã nhận của Bố, Đã xong → +5 Hearts (chỉ Bố thấy), Mẹ gửi cảm ơn |
| UC-10 | Bố về kiệt sức cần yên tĩnh | Check-in Kiệt sức + Yên tĩnh 20' → Mẹ “Đã hiểu” | Khung yên tĩnh của Bố 20' (thông báo không gấp được giữ lại) |
| UC-11 | Mẹ thấy không được hỗ trợ | Cầu nối → Thất vọng → Giúp đỡ thực tế → viết nháp → chọn ý chia sẻ → mời Bố | Bố nhận lời mời, không thấy nháp |
| UC-12 | Hai người vừa cãi nhau | Cả hai tham gia → song song → Mình hiểu → “Nói lại sau khi con ngủ” → đóng | RESOLVED, nội dung tự xoá sau 30 ngày |
| UC-13 | Một người chưa muốn nói | Lời mời → Để sau (tối nay) | Nhắc lại 21:00, không áp lực |
| UC-14 | Bố gửi lời cảm ơn | Cảm ơn → câu mẫu → Gửi | Chỉ Mẹ thấy |
| UC-15 | Recap tuần | Chủ nhật → xem → chia sẻ với người thân | Người thân thấy recap (không có phần Papa & Mama) |
| UC-16 | Ngày này năm xưa | Trang chủ → mở → chia sẻ lại với chú thích mới | Ký ức mới tham chiếu ký ức cũ |
| UC-17 | Người thân đăng ảnh không phù hợp | (đã duyệt) → Parent Báo cáo/Gỡ khỏi gia đình | Ảnh gỡ, case kiểm duyệt |
| UC-18 | Bố xoá tài khoản (gia đình vẫn còn Mẹ) | Xoá tài khoản → xác thực → 30 ngày | Gia đình `PARTNER_LEFT`; Mẹ chỉ xem & tải về, có thể mời bạn đời mới |
| UC-19 | Parent xoá tài khoản | Xoá → (là Parent duy nhất) xoá cả gia đình → OTP → xác nhận | Đăng xuất mọi máy, 30 ngày chờ, sau đó xoá |
| UC-20 | Hết 3 tháng dùng thử chưa mua | Ngày 91 mở app | SUB-07 bắt buộc; vẫn tải dữ liệu về được; người thân thấy CIR-05; mua House/Family → mở khoá ngay |
| UC-20b | Gói Family hết hạn không gia hạn | Hết ân hạn | Như UC-20 |
| UC-23 | Bố đăng nhập chưa có lời mời | Vai trò Bố → mời Mẹ → mở app lại | Luôn ở ONB-WAIT, không tạo được bé |
| UC-24 | Bà tự cài app | Vai trò Người thân → CIR-WAIT → “Nhờ con mời mình” → Mẹ mời → Bà chấp nhận | Bà vào CIR-01 |
| UC-21 | Nâng House → Family | Gói → Nâng cấp → Store → thành công | Người thân mở ngay |
| UC-22 | Hai bố mẹ cùng mua | Mẹ đã có House, Bố mua Family | Gia đình dùng Family; Mẹ được nhắc huỷ House |
| UC-MC-01 | Gia đình 2 con | Thêm Hana (2t) và Haru (5 tháng) | 1 gia đình, switcher có 2 bé |
| UC-MC-02 | Ảnh 2 bé | Gắn Hana + Haru | 1 ký ức, 2 timeline + feed 1 lần |
| UC-MC-03 | Nhiệm vụ 2 bé | Đọc sách cho Hana & Haru | 1 lần hoàn thành, 1 lần Hearts/người |
| UC-MC-04 | Bà nội chỉ xem Hana | Mở ảnh Hana + Haru | Thấy ảnh, chỉ thấy tên Hana, không mở được Haru |
| UC-MC-05 | Mang thai lần 2 | Thêm bé → Đang mong bé | Thai #2 song song Hana |
| UC-MC-06 | Thai #2 sinh đôi | Bé chào đời → 2 bé | 2 hồ sơ, ký ức thai kỳ liên kết cả hai |
| UC-MC-07 | Đang xem Haru mở Papa & Mama | | Papa & Mama không bị lọc |

### 14.2 Acceptance criteria cấp sản phẩm

**Tài khoản & gia đình**
- AC-001: Đăng nhập được bằng Apple, Google, SĐT+OTP; iOS luôn có Sign in with Apple.
- AC-002: Sau đăng nhập không có lời mời → bắt buộc chọn vai trò; Bố/Mẹ không thể vào Trang chủ, tạo bé, ký ức, nhiệm vụ hay mua gói khi gia đình chưa đủ Bố + Mẹ (kiểm cả UI và API).
- AC-002b: Người thân chưa có gia đình chỉ thấy CIR-WAIT.
- AC-003: Lời mời hiển thị vai trò, quyền, bé được chia sẻ **trước** khi chấp nhận.
- AC-004: Người đang là Parent ở gia đình khác không thể chấp nhận lời mời Parent (hiển thị INV-03).
- AC-005: Không thể có Parent thứ 3 dù gửi nhiều lời mời đồng thời.
- AC-006: Chấp nhận lời mời 2 lần (retry) chỉ tạo 1 thành viên.

**Người thân & quyền**
- AC-010: Người thân được chia sẻ Hana không thấy Haru ở switcher, timeline, ký ức chung (tên/avatar), deep link hồ sơ Haru.
- AC-011: Người thân không truy cập được bất kỳ dữ liệu Papa & Mama/nhiệm vụ/lời nhờ/Hearts/thống kê nào kể cả biết ID.
- AC-012: Gỡ người thân → yêu cầu tiếp theo bị từ chối; ảnh cũ không mở được sau ≤ 1 giờ.
- AC-013: Dùng thử và gói House không mời được người thân (UI ẩn/khoá, API từ chối); hạ từ Family/hết hạn → người thân thấy CIR-05, nâng lại → khôi phục quyền cũ.
- AC-014: Ký ức người thân đăng (khi bật duyệt) chỉ người đăng & Parent thấy đến khi duyệt.

**Ký ức**
- AC-020: Tạo ký ức với tối thiểu 1 nội dung; lùi ngày được; chọn visibility trước khi đăng.
- AC-021: Ký ức gắn 2 bé: 1 bản, 1 luồng bình luận, hiển thị ở 2 timeline, 1 thẻ ở “Tất cả”.
- AC-022: Ảnh tải về từ server không còn GPS.
- AC-023: Mất mạng khi tạo → không mất chú thích; tự gửi khi có mạng.
- AC-024: Xoá → vào thùng rác 30 ngày; khôi phục được.
- AC-025: Vượt quota → không xoá dữ liệu, chặn tải lên mới với thông báo rõ.
- AC-026: Ngày tròn tháng của bé → Trang chủ có thẻ “Chụp ảnh tháng”; ảnh chụp từ MEM-21 tự gắn đúng bé & tháng tuổi và hiện ở MEM-20 + làm bìa chương tháng.
- AC-027: Bạn đời thêm góc nhìn vào ký ức → ký ức hiển thị 2 phần kể, có huy hiệu “Cả hai cùng kể”; người thân chỉ thấy nếu ký ức gốc cho phép họ xem.
- AC-028: Ký ức mới của bạn đời trong ngày làm vòng tròn bé trên Trang chủ có viền “chưa xem”; xem xong viền biến mất (theo từng người).
- AC-029: Thẻ Câu nói hiển thị đúng tuổi của bé tại ngày xảy ra; tạo được trong ≤ 3 chạm.

**Nhiệm vụ & Hearts**
- AC-030: Mỗi ngày lúc 05:00 (giờ gia đình) bảng nhiệm vụ có số nhiệm vụ hệ thống của Papa = của Mama theo mức đã chọn, tổng Hearts lệch ≤ 2, + nhiệm vụ Cùng nhau.
- AC-031: Bỏ khỏi hôm nay / hết hạn / lời nhờ bị từ chối không làm giảm Hearts.
- AC-032: Nhiệm vụ nhiều bé hoàn thành 1 lần = 1 sự kiện Hearts/người = 1 thông báo.
- AC-033: Hai người cùng bấm “Xong cùng nhau” đồng thời → 1 completion, mỗi người nhận Hearts đúng 1 lần.
- AC-034: Đăng nhập tài khoản Papa không thấy Hearts của Mama ở bất kỳ màn/API nào (và ngược lại); API Hearts của bạn đời trả 403/không có trường Hearts.
- AC-035: Hoàn thành nhiệm vụ có thể tạo ký ức gắn sẵn bé của nhiệm vụ.
- AC-036: Không tạo được nhiệm vụ có chủ là bạn đời (UI không có lựa chọn; API trả lỗi `MISSION_OWNER_INVALID`).
- AC-037: Lời nhờ có Nhận / Hôm nay không được; không có nút giục; lời nhờ không xuất hiện trong tab nhiệm vụ; người thân không truy cập được.
- AC-038: Đổi nhiệm vụ tối đa 3 lần/ngày, các lựa chọn có Hearts ±1.

**Papa & Mama**
- AC-040: Mood có thể giữ riêng; ghi chú mood mặc định không chia sẻ.
- AC-041: Nhật ký riêng không trả về cho bạn đời qua bất kỳ API/màn nào.
- AC-042: Lời cảm ơn mặc định chỉ bạn đời thấy.
- AC-043: Cầu nối không hiển thị nháp riêng cho bạn đời; có thể tạm dừng/rời bất kỳ lúc nào; không có phán xử.
- AC-044: Nhánh an toàn không thông báo cho bạn đời.
- AC-045: Papa & Mama không thay đổi khi đổi bé ở switcher.

**Quyền riêng tư & thông báo**
- AC-050: Thông báo nhạy cảm ẩn nội dung trên màn hình khoá theo mặc định.
- AC-051: Feed/recap/xuất dữ liệu gia đình không chứa dữ liệu Papa & Mama.
- AC-052: Sự kiện gắn nhiều bé chỉ gửi 1 thông báo.

**Gói**
- AC-060: Paywall có giá, chu kỳ, tự gia hạn, Điều khoản, Quyền riêng tư, Khôi phục giao dịch.
- AC-061: Mua thành công → quyền lợi áp dụng cho cả Bố, Mẹ (và người thân) trong ≤ 1 phút.
- AC-062: Hoàn tiền/thu hồi từ Store → mất quyền lợi, không mất dữ liệu.
- AC-063: Dùng thử 90 ngày bắt đầu đúng lúc gia đình đủ Bố + Mẹ, chỉ 1 lần; Parent đã từng dùng thử thì gia đình mới không được dùng thử.
- AC-064: Ngày thứ 91 (giờ gia đình) chưa mua → SUB-07 với cả Bố và Mẹ; API tạo mới trả lỗi “cần nâng cấp”; tải dữ liệu về & xoá tài khoản vẫn hoạt động.
- AC-065: Bố hoặc Mẹ mua đều mở khoá cho cả gia đình trong ≤ 1 phút.

**Đa ngôn ngữ**
- AC-080: Máy đặt ngôn ngữ English → mở app lần đầu hiển thị English; máy đặt ngôn ngữ chưa hỗ trợ → Tiếng Việt.
- AC-081: Đổi ngôn ngữ ở ONB-01/SET-06 → toàn bộ màn đang mở đổi ngay, không khởi động lại; mở lại app vẫn giữ lựa chọn (kể cả sau khi đăng xuất).
- AC-082: Mẹ dùng English, Bố dùng Tiếng Việt: khi Mẹ gửi lời nhờ, Bố nhận thông báo đẩy bằng Tiếng Việt; khi Bố gửi cảm ơn, Mẹ nhận bằng English.
- AC-083: Catalog nhiệm vụ/cột mốc/cảm xúc hiển thị đúng ngôn ngữ người xem; mục chưa dịch hiển thị bản English (rồi Tiếng Việt), không hiển thị mã kỹ thuật.
- AC-084: Chú thích, nhật ký, bình luận hiển thị nguyên văn như người viết ở mọi ngôn ngữ.
- AC-085: Thông báo lỗi (mạng, hết phiên, lỗi nghiệp vụ) hiển thị đúng ngôn ngữ đang dùng.
- AC-086: Không màn hình nào bị cắt chữ/tràn khi chuyển sang English ở màn 360dp và cỡ chữ 130%.

**Xoá & xuất**
- AC-070: Xoá tài khoản tìm thấy trong Cài đặt và có trang web xoá (Google Play).
- AC-071: Xoá tài khoản giải thích rõ dữ liệu riêng vs chia sẻ; Parent duy nhất phải chọn xử lý gia đình.
- AC-072: Xuất dữ liệu gia đình gồm ảnh/video + metadata, không gồm dữ liệu Papa & Mama.

---

## 15. Chỉ số sản phẩm (KPI)

> Đo để cải thiện sản phẩm, **không** để chấm điểm người dùng.

### 15.1 North-star

**Weekly Meaningful Family Moments (WMFM)** — số “khoảnh khắc có ý nghĩa”/gia đình hoạt động/tuần, gồm: ký ức có nội dung, góc nhìn thứ hai, ảnh tháng, câu nói của con, cột mốc, nhiệm vụ hoàn thành, nhiệm vụ cùng nhau, lời nhờ được hỗ trợ, lời cảm ơn, bình luận của người thân.

### 15.2 Chỉ số theo nhóm

| Nhóm | Chỉ số | Mục tiêu ban đầu (gợi ý) |
|---|---|---|
| Kích hoạt | % tạo ký ức đầu tiên trong 24h | ≥ 60% |
| | % gửi lời mời bạn đời trong 7 ngày | ≥ 50% |
| | % lời mời bạn đời được chấp nhận trong 7 ngày | ≥ 60% |
| Ký ức | Ký ức/gia đình hoạt động/tuần | ≥ 5 |
| Chăm con | % nhiệm vụ hệ thống được hoàn thành | ≥ 40% |
| | % gia đình có **cả hai** Parent hoàn thành ≥ 1 nhiệm vụ trong ≥ 3 ngày/tuần (shared care) | ≥ 40% |
| | Số ngày cây nở hoa/gia đình/tuần | theo dõi |
| | % lời nhờ được nhận / hoàn thành | ≥ 60% / ≥ 50% |
| Kết nối | % ngày có ≥ 1 check-in/lời nhờ/cảm ơn | theo dõi |
| Người thân | Số người thân/gia đình Family; % người thân hoạt động/tuần | ≥ 3; ≥ 50% |
| Giữ chân | D7 / D30 / D90 gia đình | ≥ 45% / 30% / 20% |
| Kích hoạt gia đình | % tài khoản Bố/Mẹ có bạn đời tham gia trong 7 ngày | ≥ 60% |
| Doanh thu | Dùng thử 3 tháng → trả phí; tỷ lệ gia hạn năm; tỷ lệ House→Family | ≥ 25%; ≥ 55%; theo dõi |
| An toàn | Báo cáo/1.000 gia đình; thời gian xử lý báo cáo trẻ em | ≤ 24h |
| Chất lượng | Crash-free sessions; % tải lên thành công | ≥ 99.5%; ≥ 98% |

---

## 16. Phạm vi MVP & Roadmap

### 16.1 Phase

| Phase | Mục tiêu | Tính năng |
|---|---|---|
| **MVP 1.0** | Chứng minh vòng lặp Ký ức + Gia đình + Nhiệm vụ, phát hành Store, bán gói | Đăng nhập Apple/Google/SĐT • Onboarding • Gia đình 2 Parent • Nhiều bé, thai kỳ, chào đời (sinh đôi) • Ký ức (ảnh/video/chữ/giọng nói/**câu nói của con**/kỷ vật), nhật ký, thư gửi con (time capsule cơ bản) • **Ảnh tháng & “Con lớn từng tháng”** • **Kể cùng nhau (góc nhìn thứ hai)** • **Hôm nay của các con** • Gợi ý ghi lại • Bộ sưu tập • Timeline, album, cột mốc (gồm truyền thống VN), thùng rác • Feed, bình luận, reaction • **Family Circle (gói Family)** + duyệt ảnh • Nhiệm vụ: bảng hằng ngày chia đều, thư viện, tự thêm, lặp, hoàn thành → ký ức • Hearts riêng/Cây gia đình, huy hiệu cơ bản • Papa & Mama: check-in, **lời nhờ**, cảm ơn, nhật ký riêng • Lịch cơ bản (âm lịch) • Recap tuần • Thông báo, giờ yên tĩnh, ẩn nội dung • Báo cáo/chặn/kiểm duyệt • Xoá tài khoản, xuất dữ liệu • **Dùng thử 3 tháng + gói House/Family (IAP)** • Admin CMS • Dark mode, chữ lớn • **Đa ngôn ngữ vi + en** (7.27) |
| **1.1** | Gắn kết cặp đôi sâu hơn | Cầu nối (không AI) + nhánh an toàn • Thống kê chăm con • Bàn giao ca • Tuần của hai ta • Câu hỏi kết nối • Recap ngày/tháng • Ngày này năm xưa đầy đủ, tìm kiếm nâng cao • Share Extension (chia sẻ từ app Ảnh) • @nhắc tên • Gộp hồ sơ bé trùng |
| **1.2** | AI có kiểm soát | Gợi ý chú thích • Câu chuyện ngày • Gợi ý nhiệm vụ AI • Viết lại nhẹ nhàng • Tóm tắt Cầu nối • Báo cáo nội dung AI • Ghi tăng trưởng (không đánh giá) |
| **2.0** | Tài sản ký ức dài hạn | Year Story, Sách của con (PDF), in sách (đối tác), time capsule nâng cao, video tổng hợp tự động, “Chọn người cụ thể” visibility, layout tablet |
| **2.x** | Mở rộng | Đồng bộ lịch, thử thách gia đình theo mùa, co-parenting (sau ly hôn), giới thiệu bạn bè (referral), gói tháng |

### 16.2 Không làm trong MVP

Tracker y tế; mạng xã hội công khai; leaderboard; quá nhiều loại điểm; AI tự can thiệp; cây phả hệ phức tạp; nhận diện khuôn mặt; in sách vật lý.

---

## 17. Phụ lục: Catalog nội dung

### 17.1 Catalog nhiệm vụ (mẫu — cần ≥ 90 ngày nội dung không lặp mỗi giai đoạn)

Mỗi template có: `mã`, tên ngắn, mô tả 1 câu, giai đoạn (tuần thai / ngày tuổi min–max), category, phạm vi gợi ý, vai trò phù hợp (Parent bất kỳ / Mẹ bầu – mẹ sau sinh / Bạn đời của mẹ bầu / Cùng nhau — ngoài thai kỳ & hậu sản **không gán theo giới**), thời lượng (phút), **Hearts** (1–10, dùng để cân bằng bảng nhiệm vụ ngày — BR-019), câu gợi ý lưu kỷ niệm.

| Giai đoạn | Mã | Nhiệm vụ | Category | Vai trò phù hợp | Phút | Hearts |
|---|---|---|---|---|---|---|
| Thai kỳ | PG-01 | Chụp một bức ảnh bụng bầu tuần này | MEMORY | Parent bất kỳ | 5 | 3 |
| | PG-02 | Cùng chọn một bài hát cho bé | COUPLE | Cùng nhau | 15 | 5 |
| | PG-03 | Sắp xếp một góc nhỏ cho bé | PREP | Cùng nhau | 30 | 5 |
| | PG-04 | Chuẩn bị một bữa ăn/đồ uống cho mẹ bầu | SUPPORT | Bạn đời của mẹ bầu | 20 | 6 |
| | PG-05 | Viết 3 điều đang mong chờ về bé | MEMORY | Cùng nhau | 10 | 3 |
| | PG-06 | Viết thư “Trước khi gặp con” | MEMORY | Parent bất kỳ | 15 | 3 |
| | PG-07 | Chuẩn bị túi đồ đi sinh | PREP | Cùng nhau | 45 | 5 |
| | PG-08 | 15 phút trò chuyện không điện thoại | COUPLE | Cùng nhau | 15 | 5 |
| | PG-09 | Đi dạo nhẹ cùng nhau | OUTDOOR | Cùng nhau | 20 | 5 |
| | PG-10 | Nói chuyện với bé trong bụng | BONDING | Parent bất kỳ | 5 | 5 |
| | PG-11 | Nghỉ trưa 30 phút, tắt thông báo | SELF | Mẹ bầu | 30 | 4 |
| | PG-12 | Đi bộ nhẹ 15 phút | SELF | Mẹ bầu | 15 | 4 |
| | PG-13 | Xoa bóp chân cho mẹ bầu 10 phút | SUPPORT | Bạn đời của mẹ bầu | 10 | 5 |
| | PG-14 | Đi chợ/mua đồ cho cả tuần | SUPPORT | Bạn đời của mẹ bầu | 45 | 6 |
| 0–3 tháng | NB-01 | Thay tã cho bé một lần | CARE | Parent bất kỳ | 5 | 4 |
| | NB-02 | Hát cho bé nghe một bài | BONDING | Parent bất kỳ | 5 | 5 |
| | NB-03 | Bế bé áp da nếu gia đình thấy phù hợp | BONDING | Parent bất kỳ | 15 | 5 |
| | NB-04 | Chụp một bức ảnh cả nhà | MEMORY | Cùng nhau | 5 | 3 |
| | NB-05 | Cho bạn đời 30 phút nghỉ | SUPPORT | Parent bất kỳ | 30 | 8 |
| | NB-06 | Nói chuyện với bé 5 phút | BONDING | Parent bất kỳ | 5 | 5 |
| | NB-07 | Ghi âm giọng nói của bạn cho bé | MEMORY | Parent bất kỳ | 5 | 3 |
| | NB-08 | Ghi lại một điều buồn cười hôm nay | MEMORY | Parent bất kỳ | 3 | 3 |
| | NB-09 | Giờ đi ngủ không điện thoại | TOGETHER | Cùng nhau | 20 | 8 |
| | NB-10 | Giặt và gấp đồ cho bé | HOME | Parent bất kỳ | 20 | 3 |
| | NB-11 | Ngủ bù 1 tiếng khi bé ngủ | SELF | Mẹ sau sinh (6 tuần đầu) | 60 | 4 |
| | NB-12 | Tắm cho bé buổi tối | CARE | Parent bất kỳ | 20 | 5 |
| | NB-13 | Ru bé ngủ một lần | CARE | Parent bất kỳ | 20 | 5 |
| 4–6 tháng | IN-01 | Chơi ú oà (peekaboo) | PLAY | Parent bất kỳ | 10 | 5 |
| | IN-02 | Đọc sách tranh 10 phút | BONDING | Parent bất kỳ | 10 | 5 |
| | IN-03 | Cho bé nằm sấp chơi (tummy time) có người trông | PLAY | Parent bất kỳ | 10 | 5 |
| | IN-04 | Đi dạo cùng bé | OUTDOOR | Parent bất kỳ | 20 | 5 |
| | IN-05 | Quay video tiếng cười của bé | MEMORY | Parent bất kỳ | 3 | 3 |
| | IN-06 | Gọi video cho ông bà | BONDING | Parent bất kỳ | 10 | 5 |
| 7–12 tháng | IF-01 | Chơi tìm đồ vật | PLAY | Parent bất kỳ | 10 | 5 |
| | IF-02 | Đọc truyện trước khi ngủ | BONDING | Parent bất kỳ | 10 | 5 |
| | IF-03 | Đi công viên | OUTDOOR | Cùng nhau | 45 | 8 |
| | IF-04 | Cả nhà cùng ăn một bữa | TOGETHER | Cùng nhau | 30 | 8 |
| | IF-05 | Chụp ảnh “tháng thứ N” | MEMORY | Parent bất kỳ | 5 | 3 |
| | IF-06 | Nhảy cùng nhau 10 phút | TOGETHER | Cùng nhau | 10 | 8 |
| 1–2 tuổi | TD-01 | Dạy con một từ mới | BONDING | Parent bất kỳ | 10 | 5 |
| | TD-02 | Vẽ nguệch ngoạc cùng con | PLAY | Parent bất kỳ | 15 | 5 |
| | TD-03 | Cho con chọn giữa 2 cuốn sách | BONDING | Parent bất kỳ | 10 | 5 |
| | TD-04 | Làm một việc nhà nhỏ cùng con | PLAY | Parent bất kỳ | 10 | 5 |
| | TD-05 | Picnic mini | TOGETHER | Cùng nhau | 60 | 8 |
| | TD-06 | Ghi lại câu nói đáng yêu của con | MEMORY | Parent bất kỳ | 3 | 3 |
| 2–3 tuổi | PS-01 | Hát và nhảy cùng con | PLAY | Parent bất kỳ | 10 | 5 |
| | PS-02 | Kể chuyện bằng 3 bức tranh | BONDING | Parent bất kỳ | 15 | 5 |
| | PS-03 | 20 phút chơi không màn hình | PLAY | Parent bất kỳ | 20 | 5 |
| | PS-04 | Đi dạo riêng hai bố/mẹ con | OUTDOOR | Parent bất kỳ | 30 | 5 |
| | PS-05 | Hỏi con “Hôm nay con vui vì điều gì?” | BONDING | Parent bất kỳ | 5 | 5 |
| Nhiều bé | MC-01 | Đọc sách tranh cho cả hai bé | BONDING | Parent bất kỳ | 15 | 5 |
| | MC-02 | Chụp ảnh anh/chị em cùng nhau | MEMORY | Parent bất kỳ | 5 | 3 |
| | MC-03 | 15 phút riêng với con lớn | BONDING | Parent bất kỳ | 15 | 5 |
| Hai ta | CP-01 | Hỏi bạn đời “Hôm nay bạn cần gì?” | COUPLE | Cùng nhau | 5 | 5 |
| | CP-02 | 20 phút uống trà sau khi con ngủ | COUPLE | Cùng nhau | 20 | 5 |
| | CP-03 | Nói một lời cảm ơn cụ thể | COUPLE | Cùng nhau | 2 | 5 |
| | CP-04 | 10 phút chia việc ngày mai | COUPLE | Cùng nhau | 10 | 5 |
| | CP-05 | Sau bất đồng: nói một điều mình đã hiểu | COUPLE | Cùng nhau | 5 | 5 |

> Không có nhiệm vụ mang tính ép buộc thân mật/thể chất; nhiệm vụ liên quan sức khoẻ chỉ ở dạng chung, không lời khuyên y tế; mọi template do Content duyệt.

### 17.2 Catalog cột mốc (mẫu)

| Nhóm | Cột mốc | Ghi chú |
|---|---|---|
| Truyền thống VN | Chào đời • Đầy tháng (1 tháng, chọn âm/dương) • Đầy 100 ngày • Thôi nôi (1 tuổi) • Tết đầu tiên • Trung thu đầu tiên • Cắt tóc máu • Lần đầu về quê nội • Lần đầu về quê ngoại | Có nhắc trước 3 ngày |
| Cảm xúc | Nụ cười đầu tiên • Cười thành tiếng • Nhận ra Bố/Mẹ • Vẫy tay • Hôn gió • Ôm lần đầu | |
| Vận động | Ngẩng đầu • Lẫy • Ngồi • Bò • Đứng vịn • Bước đi đầu tiên • Chạy • Leo cầu thang | |
| Ngôn ngữ | Bập bẹ • Gọi Bố • Gọi Mẹ • Từ đầu tiên • Câu đầu tiên • Hát bài đầu tiên | |
| Ăn uống | Ăn dặm lần đầu • Món đầu tiên • Tự cầm thìa • Uống bằng cốc | |
| Cơ thể | Chiếc răng đầu tiên • Lần cắt tóc đầu tiên • Lần đầu tự đi giày | |
| Trải nghiệm | Đi biển • Đi máy bay • Đi công viên • Đi sở thú • Đi bơi • Đi nhà trẻ ngày đầu | |
| Gia đình | Gặp ông bà nội • Gặp ông bà ngoại • Gặp em/anh/chị • Sinh nhật đầu tiên • Ảnh cả nhà đầu tiên | |
| Thai kỳ | Que thử 2 vạch • Lần siêu âm đầu • Nghe tim thai • Lần đầu bé đạp • Biết giới tính (tuỳ chọn) • Chọn được tên | Gắn thai kỳ (trở thành cột mốc của bé sau sinh) |

### 17.3 Cảm xúc & nhu cầu

| Cảm xúc | Hiển thị cho bạn đời | Phản hồi gợi ý |
|---|---|---|
| 😊 Ổn | “Mình đang ổn” | Chia sẻ một khoảnh khắc |
| 🙂 Bình thường | “Bình thường, chưa cần gì” | Gửi tim |
| 😪 Mệt | “Mình đang mệt” | Đề nghị cho nghỉ |
| 🥱 Kiệt sức | “Mình gần hết năng lượng” | Nhận một việc |
| 😣 Căng thẳng | “Mình đang căng thẳng” | Hỏi điều gì giúp được |
| 😢 Buồn | “Mình hơi buồn” | Ở bên |
| 😠 Khó chịu | “Mình đang khó chịu” | Cho không gian / Nói sau |
| 🤯 Quá tải | “Mình đang quá tải” | Gợi ý gửi Lời nhờ + gợi ý mức nhiệm vụ Nhẹ |
| 🥺 Cô đơn | “Mình thấy thiếu kết nối” | Ôm / Trò chuyện |
| 🤗 Cần quan tâm | “Mình muốn được quan tâm” | Tim / Ôm / Lời yêu thương |

### 17.4 Huy hiệu

| Huy hiệu | Điều kiện | Ý nghĩa |
|---|---|---|
| 🌙 Giờ ngủ ấm áp | 7 hoạt động giờ đi ngủ | Sự đều đặn |
| 📚 Nhà mọt sách | 10 lần đọc sách | Tương tác |
| 🌳 Gia đình ngoài trời | 5 lần ra ngoài cùng nhau | Khoảnh khắc chung |
| 🤝 Tuần đồng đội | 5 nhiệm vụ cùng nhau/tuần | Hợp tác |
| 📸 Người giữ ký ức | 30 ký ức | Lưu hành trình |
| 💐 Tuần cảm ơn | 7 lời cảm ơn trong tuần (cả hai) | Ghi nhận nhau |
| 🫶 Luôn bên nhau | 10 lời nhờ được hỗ trợ | Hỗ trợ nhau |
| 👵 Ông bà yêu thương | Người thân tương tác 20 ký ức | Gắn kết thế hệ |
| ⭐ Những lần đầu | 10 cột mốc của một bé | Hành trình |
| 💌 Lá thư thời gian | Viết thư đầu tiên | Ký ức dài hạn |

### 17.5 Câu gợi ý

- **Nhật ký:** “Hôm nay con làm điều gì lần đầu?” • “Điều gì khiến con cười?” • “Con đang mê thứ gì nhất?” • “Nếu kể lại ngày hôm nay cho con năm 18 tuổi, bạn sẽ nói gì?”
- **Cảm ơn:** “Một điều mình cảm ơn bạn hôm nay là…” • “Mình thấy bạn đã rất cố gắng khi…” • “Khoảnh khắc mình thích nhất của cả nhà hôm nay…” • “Ngày mai mình có thể giúp bạn điều gì?”
- **Câu hỏi kết nối (Hai ta):** “Điều nhỏ nào hôm nay làm bạn mỉm cười?” • “Tuần này bạn cần mình hỗ trợ việc gì nhất?” • “Bạn nhớ nhất điều gì về hai ta trước khi có con?”

### 17.6 Gợi ý ghi lại (mẫu)

| Giai đoạn | Gợi ý | Mở loại ký ức |
|---|---|---|
| Thai kỳ | “Hôm nay bé đạp nhiều không? Ghi lại cảm giác nhé.” | Nhật ký |
| | “Chụp ảnh bụng tuần này” | Ảnh tháng (bụng bầu) |
| 0–3 tháng | “Ghi âm tiếng ọ ọ của bé” | Giọng nói |
| | “Bàn tay con hôm nay nhỏ thế nào? Chụp cạnh tay bố/mẹ” | Khoảnh khắc |
| 4–12 tháng | “Con đang mê món đồ chơi nào?” | Khoảnh khắc |
| | “Quay lại tiếng cười của con tuần này” | Giọng nói |
| 1–2 tuổi | “Từ mới con nói tuần này là gì?” | Câu nói |
| | “Món con thích nhất dạo này?” | Nhật ký |
| 2–3 tuổi | “Câu nào của con làm bạn bật cười?” | Câu nói |
| | “Hỏi con: ‘Hôm nay con vui vì điều gì?’ và ghi lại câu trả lời” | Câu nói |
| Mọi giai đoạn | “Kể lại một điều nhỏ của hôm nay mà bạn muốn con biết sau này” | Thư gửi con |

---

## 18. Danh sách quyết định cần PO chốt

| # | Câu hỏi | Khuyến nghị v3.0 |
|---|---|---|
| D-01 | ~~Có mức Free không?~~ | **Đã chốt:** không có Free; dùng thử 3 tháng rồi bắt buộc mua (C-05) |
| D-01b | Giới hạn dùng thử | **Đã chốt:** 10 GB, không mời người thân (C-07) |
| D-01c | Giữ dữ liệu sau khi hết hạn | **Đã chốt:** ~12 tháng, báo trước (C-08) |
| D-01d | Rời gia đình | **Đã chốt:** tạm thời không cho phép (C-09) |
| D-01e | Cách cấp dùng thử | **Đã chốt:** tự động khi tạo gia đình thành công, không qua Store (C-10) |
| D-02 | Có gói tháng không? | Chưa ở MVP; thêm ở 2.x nếu tỷ lệ chuyển đổi năm thấp |
| D-03 | Price point chính xác trên Store | Chọn 399.000đ/599.000đ hoặc mức gần nhất |
| D-04 | Quota dung lượng (2/50/200 GB) | Giữ, theo dõi chi phí lưu trữ thực tế sau 3 tháng |
| D-05 | Một tài khoản vừa là Parent nhà mình vừa là người thân nhà khác? | **Cho phép** (bộ chuyển gia đình) |
| D-06 | Người thân có thấy Cây gia đình không? | Thấy cây (không chi tiết) — mặc định tắt, Parent bật |
| D-07 | Người thân có được viết “Thư gửi cháu” không? | **Có** (Contributor) |
| D-08 | Parent khác có đọc được thư niêm phong của người kia trước ngày mở? | **Không** (giữ bất ngờ), chỉ biết có thư |
| D-09 | Mặc định duyệt ảnh người thân | **Bật** |
| D-10 | Lịch sử Hearts có hiện ai làm không? | **Đã chốt (C-15):** Hearts chỉ người đó thấy; lịch sử Hearts chỉ hiện của chính mình |
| D-11 | Yêu thích cá nhân hay của gia đình? | Cá nhân (MVP) |
| D-12 | Trạng thái “Tưởng nhớ” cho bé đã mất | Có, UX review riêng |
| D-13 | Nội dung “Bé to bằng…” theo tuần thai | Có ở 1.1, Content + chuyên gia duyệt, tắt được |
| D-14 | Thời gian lưu Cầu nối mặc định | 30 ngày |
| D-15 | Nhà cung cấp OTP (Zalo ZNS + SMS brandname) | Zalo ZNS chính, SMS dự phòng |
| D-16 | Thị trường phát hành ban đầu | Việt Nam (vi + en) |
| D-17 | Ngôn ngữ thứ 3 và thời điểm | Quyết định theo dữ liệu người dùng ngoài VN sau 3 tháng phát hành |
| D-18 | Nhãn mặc định Bố/Mẹ | **Đã chốt:** Papa / Mama ở mọi ngôn ngữ (C-13), người dùng đổi được |
