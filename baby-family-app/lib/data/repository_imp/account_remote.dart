import 'package:baby_family/data/model/account/data_export_record.dart';
import 'package:baby_family/data/model/account/deletion_preview_record.dart';
import 'package:baby_family/data/model/account/reauth_token_record.dart';
import 'package:baby_family/data/model/account/session_record.dart';
import 'package:baby_family/data/model/memory/upload_intent.dart';
import 'package:baby_family/data/model/privacy/family_deletion_record.dart';
import 'package:baby_family/data/model/privacy/privacy_overview_record.dart';
import 'package:baby_family/data/model/safety/blocked_user_record.dart';
import 'package:baby_family/data/model/settings/ai_settings_record.dart';
import 'package:baby_family/data/model/settings/help_center_record.dart';
import 'package:baby_family/data/model/settings/notification_settings_record.dart';
import 'package:baby_family/data/model/settings/sign_in_method_record.dart';
import 'package:baby_family/data/model/settings/support_ticket.dart';
import 'package:baby_family/data/model/settings/support_ticket_detail.dart';
import 'package:baby_family/data/repository/account_remote.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository_imp/base.dart';

class AccountRemoteRepositoryImp extends BaseRepositoryImp
    implements IAccountRemoteRepository {
  @override
  Future<void> requestReauthOtp() => client!.requestReauthOtp();

  @override
  Future<ReauthTokenRecord?> verifyReauthOtp(String code) async {
    final rs = await client!.verifyReauthOtp({'code': code});
    return rs.token;
  }

  @override
  Future<DeletionPreviewRecord?> deletionPreview() async {
    final rs = await client!.getDeletionPreview();
    return rs.preview;
  }

  @override
  Future<void> requestDeletion({
    required String familyChoice,
    required String sharedContentChoice,
    required String reauthToken,
  }) => client!.requestAccountDeletion({
    'familyChoice': familyChoice,
    'sharedContentChoice': sharedContentChoice,
    'reauthToken': reauthToken,
  });

  @override
  Future<DataExportRecord?> createExport(
    String scope, {
    String? familyId,
  }) async {
    final rs = await client!.createExport({
      'scope': scope,
      'familyId': ?familyId,
    });
    return rs.export;
  }

  @override
  Future<DataExportRecord?> export(String exportId) async {
    final rs = await client!.getExport(exportId);
    return rs.export;
  }

  @override
  Future<List<SessionRecord>> sessions() async {
    final rs = await client!.getSessions();
    return rs.list?.items ?? const [];
  }

  @override
  Future<void> revokeSession(String sessionId) =>
      client!.revokeSession(sessionId);

  @override
  Future<void> revokeOtherSessions() => client!.revokeOtherSessions();

  @override
  Future<void> updateMe(JsonMap patch) async {
    await client!.updateMe(patch);
  }

  @override
  Future<NotificationSettingsRecord?> notificationSettings() async =>
      (await client!.getNotificationSettings()).settings;

  @override
  Future<NotificationSettingsRecord?> updateNotificationSettings(
    JsonMap patch,
  ) async => (await client!.updateNotificationSettings(patch)).settings;

  @override
  Future<AiSettingsRecord?> aiSettings() async =>
      (await client!.getAiSettings()).settings;

  @override
  Future<AiSettingsRecord?> updateAiSettings(JsonMap patch) async =>
      (await client!.updateAiSettings(patch)).settings;

  @override
  Future<void> block(String familyId, String userId) =>
      client!.blockUser({'familyId': familyId, 'userId': userId});

  @override
  Future<void> unblock(String familyId, String userId) =>
      client!.unblockUser(userId, familyId);

  @override
  Future<List<BlockedUserRecord>> blocks(String familyId) async =>
      (await client!.getBlocks(familyId)).list?.items ?? const [];

  @override
  Future<UploadIntent?> createAvatarIntent(
    String idempotencyKey,
    JsonMap body,
  ) async =>
      (await client!.createAvatarUploadIntent(idempotencyKey, body)).intent;

  @override
  Future<void> completeAvatar(String assetId) async {
    await client!.completeAvatarUpload(assetId, const {});
  }

  @override
  Future<FamilyDeletionRecord?> familyDeletion(String familyId) async =>
      (await client!.getFamilyDeletion(familyId)).deletion;

  @override
  Future<FamilyDeletionRecord?> requestFamilyDeletion(
    String familyId,
    String reauthToken,
  ) async => (await client!.requestFamilyDeletion(familyId, {
    'reauthToken': reauthToken,
  })).deletion;

  @override
  Future<FamilyDeletionRecord?> confirmFamilyDeletion(
    String familyId,
    String reauthToken,
  ) async => (await client!.familyDeletionAction(familyId, 'confirm', {
    'reauthToken': reauthToken,
  })).deletion;

  @override
  Future<FamilyDeletionRecord?> cancelFamilyDeletion(String familyId) async =>
      (await client!.familyDeletionAction(
        familyId,
        'cancel',
        const {},
      )).deletion;

  @override
  Future<void> requestPhoneChangeOtp(String phone, String reauthToken) =>
      client!.requestPhoneChangeOtp({
        'phone': phone,
        'reauthToken': reauthToken,
      });

  @override
  Future<void> verifyPhoneChange(String phone, String code) =>
      client!.verifyPhoneChange({'phone': phone, 'code': code});

  @override
  Future<List<SignInMethodRecord>> signInMethods() async =>
      (await client!.getSignInMethods()).methods;

  @override
  Future<HelpCenterRecord?> helpCenter(String locale) async =>
      (await client!.getHelpCenter(locale)).helpCenter;

  @override
  Future<List<String>> supportCategories() async =>
      (await client!.getSupportCategories()).catalog?.categories ?? const [];

  @override
  Future<SupportTicket?> createSupportTicket(JsonMap body) async =>
      (await client!.createSupportTicket(body)).ticket;

  @override
  Future<SupportTicketDetail?> supportTicket(String ticketId) async =>
      (await client!.getSupportTicket(ticketId)).ticket;

  @override
  Future<void> sendSupportMessage(String ticketId, String body) =>
      client!.sendSupportMessage(ticketId, {'body': body});

  @override
  Future<List<SupportTicket>> supportTickets({int limit = 50}) async =>
      (await client!.getMySupportTickets(0, limit)).list?.items ?? const [];

  @override
  Future<PrivacyOverviewRecord?> privacyOverview(String familyId) async =>
      (await client!.getPrivacyOverview(familyId)).overview;

  @override
  Future<void> updateFamilySettings(String familyId, JsonMap patch) async {
    await client!.updateFamilySettings(familyId, patch);
  }
}
