import { Injectable, PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-facebook';
import { ConfigService } from '@nestjs/config';
import { UserService } from '../user/user.service';

@Injectable()
export class FacebookStrategy extends PassportStrategy(Strategy, 'facebook') {
  constructor(
    private configService: ConfigService,
    private userService: UserService,
  ) {
    super({
      clientID: configService.get<string>('FACEBOOK_APP_ID'),
      clientSecret: configService.get<string>('FACEBOOK_APP_SECRET'),
      callbackURL: '/api/auth/facebook/callback',
      scope: ['email'],
      profileFields: ['emails', 'name', 'photos'],
    });
  }

  async validate(accessToken: string, refreshToken: string, profile: any) {
    const { emails, photos, name } = profile;
    
    const user = await this.userService.findOrCreateUser({
      email: emails[0].value,
      name: `${name.givenName} ${name.familyName}`,
      avatar: photos[0]?.value,
      facebookId: profile.id,
    });

    return user;
  }
}