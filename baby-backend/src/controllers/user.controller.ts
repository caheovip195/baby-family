import {
  Body,
  Controller,
  Get,
  Inject,
  Patch,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { UpdateUserDto } from '../dto/user/update-user.dto';
import { UserResponseDto } from '../dto/user/user-response.dto';
import { USER_SERVICE } from '../interfaces/services/user-service.interface';
import type { IUserService } from '../interfaces/services/user-service.interface';

@ApiTags('User')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('me')
export class UserController {
  constructor(@Inject(USER_SERVICE) private readonly service: IUserService) {}

  @Get()
  @ApiOkResponse({ type: UserResponseDto })
  getMe(@CurrentActor() actor: AuthPrincipal) {
    return this.service.getMe(actor);
  }

  @Patch()
  @ApiOkResponse({ type: UserResponseDto })
  updateMe(@CurrentActor() actor: AuthPrincipal, @Body() input: UpdateUserDto) {
    return this.service.updateMe(actor, input);
  }
}
