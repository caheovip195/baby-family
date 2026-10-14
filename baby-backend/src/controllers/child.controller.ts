import {
  Body,
  Controller,
  Get,
  Inject,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { PaginationQueryDto } from '../dto/common/pagination-query.dto';
import { CreateChildDto } from '../dto/child/create-child.dto';
import { UpdateChildDto } from '../dto/child/update-child.dto';
import {
  ChildResponseDto,
  ChildPageDto,
} from '../dto/child/child-response.dto';
import { CHILD_SERVICE } from '../interfaces/services/child-service.interface';
import type { IChildService } from '../interfaces/services/child-service.interface';

@ApiTags('Child')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId/children')
export class ChildController {
  constructor(@Inject(CHILD_SERVICE) private readonly service: IChildService) {}

  @Get()
  @ApiOkResponse({ type: ChildPageDto })
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Query() query: PaginationQueryDto,
  ) {
    return this.service.list(actor, familyId, query);
  }

  @Get(':id')
  @ApiOkResponse({ type: ChildResponseDto })
  getById(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.getById(actor, familyId, id);
  }

  @Post()
  @ApiCreatedResponse({ type: ChildResponseDto })
  create(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Body() input: CreateChildDto,
  ) {
    return this.service.create(actor, familyId, input);
  }

  @Patch(':id')
  @ApiOkResponse({ type: ChildResponseDto })
  update(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: UpdateChildDto,
  ) {
    return this.service.update(actor, familyId, id, input);
  }
}
