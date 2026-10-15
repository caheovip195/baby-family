import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Inject,
  Param,
  ParseUUIDPipe,
  Post,
  UseGuards,
} from '@nestjs/common';
import {
  ApiAcceptedResponse,
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiHeader,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { IdempotencyKey } from '../common/http/idempotency-key.decorator';
import { CompleteUploadDto } from '../dto/media/complete-upload.dto';
import { CreateUploadIntentDto } from '../dto/media/create-upload-intent.dto';
import { MediaUrlsDto } from '../dto/media/media-urls.dto';
import {
  MediaAssetResponseDto,
  MediaUrlsResponseDto,
  UploadIntentResponseDto,
  UploadPartsResponseDto,
  UploadStatusResponseDto,
} from '../dto/media/media-response.dto';
import { UploadPartsDto } from '../dto/media/upload-parts.dto';
import { MEDIA_SERVICE } from '../interfaces/services/media-service.interface';
import type { IMediaService } from '../interfaces/services/media-service.interface';

@ApiTags('Media')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('media')
export class MediaController {
  constructor(@Inject(MEDIA_SERVICE) private readonly service: IMediaService) {}

  @Post('upload-intents')
  @ApiHeader({
    name: 'Idempotency-Key',
    required: true,
    description: 'UUID; replaying the same request returns the same intent.',
  })
  @ApiCreatedResponse({ type: UploadIntentResponseDto })
  createUploadIntent(
    @CurrentActor() actor: AuthPrincipal,
    @IdempotencyKey() idempotencyKey: string,
    @Body() input: CreateUploadIntentDto,
  ) {
    return this.service.createUploadIntent(actor, idempotencyKey, input);
  }

  @Post('urls')
  @HttpCode(HttpStatus.OK)
  @ApiOkResponse({ type: MediaUrlsResponseDto })
  signViewUrls(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: MediaUrlsDto,
  ) {
    return this.service.signViewUrls(actor, input);
  }

  @Post(':id/parts')
  @HttpCode(HttpStatus.OK)
  @ApiOkResponse({ type: UploadPartsResponseDto })
  signUploadParts(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: UploadPartsDto,
  ) {
    return this.service.signUploadParts(actor, id, input);
  }

  @Post(':id/complete')
  @HttpCode(HttpStatus.ACCEPTED)
  @ApiAcceptedResponse({ type: UploadStatusResponseDto })
  completeUpload(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: CompleteUploadDto,
  ) {
    return this.service.completeUpload(actor, id, input);
  }

  @Get(':id')
  @ApiOkResponse({ type: MediaAssetResponseDto })
  getAsset(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.getAsset(actor, id);
  }
}
