# Graph Report - Imouto_VietHoa  (2026-11-08)

## Corpus Check
- 22 files · ~35,394 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 82 file(s) not represented in the graph (top: .shader 79, (none) 2, .bat 1)
- WARNING: 82 of 105 files seen (78%) have no supported extractor and are missing from this graph entirely. It may look complete while representing only part of the codebase.

## Summary
- 211 nodes · 376 edges · 19 communities (6 shown, 13 thin omitted)
- Extraction: 94% EXTRACTED · 6% INFERRED · 0% AMBIGUOUS · INFERRED: 23 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `3b65a96f`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SceneMaster
- SceneMaster.DismissLoadingUI
- TranslationHook
- TMProLocalize
- StartupInitializer.cs
- TranslationHook
- Source/ImoutoVi.cs
- Quy tắc lưu trữ và quản lý thư mục dự án (Global - All Projects & Chats)
- Dự Án Bản Địa Hóa Tiếng Việt: 妹と過ごす1ヵ月間_Re (One Month with My Sister _Re)
- CameraFixedAspect
- 2. Trạng thái & Kết quả kỹ thuật đã đạt được
- Technical Checkpoint - Môi Trường Giả Lập & ADB Testing
- PLAN.md

## God Nodes (most connected - your core abstractions)
1. `SceneMaster` - 23 edges
2. `TranslationHook` - 20 edges
3. `TranslationHook` - 20 edges
4. `TMProLocalize` - 12 edges
5. `Quy tắc lưu trữ và quản lý thư mục dự án (Global - All Projects & Chats)` - 12 edges
6. `TableName` - 11 edges
7. `SceneManager` - 10 edges
8. `SceneManager` - 10 edges
9. `CameraFixedAspect` - 7 edges
10. `StartupInitializer` - 6 edges

## Surprising Connections (you probably didn't know these)
- `SceneManager` --inherits--> `SceneMaster`  [EXTRACTED]
  Source/Patches/SceneManager.cs → Source/Patches/SceneMaster.cs
- `SceneManager` --inherits--> `SceneMaster`  [EXTRACTED]
  Source/Patches/TitleSceneManager.cs → Source/Patches/SceneMaster.cs

## Import Cycles
- None detected.

## Communities (19 total, 13 thin omitted)

### Community 0 - "SceneMaster"
Cohesion: 0.17
Nodes (3): SceneManager, SceneMaster, SceneManager

### Community 3 - "TMProLocalize"
Cohesion: 0.12
Nodes (13): TableName, BonusLocalization, GalleryLocalization, HSelectLocalization, InteractionLocalization, MainLocalization, PublicLocalization, SexSceneLocalization (+5 more)

### Community 7 - "Quy tắc lưu trữ và quản lý thư mục dự án (Global - All Projects & Chats)"
Cohesion: 0.15
Nodes (12): 10. Tiết kiệm ngân sách Token & Kiểm soát đầu ra Terminal (Context Budget & Silent Output Policy), 11. Bản đồ tri thức Graphify tự động (Automated Graphify Knowledge Graph), 1. Đường dẫn gốc (Root Path), 2. Kiểm tra trùng lặp trước khi thao tác (Anti-duplicate), 3. Nguyên tắc xử lý thư mục, 4. Cơ chế ủy quyền toàn diện OpenRouter (Full Autonomous OpenRouter Delegation), 5. Proactive State Checkpointing & Anti-Poisoning Handoff, 6. Phong cách làm việc tự chủ (Autonomous Execution & Summary) (+4 more)

### Community 8 - "Dự Án Bản Địa Hóa Tiếng Việt: 妹と過ごす1ヵ月間_Re (One Month with My Sister _Re)"
Cohesion: 0.20
Nodes (9): 📖 1. Giới Thiệu Dự Án, 🚀 2. Điểm Nhấn Kỹ Thuật, 📥 3. Hướng Dẫn Cài Đặt, 📁 4. Cấu Trúc Thư Mục Mã Nguồn, 📜 5. Tuyên Bố Miễn Trừ Trách Nhiệm (Disclaimer), Cách 1: Cài đặt bản Native APK (Dành cho Android), Cách 2: Cài đặt bản Patch cho Máy tính (Windows PC), Dự Án Bản Địa Hóa Tiếng Việt: 妹と過ごす1ヵ月間_Re (One Month with My Sister _Re) (+1 more)

### Community 10 - "2. Trạng thái & Kết quả kỹ thuật đã đạt được"
Cohesion: 0.25
Nodes (7): 1. Thông tin phiên làm việc, 2. Trạng thái & Kết quả kỹ thuật đã đạt được, 3. Các tác vụ cần làm tiếp theo ở phiên mới, CHECKPOINT: Khắc phục lỗi chuyển cảnh & Render Native Android - Imouto_VietHoa, Lỗi 2: Bấm Chơi từ đầu bị đen màn (ĐÃ GIẢI PHÓNG MÀN ĐEN THÀNH CÔNG), Lỗi 3: Bóng thoại trắng khổng lồ che kín màn hình khi phát lại cảnh thư viện (ĐÃ SỬA MÃ NGUỒN), Trạng thái tích hợp OpenRouter Dispatcher

### Community 12 - "Technical Checkpoint - Môi Trường Giả Lập & ADB Testing"
Cohesion: 0.50
Nodes (3): 1. Thông Tin Công Cụ Đã Cài Đặt, 2. Thông Số Kết Nối & Lệnh Tự Động Hóa, Technical Checkpoint - Môi Trường Giả Lập & ADB Testing

## Knowledge Gaps
- **11 isolated node(s):** `PublicLocalization`, `TitleLocalization`, `MainLocalization`, `ShopLocalization`, `InteractionLocalization` (+6 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 69 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **13 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `SceneMaster` connect `SceneMaster` to `SceneMaster.DismissLoadingUI`, `StartupInitializer.cs`, `CameraFixedAspect`?**
  _High betweenness centrality (0.241) - this node is a cross-community bridge._
- **What connects `PublicLocalization`, `TitleLocalization`, `MainLocalization` to the rest of the system?**
  _11 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `TranslationHook` be split into smaller, more focused modules?**
  _Cohesion score 0.14855072463768115 - nodes in this community are weakly interconnected._
- **Why does `TMProLocalize` connect `TMProLocalize` to `CameraFixedAspect`, `StartupInitializer.cs`?**
  _High betweenness centrality (0.137) - this node is a cross-community bridge._
- **Should `TMProLocalize` be split into smaller, more focused modules?**
  _Cohesion score 0.12380952380952381 - nodes in this community are weakly interconnected._
- **Why does `TranslationHook` connect `TranslationHook` to `Source/ImoutoVi.cs`?**
  _High betweenness centrality (0.130) - this node is a cross-community bridge._