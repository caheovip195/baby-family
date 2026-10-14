import { ApiProperty } from '@nestjs/swagger';

export class BillingPlanResponseDto {
  @ApiProperty() code!: string;
  @ApiProperty({ type: 'object', additionalProperties: { type: 'string' } })
  displayName!: Record<string, string>;
  @ApiProperty() displayOrder!: number;
  @ApiProperty({ format: 'uuid' }) versionId!: string;
  @ApiProperty() version!: number;
  @ApiProperty({ type: 'object', additionalProperties: { type: 'number' } })
  quotas!: Record<string, number>;
  @ApiProperty({ type: 'object', additionalProperties: { type: 'boolean' } })
  features!: Record<string, boolean>;
}

export class BillingTrialPolicyResponseDto {
  @ApiProperty() code!: string;
  @ApiProperty() version!: number;
  @ApiProperty({
    type: String,
    description: 'Exact duration in seconds, serialized as a decimal integer.',
  })
  durationSeconds!: string;
  @ApiProperty({ type: [Number] }) reminderOffsetsSeconds!: number[];
  @ApiProperty({ type: BillingPlanResponseDto }) plan!: BillingPlanResponseDto;
}

export class BillingCatalogResponseDto {
  @ApiProperty({ type: [BillingPlanResponseDto] })
  plans!: BillingPlanResponseDto[];
  @ApiProperty({ type: [BillingTrialPolicyResponseDto] })
  trialPolicies!: BillingTrialPolicyResponseDto[];
}
