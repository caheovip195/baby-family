import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type { INotificationTextRepository } from '../interfaces/repositories/notification-text-repository.interface';
import { NotificationTemplate } from '../models/notification-template.model';

@Injectable()
export class NotificationTextRepository implements INotificationTextRepository {
  constructor(private readonly prisma: PrismaService) {}
  async findTemplates(codes: string[]): Promise<NotificationTemplate[]> {
    if (codes.length === 0) return [];
    const rows = await this.prisma.notificationTemplate.findMany({
      where: {
        code: { in: [...new Set(codes)] },
        locale: { in: ['vi', 'en'] },
        enabled: true,
        deletedAt: null,
      },
    });
    return rows.map((row) => new NotificationTemplate(row));
  }
}
