import {
  Body,
  Controller,
  HttpCode,
  Inject,
  Param,
  ParseUUIDPipe,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiHeader, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { IdempotencyKey } from '../common/http/idempotency-key.decorator';
import { AvatarUploadIntentDto } from '../dto/user/avatar-upload.dto';
import {
  PROFILE_IMAGE_SERVICE,
  type IProfileImageService,
} from '../interfaces/services/profile-image-service.interface';

@ApiTags('User')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('me/avatar')
export class ProfileImageController {
  constructor(
    @Inject(PROFILE_IMAGE_SERVICE)
    private readonly service: IProfileImageService,
  ) {}
  @Post('upload-intents')
  @ApiHeader({ name: 'Idempotency-Key', required: true })
  intent(
    @CurrentActor() actor: AuthPrincipal,
    @IdempotencyKey() key: string,
    @Body() input: AvatarUploadIntentDto,
  ) {
    return this.service.createIntent(actor, key, input);
  }
  @Post(':id/complete')
  @HttpCode(200)
  complete(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.complete(actor, id);
  }
}
