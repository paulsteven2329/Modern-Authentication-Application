import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as nodemailer from 'nodemailer';

@Injectable()
export class EmailService {
  private readonly logger = new Logger(EmailService.name);
  private transporter: nodemailer.Transporter;

  constructor(private configService: ConfigService) {
    this.createTransporter();
  }

  private createTransporter() {
    const smtpHost = this.configService.get<string>('SMTP_HOST');
    const smtpPort = this.configService.get<number>('SMTP_PORT');
    const smtpUser = this.configService.get<string>('SMTP_USER');
    const smtpPass = this.configService.get<string>('SMTP_PASS');

    if (!smtpHost || !smtpUser || !smtpPass) {
      this.logger.warn('Email service not configured properly. Email sending will be simulated.');
      return;
    }

    this.transporter = nodemailer.createTransporter({
      host: smtpHost,
      port: smtpPort,
      secure: smtpPort === 465,
      auth: {
        user: smtpUser,
        pass: smtpPass,
      },
    });
  }

  async sendMagicLink(email: string, token: string): Promise<boolean> {
    const frontendUrl = this.configService.get<string>('FRONTEND_URL', 'http://localhost:3000');
    const magicLink = `${frontendUrl}/auth/callback?token=${token}`;

    const mailOptions = {
      from: this.configService.get<string>('FROM_EMAIL'),
      to: email,
      subject: 'Your Magic Login Link',
      html: this.getMagicLinkTemplate(magicLink),
    };

    try {
      if (!this.transporter) {
        // Simulate email sending for development
        this.logger.log(`Magic link would be sent to ${email}: ${magicLink}`);
        console.log(`\n🔗 Magic Link for ${email}:`);
        console.log(`${magicLink}\n`);
        return true;
      }

      await this.transporter.sendMail(mailOptions);
      this.logger.log(`Magic link sent successfully to ${email}`);
      return true;
    } catch (error) {
      this.logger.error(`Failed to send magic link to ${email}:`, error);
      return false;
    }
  }

  private getMagicLinkTemplate(magicLink: string): string {
    return `
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Magic Login Link</title>
        <style>
          body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 0;
            background-color: #f7fafc;
          }
          .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
          }
          .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            overflow: hidden;
          }
          .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 32px;
            text-align: center;
            color: white;
          }
          .content {
            padding: 32px;
          }
          .button {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            padding: 16px 32px;
            border-radius: 8px;
            font-weight: 600;
            text-align: center;
            margin: 20px 0;
          }
          .footer {
            background: #f7fafc;
            padding: 24px;
            text-align: center;
            color: #4a5568;
            font-size: 14px;
          }
          .warning {
            background: #fef5e7;
            border: 1px solid #f6e05e;
            border-radius: 8px;
            padding: 16px;
            margin: 20px 0;
            color: #744210;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="card">
            <div class="header">
              <h1 style="margin: 0; font-size: 24px;">🔐 Your Magic Login Link</h1>
            </div>
            <div class="content">
              <p>Hi there!</p>
              <p>You requested a magic link to sign in to your account. Click the button below to securely sign in:</p>
              
              <div style="text-align: center;">
                <a href="${magicLink}" class="button">🚀 Sign In Securely</a>
              </div>
              
              <div class="warning">
                <strong>⚠️ Security Notice:</strong>
                <ul style="margin: 8px 0 0 0; padding-left: 20px;">
                  <li>This link will expire in 15 minutes</li>
                  <li>It can only be used once</li>
                  <li>Don't share this link with anyone</li>
                </ul>
              </div>
              
              <p>If you didn't request this login link, you can safely ignore this email.</p>
              
              <hr style="margin: 24px 0; border: none; border-top: 1px solid #e2e8f0;">
              
              <p style="color: #718096; font-size: 14px;">
                If the button doesn't work, copy and paste this link into your browser:<br>
                <code style="background: #f7fafc; padding: 4px 8px; border-radius: 4px; word-break: break-all;">${magicLink}</code>
              </p>
            </div>
            <div class="footer">
              <p>Modern Auth App • Secure • Passwordless</p>
            </div>
          </div>
        </div>
      </body>
      </html>
    `;
  }
}