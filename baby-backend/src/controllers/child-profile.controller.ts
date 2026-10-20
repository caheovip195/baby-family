import {
  Body,
  Controller,
  Delete,
  Get,
  Inject,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Put,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  ChildProfileAssetDto,
  ChildProfileDeleteDto,
  ChildProfileOrderDto,
} from '../dto/child/child-profile.dto';
import { CHILD_PROFILE_SERVICE } from '../interfaces/services/child-profile-service.interface';
import type { IChildProfileService } from '../interfaces/services/child-profile-service.interface';
@ApiTags('Child profile')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller()
export class ChildProfileController {
  constructor(
    @Inject(CHILD_PROFILE_SERVICE)
    private readonly service: IChildProfileService,
  ) {}
  @Patch('families/:fid/children/order')
  order(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', new ParseUUIDPipe()) fid: string,
    @Body() body: ChildProfileOrderDto,
  ) {
    return this.service.reorder(actor, fid, body.childIds);
  }
  @Get('children/:id/profile-stats')
  stats(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.stats(actor, id);
  }
  @Post('children/:id/archive')
  archive(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.transition(actor, id, 'archive');
  }
  @Post('children/:id/restore')
  restore(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.transition(actor, id, 'restore');
  }
  @Delete('children/:id')
  delete(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() body: ChildProfileDeleteDto,
  ) {
    return this.service.transition(actor, id, 'delete', body.confirmName);
  }
  @Put('children/:id/avatar')
  avatar(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() body: ChildProfileAssetDto,
  ) {
    return this.service.childAsset(actor, id, 'avatarAssetId', body.assetId);
  }
  @Put('children/:id/cover')
  cover(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() body: ChildProfileAssetDto,
  ) {
    return this.service.childAsset(actor, id, 'coverAssetId', body.assetId);
  }
  @Put('pregnancies/:id/cover')
  pregnancyCover(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() body: ChildProfileAssetDto,
  ) {
    return this.service.pregnancyCover(actor, id, body.assetId);
  }
}
