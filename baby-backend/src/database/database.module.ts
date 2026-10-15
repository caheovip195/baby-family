import { Module } from '@nestjs/common';
import { PrismaService } from './prisma.service';
import { ValkeyConnection } from './valkey.connection';

@Module({
  providers: [PrismaService, ValkeyConnection],
  exports: [PrismaService, ValkeyConnection],
})
export class DatabaseModule {}
