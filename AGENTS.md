# Quy tắc lưu trữ và quản lý thư mục dự án (Global - All Projects & Chats)

Quy tắc này là mặc định và bắt buộc tuân thủ trên mọi phiên làm việc, dự án và tác vụ.

## 1. Đường dẫn gốc (Root Path)
- Toàn bộ dự án, mã nguồn và dữ liệu công việc phải được lưu trữ tại: `D:\VibeCode` (hoặc `/storage/emulated/0/VibeCode` trên môi trường Android).

## 2. Kiểm tra trùng lặp trước khi thao tác (Anti-duplicate)
- Trước khi tạo bất kỳ thư mục mới nào, luôn quét danh sách các thư mục hiện có trong thư mục gốc `D:\VibeCode`.
- Đọc nội dung file `README.md` bên trong các thư mục liên quan để đối chiếu mục tiêu và ngữ cảnh công việc.

## 3. Nguyên tắc xử lý thư mục
- **Nếu công việc/dự án đã tồn tại hoặc có cùng mục tiêu**: Tiếp tục làm việc trực tiếp trong thư mục đó, tuyệt đối không tạo thêm thư mục mới.
- **Nếu là công việc/dự án mới hoàn toàn**: Tạo thư mục riêng theo cấu trúc: `D:\VibeCode/<ten_du_an>/`.
- **Bắt buộc tạo ngay file `README.md`** tại thư mục mới với cấu trúc chuẩn:
  * **Tên dự án / Công việc**
  * **Mục tiêu chính**
  * **Tóm tắt các tác vụ và cấu trúc thư mục**

## 4. Cơ chế ủy quyền toàn diện OpenRouter (Full Autonomous OpenRouter Delegation)
- **Phân định vai trò cốt lõi**:
  * **Antigravity (Core Brain & Communication)**: Đóng vai trò là Bộ não điều phối và giao tiếp. Antigravity tiếp nhận yêu cầu từ người dùng, quản lý tệp tin (đọc/ghi file I/O), chạy lệnh terminal/PowerShell, điều khiển giả lập, kiểm duyệt chất lượng kết quả và phản hồi cho người dùng.
  * **OpenRouter (Chuyên gia kỹ thuật - Worker Pool)**: Mọi tác vụ tư duy, giải quyết vấn đề, sinh mã nguồn, phân tích lỗi và dịch thuật BẮT BUỘC phải chuyển qua OpenRouter thông qua công cụ `D:\VibeCode\Tools\openrouter_dispatcher.py`. Antigravity không tự sinh các khối code hay xử lý chuyên môn trực tiếp mà luôn nhờ OpenRouter xử lý trước.
- **Ma trận định tuyến model tự động**:
  * **Sinh mã nguồn, C#/Unity, Shaders, refactor kiến trúc**: Ủy quyền cho **Claude Sonnet 5.5** (`--type code` hoặc `--model anthropic/claude-sonnet-5.5`).
  * **Suy luận logic nặng, thuật toán, giải toán, bắt bug khó, reverse-engineering**: Ủy quyền cho **DeepSeek R1** (`--type reasoning` hoặc `--model deepseek/deepseek-r1-0528`).
  * **Dịch thuật kịch bản Visual Novel (Nhật - Việt), văn phong tự nhiên**: Ủy quyền cho **DeepSeek Chat** (`--type translation` hoặc `--model deepseek/deepseek-chat`).
  * **Trích xuất dữ liệu, JSON, tóm tắt thông tin nhanh**: Ủy quyền cho **Qwen 3.8 Flash** (`--type fast` hoặc `--model qwen/qwen3.8-flash`).
- **Nguyên tắc minh bạch & kiểm duyệt bắt buộc**:
  * Luôn thông báo rõ ràng trước khi gọi: *"Đang ủy quyền cho [Tên Model] trên OpenRouter xử lý [Tên tác vụ]..."*.
  * Luôn kiểm tra, xác thực (Verify & Self-audit) lại kết quả do OpenRouter sinh ra trước khi lưu vào file hoặc áp dụng vào dự án.

## 5. Proactive State Checkpointing & Anti-Poisoning Handoff
> [!IMPORTANT]
> Ngăn ngừa Auto-Compaction Checkpoint làm nhiễm độc bộ lọc an toàn:
- Luôn chủ động ghi và cập nhật tệp `CHECKPOINT.md` tại thư mục gốc của dự án (`D:\VibeCode\<ten_du_an>\CHECKPOINT.md` hoặc `/storage/emulated/0/VibeCode/<ten_du_an>/CHECKPOINT.md`).
- Sử dụng thuật ngữ kỹ thuật sạch (Sanitized Technical Language), tuyệt đối không dùng từ khóa kích hoạt bộ lọc (`aimbot`, `cheat`, `hack`, `bẻ khóa`, `cracked`).
- Mọi phiên chat mới khi mở tại thư mục dự án BẮT BUỘC đọc `CHECKPOINT.md` để tiếp tục ngay công việc đang làm dở mà không cần người dùng giải thích lại.

## 6. Phong cách làm việc tự chủ (Autonomous Execution & Summary)
- Tự chủ thực thi toàn bộ các bước kỹ thuật cần thiết từ đầu đến cuối cho đến khi hoàn thành mục tiêu, không dừng lại hỏi xin xác nhận ở các bước trung gian hiển nhiên.
- Sau khi hoàn thành xong toàn bộ công việc, xuất báo cáo tổng kết chi tiết, mạch lạc và rõ ràng cho người dùng.

## 7. Nguyên tắc Việt hóa Game (Game Localization Policy)
- Khi thực hiện Việt hóa game, chỉ cần lựa chọn 1 ngôn ngữ ít được chú ý/ít dùng (hoặc ngôn ngữ phụ phù hợp) để đè bản dịch tiếng Việt lên, tuyệt đối không cần ép tất cả các ngôn ngữ khác về tiếng Việt.
- Việc này giúp bảo toàn các gói ngôn ngữ gốc (như tiếng Anh/tiếng Trung gốc) cho người chơi khi cần đối chiếu hoặc chuyển đổi lại ngôn ngữ trong game.

## 8. Trực quan hóa tiến độ công việc thời gian thực (Real-time Live Monitor)
- Thay vì chèn các bảng tiến độ dài chiếm diện tích khung chat:
- Toàn bộ trạng thái công việc, % tiến độ, công cụ đang chạy và nhật ký từng bước được **đồng bộ tự động theo thời gian thực (Real-time)** qua Hook vào bảng điều khiển [Live Monitor](file:///D:/VibeCode/antigravity-customizations/dashboard/index.html).
- Người dùng chỉ cần mở trang Dashboard trên trình duyệt (hoặc shortcut ngoài Desktop) để theo dõi tiến độ nhảy trực tiếp từng giây.
- Trong khung chat, Agent chỉ cần thông báo ngắn gọn trạng thái chặng chính hoặc tổng kết sau khi hoàn thành.

## 9. Lập kế hoạch 2 tầng theo từng phiên & Lộ trình trực quan (Two-Level Dynamic Roadmap)
- Khi bắt đầu một dự án mới hoặc một phiên làm việc, Agent **bắt buộc tạo ngay tệp `PLAN.md`** tại thư mục gốc của dự án (`D:\VibeCode\<ten_du_an>\PLAN.md`).
- **Cấu trúc 2 tầng trực quan**:
  * **Tầng 1 (Tổng thể phiên - Macro Phase)**: Các chặng lớn của toàn bộ phiên/dự án (Chặng 1, Chặng 2, Chặng 3...). **Số lượng chặng không bị giới hạn**, phân bổ tối ưu theo quy mô thực tế.
  * **Tầng 2 (Đoạn đang chạy - Current Micro Step)**: Các bước thực thi chi tiết bên trong chặng đang chạy (Bước 3.1, Bước 3.2, Bước 3.3...). Giúp người dùng theo dõi rõ ràng: *Tổng thể đang ở chặng 3, và trong lượt chạy đang ở bước 1 của chặng 3*.
- **Định dạng chuẩn trong `PLAN.md` (Markdown lồng nhau)**:
  ```markdown
  - [x] **Chặng 1: Tên chặng lớn đã hoàn thành**
    - [x] 1.1: Bước chi tiết đã xong
  - [-] **Chặng 2: Tên chặng lớn đang làm**
    - [x] 2.1: Bước chi tiết đã xong
    - [-] 2.2: Bước đang chạy trong lượt này
    - [ ] 2.3: Bước chờ làm tiếp theo
  - [ ] **Chặng 3: Tên chặng lớn tiếp theo**
    - [ ] 3.1: Bước chờ
  ```
- **Đồng bộ thời gian thực**:
  * Mỗi khi bắt đầu hoặc hoàn thành một bước kỹ thuật, Agent phải cập nhật ngay dấu `[x]`, `[-]` trong `PLAN.md`.
  * Bảng điều khiển Live Monitor (`sync_sessions.py`) tự động phân giải cấu trúc 2 tầng này để hiển thị song song 2 bảng theo dõi: **Tiến độ tổng thể phiên** và **Tiến độ lượt chạy chi tiết** trên cả máy tính và điện thoại Xiaomi 15.

## 10. Tiết kiệm ngân sách Token & Kiểm soát đầu ra Terminal (Context Budget & Silent Output Policy)
- **Tuyệt đối không in tràn dữ liệu lớn ra Terminal (Anti-Context Bloat)**:
  * Khi thực thi các lệnh quét tệp, đọc logcat, grep, build log, hoặc phân tích nhị phân: BẮT BUỘC phải giới hạn dòng (`| Select-Object -First 10`, `| Measure-Object`), hoặc chuyển hướng xuất thẳng ra tệp tạm (ví dụ `> $env:TEMP\cmd_output.log` hoặc tệp log trong dự án).
  * Nghiêm cấm in toàn bộ cây thư mục đệ quy (`Get-ChildItem -Recurse`) hay `Get-Content` các file lớn trực tiếp ra màn hình terminal làm phình to context window của phiên chat.
- **Ủy quyền OpenRouter trực tiếp qua tệp (File-to-File Pipeline)**:
  * Khi gọi `openrouter_dispatcher.py` để sinh mã nguồn, viết shader hay dịch thuật: BẮT BUỘC sử dụng tham số `--out <duong_dan_file>` để ghi kết quả trực tiếp vào tệp mã nguồn, tránh in hàng nghìn dòng code/văn bản ra console làm đốt token của Antigravity.
- **Phản hồi súc tích (Concise Summary)**:
  * Trong khung chat, Agent chỉ xuất báo cáo kết quả cốt lõi, đường dẫn tệp đã xử lý và các số liệu chính; tuyệt đối không trích dẫn hoặc copy-paste lại các khối log hay khối code dài nếu không có yêu cầu cụ thể từ người dùng.

## 11. Bản đồ tri thức Graphify tự động (Automated Graphify Knowledge Graph)
- **Tự động áp dụng trên mọi phiên làm việc**:
  * Khi cần tìm hiểu kiến trúc, luồng hàm, quan hệ class/file trong dự án: Nếu có `graphify-out/graph.json` hoặc `graphify-out/wiki/index.md`, BẮT BUỘC tra cứu qua Graphify (`python -m graphify query "<cau_hoi>"` hoặc đọc wiki) thay vì đọc trực tiếp hàng loạt file code làm tràn ngữ cảnh.
  * Với các dự án chưa có bản đồ tri thức: Agent chủ động chạy `python -m graphify update .` (hoặc lệnh `/graphify .`) để xây dựng bản đồ cây AST hoàn toàn miễn phí (không tốn token LLM).
  * Sau khi hoàn tất sửa đổi mã nguồn: Tự động chạy `python -m graphify update .` để đồ thị tri thức luôn cập nhật mới nhất.



