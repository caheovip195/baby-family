import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { CompleteUploadDto } from '../../dto/media/complete-upload.dto';
import type { CreateUploadIntentDto } from '../../dto/media/create-upload-intent.dto';
import type { MediaUrlsDto } from '../../dto/media/media-urls.dto';
import type {
  MediaAssetResponseDto,
  MediaUrlsResponseDto,
  UploadIntentResponseDto,
  UploadPartsResponseDto,
  UploadStatusResponseDto,
} from '../../dto/media/media-response.dto';
import type { UploadPartsDto } from '../../dto/media/upload-parts.dto';
import type { FamilyAccessMode } from './application-access-service.interface';

export const MEDIA_SERVICE = Symbol('MEDIA_SERVICE');
export type MediaViewAccess = Extract<FamilyAccessMode, 'read' | 'download'>;

/** Media upload (spec §10.2) and signed view URLs (spec §10.5). */
export interface IMediaService {
  createUploadIntent(
    actor: AuthPrincipal,
    idempotencyKey: string,
    input: CreateUploadIntentDto,
  ): Promise<UploadIntentResponseDto>;
  signUploadParts(
    actor: AuthPrincipal,
    assetId: string,
    input: UploadPartsDto,
  ): Promise<UploadPartsResponseDto>;
  completeUpload(
    actor: AuthPrincipal,
    assetId: string,
    input: CompleteUploadDto,
  ): Promise<UploadStatusResponseDto>;
  getAsset(
    actor: AuthPrincipal,
    assetId: string,
  ): Promise<MediaAssetResponseDto>;
  /** `access` = `download` keeps signing after the subscription expired (spec §6.5). */
  signViewUrls(
    actor: AuthPrincipal,
    input: MediaUrlsDto,
    access?: MediaViewAccess,
  ): Promise<MediaUrlsResponseDto>;
}
