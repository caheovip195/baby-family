/**
 * Câu hỏi kết nối (US-01 khối 3, BF-20261027-002): catalog có version, mỗi câu
 * theo từng ngôn ngữ (thiếu ngôn ngữ thì app dùng `vi`). Mã câu hỏi được lưu
 * cùng câu trả lời, nên không đổi/xoá mã đã phát hành — thêm câu mới bằng mã
 * mới và tăng `version`. Nội dung về sau do Admin quản lý (ADM-08).
 */
export const COUPLE_QUESTION_CATALOG = {
  version: 1,
  questions: [
    {
      code: 'small_smile_today',
      text: {
        vi: 'Điều nhỏ nào hôm nay làm bạn mỉm cười?',
        en: 'What small thing made you smile today?',
      },
    },
    {
      code: 'support_this_week',
      text: {
        vi: 'Tuần này bạn cần mình hỗ trợ việc gì nhất?',
        en: 'What do you most need my help with this week?',
      },
    },
    {
      code: 'remember_before_baby',
      text: {
        vi: 'Bạn nhớ nhất điều gì về hai ta trước khi có con?',
        en: 'What do you miss most about us before the baby?',
      },
    },
    {
      code: 'proud_of_us',
      text: {
        vi: 'Gần đây điều gì khiến bạn tự hào về hai ta?',
        en: 'What recently made you proud of us?',
      },
    },
    {
      code: 'rest_wish',
      text: {
        vi: 'Nếu có một giờ rảnh, bạn muốn làm gì nhất?',
        en: 'If you had one free hour, what would you most like to do?',
      },
    },
    {
      code: 'thank_you_moment',
      text: {
        vi: 'Khoảnh khắc nào gần đây bạn muốn cảm ơn mình?',
        en: 'Which recent moment would you like to thank me for?',
      },
    },
    {
      code: 'child_moment',
      text: {
        vi: 'Khoảnh khắc nào của con hôm nay bạn muốn nhớ mãi?',
        en: 'Which moment with our child today do you want to remember?',
      },
    },
    {
      code: 'little_date',
      text: {
        vi: 'Một buổi hẹn nhỏ của hai ta tuần này sẽ là gì?',
        en: 'What would a small date for the two of us look like this week?',
      },
    },
    {
      code: 'feeling_heard',
      text: {
        vi: 'Mình có thể làm gì để bạn thấy được lắng nghe hơn?',
        en: 'What can I do so you feel more heard?',
      },
    },
    {
      code: 'tiny_tradition',
      text: {
        vi: 'Thói quen nhỏ nào bạn muốn nhà mình giữ mãi?',
        en: 'Which small habit would you like our family to keep forever?',
      },
    },
  ],
} as const;

export const COUPLE_QUESTION_POLICY = {
  /** Độ dài câu trả lời tối đa (ký tự). */
  answerMaxLength: 500,
  /** US-14: số nhiệm vụ cùng nhau liệt kê tối đa trong tuần. */
  weekTogetherLimit: 10,
  /** US-14: xem lại tối đa bao nhiêu ngày trước (tuần đầu tiên hợp lệ). */
  weekMaxLookbackDays: 365,
} as const;

export type CoupleQuestion = (typeof COUPLE_QUESTION_CATALOG.questions)[number];
