import { Injectable, BadRequestException, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { v4 as uuidv4 } from 'uuid';
import { UserService } from '../user/user.service';
import { EmailService } from '../email/email.service';
import { MagicLink } from './magic-link.entity';
import { User } from '../user/user.entity';

@Injectable()
export class AuthService {
  constructor(
    private userService: UserService,
    private emailService: EmailService,
    private jwtService: JwtService,
    @InjectRepository(MagicLink)
    private magicLinkRepository: Repository<MagicLink>,
  ) {}

  async sendMagicLink(email: string): Promise<{ message: string }> {
    // Find or create user
    let user = await this.userService.findByEmail(email);
    if (!user) {
      user = await this.userService.createUser({ email });
    }

    // Generate magic link token
    const token = uuidv4();
    const expiresAt = new Date(Date.now() + 15 * 60 * 1000); // 15 minutes

    // Save magic link
    const magicLink = this.magicLinkRepository.create({
      token,
      userId: user.id,
      expiresAt,
    });
    await this.magicLinkRepository.save(magicLink);

    // Send email
    const emailSent = await this.emailService.sendMagicLink(email, token);
    if (!emailSent) {
      throw new BadRequestException('Failed to send magic link');
    }

    return { message: 'Magic link sent successfully' };
  }

  async verifyMagicLink(token: string): Promise<{ access_token: string; user: Partial<User> }> {
    // Find magic link
    const magicLink = await this.magicLinkRepository.findOne({
      where: { token },
      relations: ['user'],
    });

    if (!magicLink) {
      throw new UnauthorizedException('Invalid magic link');
    }

    if (magicLink.isUsed) {
      throw new UnauthorizedException('Magic link has already been used');
    }

    if (new Date() > magicLink.expiresAt) {
      throw new UnauthorizedException('Magic link has expired');
    }

    // Mark magic link as used
    magicLink.isUsed = true;
    await this.magicLinkRepository.save(magicLink);

    // Verify user email if not already verified
    if (!magicLink.user.isEmailVerified) {
      await this.userService.verifyEmail(magicLink.user.id);
      magicLink.user.isEmailVerified = true;
    }

    // Generate JWT token
    const payload = {
      sub: magicLink.user.id,
      email: magicLink.user.email,
      name: magicLink.user.name,
    };
    const access_token = this.jwtService.sign(payload);

    return {
      access_token,
      user: {
        id: magicLink.user.id,
        email: magicLink.user.email,
        name: magicLink.user.name,
        avatar: magicLink.user.avatar,
        isEmailVerified: magicLink.user.isEmailVerified,
      },
    };
  }

  async validateSocialLogin(user: User): Promise<{ access_token: string; user: Partial<User> }> {
    const payload = {
      sub: user.id,
      email: user.email,
      name: user.name,
    };
    const access_token = this.jwtService.sign(payload);

    return {
      access_token,
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        avatar: user.avatar,
        isEmailVerified: user.isEmailVerified,
      },
    };
  }

  async cleanupExpiredMagicLinks(): Promise<void> {
    await this.magicLinkRepository
      .createQueryBuilder()
      .delete()
      .where("expiresAt < :now", { now: new Date() })
      .execute();
  }
}