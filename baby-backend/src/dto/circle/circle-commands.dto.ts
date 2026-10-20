import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsBoolean,
  IsEnum,
  IsString,
  IsUUID,
  MaxLength,
  MinLength,
  ValidateIf,
  ValidateNested,
} from 'class-validator';
import { CircleRelation, GrantPermission } from '../../common/database.enums';
import type {
  CircleRelation as Relation,
  GrantPermission as Permission,
} from '../../common/database.enums';
import { CIRCLE_POLICY } from '../../config/circle-policy';
const optional = () =>
  ValidateIf((_object, value: unknown) => value !== undefined);
export class CircleGrantDto {
  @optional() @IsUUID() childId?: string;
  @optional() @IsUUID() pregnancyId?: string;
  @IsBoolean() allowDownload!: boolean;
  @optional() @IsEnum(GrantPermission) permission?: Permission;
}
export class CreateCircleInviteDto {
  @IsEnum(CircleRelation) relation!: Relation;
  @IsString() @MinLength(1) @MaxLength(40) displayName!: string;
  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(CIRCLE_POLICY.maxGrants)
  @ValidateNested({ each: true })
  @Type(() => CircleGrantDto)
  grants!: CircleGrantDto[];
  @optional() @IsBoolean() allowDownload?: boolean;
  @optional() @IsString() @MaxLength(300) message?: string;
  @optional() @IsBoolean() requireFinalApproval?: boolean;
}
export class UpdateCircleMemberDto {
  @optional() @IsString() @MinLength(1) @MaxLength(40) displayName?: string;
  @optional() @IsBoolean() allowDownload?: boolean;
  @optional()
  @IsArray()
  @ArrayMaxSize(CIRCLE_POLICY.maxGrants)
  @ValidateNested({ each: true })
  @Type(() => CircleGrantDto)
  grants?: CircleGrantDto[];
}
