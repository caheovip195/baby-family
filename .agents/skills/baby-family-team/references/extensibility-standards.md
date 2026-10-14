# Nguyên tắc mở rộng bắt buộc

Quyết định người dùng ngày **2026-10-13**, BF-20261013-005. Áp dụng cho thiết kế hệ thống, backend, frontend/web, mobile, database và các hợp đồng tích hợp.

## Phân biệt cấu hình với logic

- Không fix cứng danh sách gói, giá, quota, trial duration, tính năng được cấp, retry/retention có thể thay đổi hoặc nội dung đa ngôn ngữ trong nhiều nơi. Xác định owner và nguồn cấu hình duy nhất.
- Gói là catalog có ID/code và version, không enum HOUSE/FAMILY/PRO trong DB hoặc chuỗi `if plan === ...` để quyết định quyền. Thêm gói dùng các capabilities đã hỗ trợ phải làm được bằng catalog/version, không migration enum hoặc sửa nhiều client.
- Mặc định hiện tại: House + Family, trial **7 ngày**; đây là dữ liệu cấu hình ban đầu, không danh sách bất biến. Trial/license grant lưu policy/version và thời hạn đã cấp; đổi config chỉ tác động lần cấp mới trừ khi có quy trình chuyển đổi được duyệt.
- Giữ schema quan hệ có kiểu, FK, constraint và state machine rõ. Không biến mọi entity thành EAV/JSON hoặc mọi trạng thái kỹ thuật thành cấu hình tùy ý chỉ để gọi là “linh hoạt”. Enum phù hợp với trạng thái/protocol đóng; catalog phù hợp với danh sách nghiệp vụ có thể thêm.
- Không mở rộng ngoài yêu cầu bằng framework plugin, microservice, nhiều database hoặc abstract base class chưa có nhu cầu thực tế. Extension point phải có use case cụ thể.

## Backend và database

- Nguồn quyền lợi là entitlement/capabilities server trả theo family. Server luôn kiểm tra quyền, scope và quota; flag do client gửi không được dùng làm bằng chứng cấp quyền.
- Plan/version/policy có validation trước publish, đơn vị rõ (bytes, seconds, count), semantic của missing/null/unlimited rõ và fallback an toàn. Unknown capability không tự cấp quyền. Không execute code/SQL từ config.
- Version đã cấp là bất biến, có provenance/audit; thay đổi catalog không được hồi tố làm đổi giao dịch, consent hoặc quyền lợi cũ ngoài chính sách đã chốt. Rank dùng chọn gói cũng phải version hóa, không chỉ version quota.
- Giữ OOP `controller → service → repository → model`, interfaces và DI. Provider khác nhau đi qua interface/adapter phù hợp; không rải tên vendor hoặc concrete SDK trong business service. Repository giữ persistence, model không DB I/O.
- Thêm field có chiến lược default/backfill/compatibility; API và sự kiện có version khi đổi contract phá tương thích. Raw JSON mở rộng vẫn phải có schema/version, không thay thế FK cho quan hệ cốt lõi.
- Hạ gói hoặc cấu hình thay đổi không tự xóa dữ liệu. Business state và lifecycle/retention riêng, migration có rollback/recovery phù hợp.

## Frontend/web/mobile

- Đọc catalog, giá từ Store/provider phù hợp và entitlement/capabilities từ server; render danh sách gói theo dữ liệu. Không fix số thẻ gói là hai, không nhân bản quota/trial/giá trong UI, không dùng tên hiển thị làm key.
- UI kiểm khả năng như `circle.enabled`, `storage.maxBytes` theo contract được định nghĩa; backend vẫn là nơi thực thi quyền. Feature chưa được client hỗ trợ phải có fallback an toàn, không crash hoặc tự mở quyền.
- Tách data contract, business/state và presentation; dùng service/repository/component/token theo kiến trúc nền tảng. Reuse phần thực sự dùng chung, giữ localization và trạng thái loading/empty/error/offline.
- Có chiến lược client cũ khi server thêm plan/field/capability: bỏ qua field không biết, hiển thị fallback đã định nghĩa và chỉ thao tác feature đã hỗ trợ. Thêm một tính năng nghiệp vụ mới vẫn có thể cần code/migration; không hứa mọi tính năng mới chỉ cần config.

## Review bắt buộc

ARCHITECT và role triển khai phải nêu ngắn gọn: phần nào là cấu hình/catalog; nguồn sự thật; extension point; version/backward compatibility; quyền và validation. TESTER/QUALITY kiểm tra tương xứng:

1. Thêm gói thứ ba dùng capability có sẵn mà không sửa enum/nhánh tên gói.
2. Đổi trial duration/quota bằng policy version mới không làm đổi grant/giao dịch cũ.
3. Client cũ nhận plan/field mới có fallback đúng, server vẫn chặn quyền trái phép.
4. Config thiếu/sai/không biết bị từ chối hoặc fail closed, không âm thầm cấp quyền.
5. Tài liệu phân biệt chuẩn bắt buộc với phần đã triển khai, không coi sự tồn tại catalog table là bằng chứng mọi client đã dynamic.
