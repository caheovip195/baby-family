import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Inject,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { CalendarQueryDto } from '../dto/calendar/calendar-query.dto';
import type { CalendarResponseDto } from '../dto/calendar/calendar-response.dto';
import { CreateEventDto } from '../dto/calendar/create-event.dto';
import type { EventResponseDto } from '../dto/calendar/event-response.dto';
import { UpdateEventDto } from '../dto/calendar/update-event.dto';
import { CALENDAR_SERVICE } from '../interfaces/services/calendar-service.interface';
import type { ICalendarService } from '../interfaces/services/calendar-service.interface';

@ApiTags('Calendar')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId/calendar')
export class CalendarController {
  constructor(
    @Inject(CALENDAR_SERVICE)
    private readonly service: ICalendarService,
  ) {}

  @Get()
  async getCalendar(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Query() query: CalendarQueryDto,
  ): Promise<CalendarResponseDto> {
    return this.service.getCalendar(actor, familyId, query);
  }
}

@ApiTags('Events')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('events')
export class EventController {
  constructor(
    @Inject(CALENDAR_SERVICE)
    private readonly service: ICalendarService,
  ) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  async createEvent(
    @CurrentActor() actor: AuthPrincipal,
    @Body() dto: CreateEventDto,
  ): Promise<EventResponseDto> {
    return this.service.createEvent(actor, dto);
  }

  @Get(':id')
  async getEvent(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<EventResponseDto> {
    return this.service.getEvent(actor, id);
  }

  @Patch(':id')
  async updateEvent(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateEventDto,
  ): Promise<EventResponseDto> {
    return this.service.updateEvent(actor, id, dto);
  }

  @Delete(':id')
  async deleteEvent(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<{ deleted: boolean }> {
    return this.service.deleteEvent(actor, id);
  }
}
