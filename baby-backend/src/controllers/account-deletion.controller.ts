import {
  Body,
  Controller,
  Get,
  HttpCode,
  Inject,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  CancelAccountDeletionDto,
  RequestAccountDeletionDto,
} from '../dto/account/account-deletion.dto';
import { ACCOUNT_DELETION_SERVICE } from '../interfaces/services/account-deletion-service.interface';
import type { IAccountDeletionService } from '../interfaces/services/account-deletion-service.interface';

@ApiTags('Account deletion')
@Controller('me')
export class AccountDeletionController {
  constructor(
    @Inject(ACCOUNT_DELETION_SERVICE)
    private readonly service: IAccountDeletionService,
  ) {}

  @Get('deletion-preview')
  @ApiBearerAuth()
  @UseGuards(AccessTokenGuard)
  preview(@CurrentActor() actor: AuthPrincipal) {
    return this.service.preview(actor);
  }

  @Post('deletion')
  @HttpCode(202)
  @ApiBearerAuth()
  @UseGuards(AccessTokenGuard)
  request(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: RequestAccountDeletionDto,
  ) {
    return this.service.request(actor, input);
  }

  /** Pending accounts have no live sessions. A fresh, scoped reauth JWT authenticates recovery. */
  @Post('deletion/cancel')
  @HttpCode(200)
  cancel(@Body() input: CancelAccountDeletionDto) {
    return this.service.cancel(input.reauthToken);
  }
}
