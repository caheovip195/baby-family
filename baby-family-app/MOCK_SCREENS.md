# Màn hình & dữ liệu mẫu (rebuild 2026-10-08)

Nguồn thiết kế: `../desgin/appdesgin.pen` (chỉ đọc qua Pencil MCP). Nghiệp vụ:
`../docs/01_DAC_TA_NGHIEP_VU_BABY_FAMILY_v3.md`, kỹ thuật `../docs/02_…v3.md`.
Mỗi màn: `lib/page/<general|parent|circle>/<screen>/` → Page (`@RoutePage`) →
Controller (`BaseNotifier`) → Service → Repository → `MockStore`.

## Seed dữ liệu mẫu

| `--dart-define=BABY_FAMILY_DEMO=` | Phiên khi mở app | Nội dung |
|---|---|---|
| `fresh` (mặc định) | Chưa đăng nhập → Welcome | “Nhà Lan” chờ Papa (mã `K7Q29MXA`) + gia đình thiết kế gói Family (mã người thân `B4N0I123` → Bà nội) |
| `active` (`make mock-run`) | Mama Lan → Main shell | Nhà Lan, **gói Family** (gia hạn 08/12/2026, 3,2/200 GB) với Bà nội, Bà ngoại, Ông ngoại; Hana 2 tuổi 4 tháng, Haru 17 tháng 29 ngày (sinh 08/04/2025), thai kỳ Bơ |
| `trial` | Mama Lan → Main shell | Như `active` nhưng đang dùng thử, chưa có người thân (C-07) — biến thể FAM-01 dùng thử |
| `pregnant` | Mama Lan → Main shell | Dùng thử, chỉ có thai kỳ Bơ |
| `circle` | Bà ngoại → CIR-01 | Gói Family, người thân thấy Hana & Haru |
| `expired` | Mama Lan → SUB-07 | Hết dùng thử 06/10/2026 |

`--dart-define=BABY_FAMILY_ACTOR=papa` đăng nhập là Papa Minh (đối chiếu frame
vẽ theo góc nhìn Papa: CARE-01, FAM-01, US-04). “Hôm nay” = **07/10/2026 20:25**
(`kValueDemoToday`, `AppClock`). Fixture: `assets/data/mock/*.json` (sinh từ câu
chuyện Pencil; chữ catalog có vi/en/zh/ja, chữ người dùng nhập giữ nguyên).

## Bảng route

| Mã | Page | Path |
|---|---|---|
| SPL-01 | `SplashPage` | `/` (initial, điều hướng theo phiên) |
| ONB-01 | `WelcomePage` | `/welcome` |
| AUTH-01…04 | `AuthPage`, `AuthPhonePage`, `AuthOtpPage`, `AuthProfilePage` | `/auth`, `/auth/phone`, `/auth/otp`, `/auth/profile` |
| ONB-03 | `OnboardingRolePage` | `/onboarding/role` |
| ONB-06 | `OnboardingFamilyPage` | `/onboarding/family` |
| ONB-07 | `OnboardingInvitePartnerPage` | `/onboarding/invite-partner` |
| ONB-WAIT | `OnboardingWaitingPage` | `/onboarding/waiting` |
| ONB-ACT | `OnboardingActivatedPage` | `/onboarding/activated` |
| ONB-04 | `OnboardingStagePage` | `/onboarding/stage` |
| ONB-05a / 05b | `OnboardingPregnancyPage`, `OnboardingChildPage` | `/onboarding/pregnancy`, `/onboarding/child` |
| ONB-08 / 10 / 09 | `OnboardingPrivacyPage`, `OnboardingNotificationsPage`, `OnboardingFirstMemoryPage` | `/onboarding/privacy`, `/onboarding/notifications`, `/onboarding/first-memory` |
| INV-05 / INV-01 | `InviteCodePage`, `InvitePreviewPage` | `/invite/code`, `/invite/preview?code=` |
| CIR-WAIT / CIR-01 | `CircleWaitingPage`, `CircleHomePage` | `/circle/waiting`, `/circle` |
| Main shell | `MainShellPage` + `HomeTabPage`, `MemoriesTabPage`, `CareTabPage`, `CoupleTabPage` | `/main/home`, `/main/memories`, `/main/care`, `/main/us` |
| MEM-05 | `MemoryComposerPage` | `/memory/new?kind=&childId=` |
| MEM-23 | `MemoryQuotePage` (route trong suốt, trượt từ dưới) | `/memory/quote?childId=` |
| MEM-07 / MEM-24 | `MemoryDetailPage`, `MemoryPerspectivePage` | `/memory/:memoryId`, `/memory/:memoryId/perspective` |
| MEM-25 | `MemoryStoryPage` | `/story/:childId` |
| MEM-20 / 21 | `MonthlyPhotosPage`, `MonthlyCameraPage` | `/monthly/:childId`, `/monthly/:childId/camera?month=` |
| MEM-12 | `FirstsPage` | `/firsts/:childId` |
| MEM-22 | `CollectionDetailPage` | `/collections/:code` |
| CARE-03 / 04 / 09 / 02 | `MissionCreatePage`, `MissionLibraryPage`, `FamilyTreePage`, `MissionDetailPage` | `/care/new?childId=&templateId=`, `/care/library`, `/care/tree`, `/care/mission/:missionId` |
| US-03 / US-04 / US-05 | `RequestComposePage`, `RequestDetailPage`, `ThanksComposePage` | `/us/request/new?title=`, `/us/request/:requestId`, `/us/thanks/new?missionId=` |
| FAM-01 / 03 | `FamilyPage`, `RelativeInvitePage` | `/family`, `/family/invite` |
| SUB-01 / 07 | `PlansPage`, `ExpiredPage` | `/billing/plans`, `/billing/expired` |
| SET-01 / 06 | `SettingsPage`, `DisplaySettingsPage` | `/settings`, `/settings/display` |
| NOTI-01 | `NotificationsPage` | `/notifications` |
| PREG-01…04 | `PregnancyJourneyPage` | `/pregnancy/:pregnancyId?tab=timeline|bump|ultrasound|prep` |
| PREG-05 / 06 / 07 | `BirthPage`, `PregnancyArchivePage`, `BabyNamesPage` | `/pregnancy/:pregnancyId/birth`, `/archive`, `/names` |

Sheet (không phải route): SW-01 `showChildSwitcherSheet`, QC-01
`showQuickCreateSheet`; CARE-05/06, US-02 do agent khu vực viết bằng
`showAppBottomSheet(strongScrim: true)`. Trạng thái: `EmptyState`, `ErrorState`,
`MemoryListSkeleton`, `OfflineBanner`.

## Luồng mặc định (đi xuyên qua, không chặn)

Splash → Welcome → AUTH-01 → (Apple/Google) AUTH-04 hoặc (SĐT) AUTH-02 → AUTH-03
→ AUTH-04 → ONB-03 → ONB-06 → ONB-07 → ONB-WAIT (“Giả lập: bạn đời đã tham gia”)
→ ONB-ACT → ONB-04 → ONB-05a/b → ONB-08 → ONB-10 → ONB-09 → Main shell.
Welcome “Tôi đã có mã mời” → INV-05 → INV-01 → (chưa đăng nhập) AUTH… → bạn đời:
ONB-ACT / người thân: CIR-01. Không có `AutoRouteGuard`; Splash và các bước
dùng `routeForSession(session)`.

Màn cũ (`?screen=`) nằm ở `lib/page/**/legacy_*` (không còn đăng ký route) để
tham khảo; xoá khi các màn mới hoàn tất.

## Batch 2 (2026-10-10) — 32 route mới

| Mã | Page | Path |
|---|---|---|
| MEM-03 / 03a | `AlbumsPage`, `AlbumDetailPage` | `/albums`, `/albums/:albumId` |
| MEM-08 / MEM-10 | `PhotoViewerPage`, `MemoryCommentsPage` | `/memory/:memoryId/photos?index=`, `/memory/:memoryId/comments` |
| MEM-11 | `MilestonePickerPage` | `/milestones/pick?childId=` |
| MEM-13 / MEM-14 | `DiaryEditorPage`, `LetterComposerPage` | `/memory/diary?childId=`, `/memory/letter?childId=` |
| MEM-15 / MEM-16 / REC-02 | `MemorySearchPage`, `OnThisDayPage`, `WeeklyRecapPage` | `/search`, `/on-this-day`, `/recap/week` |
| CARE-07 / CAL-02 | `CalendarPage`, `EventCreatePage` | `/calendar`, `/calendar/event/new` |
| CARE-08 / 10 / 12 | `MissionHistoryPage`, `BadgesPage`, `MissionSettingsPage` | `/care/history`, `/care/badges`, `/care/settings` |
| US-06 / 07 / 15 | `ThanksWallPage`, `PrivateJournalPage`, `CoupleSettingsPage` | `/us/thanks`, `/us/journal`, `/us/settings` |
| CHD-01…04 | `ChildProfilePage`, `ChildEditPage`, `ChildrenPage`, `ChildAddPage` | `/child/:childId`, `/child/:childId/edit`, `/children`, `/children/new` |
| FAM-04 / FAM-07 | `RelativeDetailPage`, `FamilySettingsPage` | `/family/relative/:memberId`, `/family/settings` |
| SET-02/03/04/07/08 | `ProfileSettingsPage`, `NotificationSettingsPage`, `PrivacySettingsPage`, `SecuritySettingsPage`, `MyDataPage` | `/settings/profile`, `/settings/notifications`, `/settings/privacy`, `/settings/security`, `/settings/data` |
| SET-09/09b/09c / 11 / 12 | `DeleteAccountPage` (nhiều bước), `HelpPage`, `AboutPage` | `/settings/delete-account`, `/settings/help`, `/settings/about` |

