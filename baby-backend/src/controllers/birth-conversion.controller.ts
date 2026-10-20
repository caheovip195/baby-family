import {
  Body,
  Controller,
  Headers,
  Inject,
  Param,
  ParseUUIDPipe,
  Post,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiHeader,
  ApiTags,
} from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  BirthConversionDto,
  BirthConversionResponseDto,
} from '../dto/pregnancy/birth-conversion.dto';
import { BIRTH_CONVERSION_WORKFLOW_SERVICE } from '../interfaces/services/birth-conversion-workflow-service.interface';
import type { IBirthConversionWorkflowService } from '../interfaces/services/birth-conversion-workflow-service.interface';
@ApiTags('Pregnancy')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('pregnancies/:id/birth')
export class BirthConversionController {
  constructor(
    @Inject(BIRTH_CONVERSION_WORKFLOW_SERVICE)
    private readonly service: IBirthConversionWorkflowService,
  ) {}
  @Post()
  @ApiHeader({
    name: 'Idempotency-Key',
    required: true,
    schema: { type: 'string', format: 'uuid' },
  })
  @ApiCreatedResponse({ type: BirthConversionResponseDto })
  convert(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Headers('idempotency-key') key: string,
    @Body() input: BirthConversionDto,
  ) {
    return this.service.convert(actor, id, key, input);
  }
}
