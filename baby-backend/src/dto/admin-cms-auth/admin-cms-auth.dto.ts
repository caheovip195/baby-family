import { IsEmail, IsString, Length, Matches } from 'class-validator';
export class AdminCmsLoginDto {
  @IsEmail() @Length(3, 254) email!: string;
  @IsString() @Length(1, 1024) password!: string;
  @IsString() @Matches(/^\d{6}$/) totp!: string;
}
