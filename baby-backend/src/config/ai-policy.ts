/**
 * AI 1.2 (đặc tả 7.18, BF-20261028-010). AI chỉ chạy khi người dùng bấm,
 * mọi đầu ra là bản nháp; không lưu prompt / nội dung, chỉ metadata lượt gọi.
 */
export const AI_POLICY = {
  /** Phiên bản prompt ghi vào `ops.ai_invocations` (đổi prompt → tăng). */
  promptVersion: 'v1',
  /** Văn bản đồng ý (UserConsent.document) theo tính năng. */
  consentDocument: (feature: AiFeature) => `ai.${feature}`,
  consentVersion: 'v1',
  /** Giữ chỗ hạn mức khi đang gọi nhà cung cấp. */
  reservationMs: 2 * 60 * 1000,
  captionHintMaxLength: 200,
  rewriteMaxLength: 500,
  dayStoryMaxMemories: 20,
  /** Model miễn phí của router hay "suy nghĩ" trước khi trả lời: chừa đủ token. */
  maxOutputTokens: 1500,
  /** Số lần gọi tối đa trong một lượt (lần sau khi trả rỗng / sai định dạng). */
  attempts: 2,
  /** Gợi ý nhiệm vụ: số mẫu gửi cho AI chọn, số gợi ý trả về, cửa sổ lịch sử. */
  missionCandidates: 40,
  missionPicks: { min: 3, max: 5 },
  missionHistoryDays: 14,
} as const;

/** Mã tính năng khớp cài đặt AI của người dùng (SET-05). */
export const AI_FEATURES = [
  'caption',
  'dailyStory',
  'gentleRewrite',
  'bridgeSummary',
  'missionSuggest',
] as const;
export type AiFeature = (typeof AI_FEATURES)[number];

const RULES = `Quy tắc bắt buộc: chỉ dùng thông tin người dùng đưa; không bịa sự kiện, tên, địa điểm; không chẩn đoán bệnh hay tâm lý; không tư vấn y khoa; không kết luận ai đúng ai sai; không chấm điểm mối quan hệ; giọng ấm áp, tôn trọng; luôn trả lời bằng tiếng Việt, trừ khi nội dung người dùng viết bằng ngôn ngữ khác thì dùng đúng ngôn ngữ đó.`;

/** Prompt hệ thống theo tính năng; người dùng luôn xem và sửa trước khi dùng. */
export const AI_PROMPTS: Record<AiFeature, string> = {
  caption: `Bạn gợi ý chú thích ngắn cho một kỷ niệm gia đình về em bé. ${RULES} Trả về đúng JSON {"suggestions":["...","...","..."]} gồm 3 chú thích khác nhau, mỗi câu tối đa 120 ký tự.`,
  dailyStory: `Bạn viết "Câu chuyện ngày" cho cha mẹ từ danh sách khoảnh khắc trong một ngày của bé. ${RULES} Viết 3–6 câu, ngôi thứ ba hoặc như lời cha mẹ kể. Trả về đúng JSON {"story":"..."}.`,
  gentleRewrite: `Bạn giúp viết lại một câu cha/mẹ muốn gửi bạn đời cho nhẹ nhàng, nói về cảm xúc và nhu cầu của chính mình, không trách móc. ${RULES} Giữ nguyên ý. Trả về đúng JSON {"neutral":"...","warm":"...","short":"..."} (trung tính, ấm áp, ngắn gọn).`,
  missionSuggest: `Bạn giúp cha mẹ chọn vài việc nhỏ trong ngày cho bé và gia đình từ DANH SÁCH CÓ SẴN (mỗi dòng có số thứ tự). ${RULES} Chỉ chọn số thứ tự có trong danh sách, không tạo việc mới; ưu tiên nhóm việc ít làm trong 14 ngày qua để cân bằng, không chọn trùng. Lý do mỗi việc tối đa 80 ký tự, ấm áp, không so sánh ai làm nhiều hơn. Trả về đúng JSON {"picks":[{"index":1,"reason":"..."}]} gồm 3 đến 5 việc.`,
  bridgeSummary: `Bạn tóm tắt trung lập những gì hai bạn đời đã chọn chia sẻ trong một cuộc trò chuyện bình tĩnh, giúp hai người hiểu nhau. ${RULES} Không phán xét, không đưa lời khuyên trị liệu. 3–5 câu. Trả về đúng JSON {"summary":"..."}.`,
};

/**
 * Từ khoá nhánh an toàn (7.17.3, [1.1]): có dấu hiệu sợ hãi / đe doạ / bạo
 * lực thì KHÔNG gửi cho AI và app chuyển sang màn hỗ trợ an toàn.
 */
export const AI_SAFETY_KEYWORDS = [
  'đánh tôi',
  'đánh em',
  'đánh con',
  'bạo lực',
  'đe doạ',
  'đe dọa',
  'giết',
  'sợ anh',
  'sợ chồng',
  'sợ vợ',
  'không an toàn',
  'tự tử',
  'tự sát',
  'hit me',
  'kill',
  'unsafe',
  'threaten',
] as const;
