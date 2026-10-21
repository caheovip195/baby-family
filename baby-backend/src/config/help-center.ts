/**
 * SET-11/12 help center catalog (versioned content). Contact details and legal
 * links come from the environment so no placeholder address is shipped.
 */
export const HELP_CENTER_CATALOG = Object.freeze({
  version: 1,
  locales: ['vi', 'en'] as const,
  faqs: [
    {
      id: 'invite-partner',
      category: 'ACCOUNT',
      vi: {
        question: 'Làm sao mời Bố/Mẹ còn lại vào gia đình?',
        answer:
          'Vào Gia đình → Mời bạn đời, gửi mã hoặc đường link. Gia đình được kích hoạt khi cả hai Bố và Mẹ đã tham gia.',
      },
      en: {
        question: 'How do I invite the other parent?',
        answer:
          'Go to Family → Invite partner and share the code or link. The family becomes active once both parents have joined.',
      },
    },
    {
      id: 'relatives-see',
      category: 'PRIVACY',
      vi: {
        question: 'Ông bà và người thân thấy được những gì?',
        answer:
          'Người thân chỉ thấy ký ức đặt “Cả nhà” của các bé được Bố/Mẹ cấp quyền. Papa & Mama Space và ký ức “Bố mẹ” hoặc “Chỉ mình tôi” không bao giờ hiện cho người thân.',
      },
      en: {
        question: 'What can grandparents and relatives see?',
        answer:
          'Relatives only see “Family” memories of the children a parent granted them. Papa & Mama Space and “Parents” or “Only me” memories are never shown to relatives.',
      },
    },
    {
      id: 'trial',
      category: 'BILLING',
      vi: {
        question: 'Dùng thử hoạt động thế nào?',
        answer:
          'Khi cả hai Bố và Mẹ đã tham gia, gia đình được dùng thử theo chính sách hiện hành. Hết hạn mà chưa mua gói, dữ liệu vẫn được giữ và bạn vẫn xem, tải về và xuất được.',
      },
      en: {
        question: 'How does the free trial work?',
        answer:
          'Once both parents have joined, the family gets a trial under the current policy. If it ends without a plan, your data is kept and you can still view, download and export it.',
      },
    },
    {
      id: 'download-originals',
      category: 'MEDIA',
      vi: {
        question: 'Tôi có tải được ảnh gốc về máy không?',
        answer:
          'Có. Mở ký ức → Tải về để lưu ảnh/video gốc, hoặc dùng Cài đặt → Xuất dữ liệu để nhận toàn bộ dữ liệu của gia đình.',
      },
      en: {
        question: 'Can I download my original photos?',
        answer:
          'Yes. Open a memory → Download to save the originals, or use Settings → Export data to get all of your family’s data.',
      },
    },
    {
      id: 'leave-or-delete',
      category: 'ACCOUNT',
      vi: {
        question: 'Xoá tài khoản hoặc xoá gia đình thì sao?',
        answer:
          'Việc xoá được hẹn lịch và bạn có thời gian huỷ. Nên xuất dữ liệu trước khi xoá; sau thời hạn, dữ liệu bị xoá vĩnh viễn.',
      },
      en: {
        question: 'What happens if I delete my account or family?',
        answer:
          'Deletion is scheduled and you have time to cancel. Export your data first; after the grace period it is permanently removed.',
      },
    },
    {
      id: 'report-content',
      category: 'PRIVACY',
      vi: {
        question: 'Tôi báo cáo nội dung không phù hợp thế nào?',
        answer:
          'Chạm “…” trên ký ức hoặc bình luận → Báo cáo. Đội ngũ xem xét theo mức độ nghiêm trọng; nội dung liên quan an toàn trẻ em được ưu tiên.',
      },
      en: {
        question: 'How do I report inappropriate content?',
        answer:
          'Tap “…” on a memory or comment → Report. Our team reviews by severity, and child-safety reports come first.',
      },
    },
  ],
});
