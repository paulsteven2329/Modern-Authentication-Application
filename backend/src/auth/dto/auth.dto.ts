import { IsEmail, IsNotEmpty, IsString } from 'class-validator';

export class SendMagicLinkDto {
  @IsEmail()
  @IsNotEmpty()
  email: string;
}

export class VerifyMagicLinkDto {
  @IsString()
  @IsNotEmpty()
  token: string;
}

export class SocialLoginDto {
  @IsString()
  @IsNotEmpty()
  code: string;
}