import {
  Controller,
  Post,
  Get,
  Body,
  UseGuards,
  Req,
  Res,
  Query,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { Response } from 'express';
import { ConfigService } from '@nestjs/config';
import { AuthService } from './auth.service';
import { SendMagicLinkDto, VerifyMagicLinkDto } from './dto/auth.dto';

@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly configService: ConfigService,
  ) {}

  @Post('send-magic-link')
  async sendMagicLink(@Body() sendMagicLinkDto: SendMagicLinkDto) {
    return this.authService.sendMagicLink(sendMagicLinkDto.email);
  }

  @Post('verify-magic-link')
  async verifyMagicLink(@Body() verifyMagicLinkDto: VerifyMagicLinkDto) {
    return this.authService.verifyMagicLink(verifyMagicLinkDto.token);
  }

  // Google OAuth routes
  @Get('google')
  @UseGuards(AuthGuard('google'))
  async googleAuth(@Query('redirect_uri') redirectUri: string, @Req() req) {
    // Store redirect URI in session or state parameter
    if (redirectUri) {
      req.session = req.session || {};
      req.session.redirectUri = redirectUri;
    }
  }

  @Get('google/callback')
  @UseGuards(AuthGuard('google'))
  async googleAuthRedirect(@Req() req, @Res() res: Response) {
    const result = await this.authService.validateSocialLogin(req.user);
    const frontendUrl = this.configService.get<string>('FRONTEND_URL', 'http://localhost:3000');
    const redirectUri = req.session?.redirectUri || `${frontendUrl}/auth/callback`;
    
    // Redirect to frontend with token
    const callbackUrl = new URL(redirectUri);
    callbackUrl.searchParams.set('provider', 'google');
    callbackUrl.searchParams.set('token', result.access_token);
    
    res.redirect(callbackUrl.toString());
  }

  // Facebook OAuth routes
  @Get('facebook')
  @UseGuards(AuthGuard('facebook'))
  async facebookAuth(@Query('redirect_uri') redirectUri: string, @Req() req) {
    if (redirectUri) {
      req.session = req.session || {};
      req.session.redirectUri = redirectUri;
    }
  }

  @Get('facebook/callback')
  @UseGuards(AuthGuard('facebook'))
  async facebookAuthRedirect(@Req() req, @Res() res: Response) {
    const result = await this.authService.validateSocialLogin(req.user);
    const frontendUrl = this.configService.get<string>('FRONTEND_URL', 'http://localhost:3000');
    const redirectUri = req.session?.redirectUri || `${frontendUrl}/auth/callback`;
    
    const callbackUrl = new URL(redirectUri);
    callbackUrl.searchParams.set('provider', 'facebook');
    callbackUrl.searchParams.set('token', result.access_token);
    
    res.redirect(callbackUrl.toString());
  }
}