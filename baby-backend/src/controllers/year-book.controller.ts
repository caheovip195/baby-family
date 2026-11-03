import {
  Body,
  Controller,
  Get,
  Inject,
  Param,
  ParseIntPipe,
  ParseUUIDPipe,
  Put,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  SaveYearBookDto,
  YearBookDto,
  YearBookListDto,
} from '../dto/year-book/year-book.dto';
import { YEAR_BOOK_SERVICE } from '../interfaces/services/year-book-service.interface';
import type { IYearBookService } from '../interfaces/services/year-book-service.interface';

/** REC-04 Sách của con (BF-20261028-013). */
@ApiTags('Children')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('children/:childId/year-book/:year')
export class YearBookController {
  constructor(
    @Inject(YEAR_BOOK_SERVICE)
    private readonly service: IYearBookService,
  ) {}

  @Get()
  @ApiOkResponse({ type: YearBookDto })
  get(
    @CurrentActor() actor: AuthPrincipal,
    @Param('childId', ParseUUIDPipe) childId: string,
    @Param('year', ParseIntPipe) year: number,
  ) {
    return this.service.get(actor, childId, year);
  }

  @Put()
  @ApiOkResponse({ type: YearBookDto })
  save(
    @CurrentActor() actor: AuthPrincipal,
    @Param('childId', ParseUUIDPipe) childId: string,
    @Param('year', ParseIntPipe) year: number,
    @Body() input: SaveYearBookDto,
  ) {
    return this.service.save(actor, childId, year, input);
  }
}

/**
 * REC-04 Sách cả nhà (BF-20261030-001): mọi ký ức của gia đình theo năm;
 * danh sách sách đã lưu / đã chia sẻ cho ông bà (BF-20261030-002).
 */
@ApiTags('Families')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId')
export class FamilyYearBookController {
  constructor(
    @Inject(YEAR_BOOK_SERVICE)
    private readonly service: IYearBookService,
  ) {}

  @Get('year-books')
  @ApiOkResponse({ type: YearBookListDto })
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
  ) {
    return this.service.list(actor, familyId);
  }

  @Get('year-book/:year')
  @ApiOkResponse({ type: YearBookDto })
  get(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('year', ParseIntPipe) year: number,
  ) {
    return this.service.getFamily(actor, familyId, year);
  }

  @Put('year-book/:year')
  @ApiOkResponse({ type: YearBookDto })
  save(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('year', ParseIntPipe) year: number,
    @Body() input: SaveYearBookDto,
  ) {
    return this.service.saveFamily(actor, familyId, year, input);
  }
}
