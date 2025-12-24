import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  async findById(id: string): Promise<User | null> {
    return this.userRepository.findOne({ where: { id } });
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.userRepository.findOne({ where: { email } });
  }

  async findByGoogleId(googleId: string): Promise<User | null> {
    return this.userRepository.findOne({ where: { googleId } });
  }

  async findByFacebookId(facebookId: string): Promise<User | null> {
    return this.userRepository.findOne({ where: { facebookId } });
  }

  async findByTwitterId(twitterId: string): Promise<User | null> {
    return this.userRepository.findOne({ where: { twitterId } });
  }

  async createUser(userData: Partial<User>): Promise<User> {
    const user = this.userRepository.create(userData);
    return this.userRepository.save(user);
  }

  async updateUser(id: string, updateData: Partial<User>): Promise<User> {
    await this.userRepository.update(id, updateData);
    return this.findById(id);
  }

  async verifyEmail(id: string): Promise<User> {
    await this.userRepository.update(id, { isEmailVerified: true });
    return this.findById(id);
  }

  async findOrCreateUser(userData: {
    email: string;
    name?: string;
    avatar?: string;
    googleId?: string;
    facebookId?: string;
    twitterId?: string;
  }): Promise<User> {
    let user: User;

    // Try to find existing user by social ID first
    if (userData.googleId) {
      user = await this.findByGoogleId(userData.googleId);
    } else if (userData.facebookId) {
      user = await this.findByFacebookId(userData.facebookId);
    } else if (userData.twitterId) {
      user = await this.findByTwitterId(userData.twitterId);
    }

    // If not found by social ID, try by email
    if (!user) {
      user = await this.findByEmail(userData.email);
    }

    if (user) {
      // Update existing user with new information
      const updateData: Partial<User> = {};
      if (userData.name && !user.name) updateData.name = userData.name;
      if (userData.avatar && !user.avatar) updateData.avatar = userData.avatar;
      if (userData.googleId && !user.googleId) updateData.googleId = userData.googleId;
      if (userData.facebookId && !user.facebookId) updateData.facebookId = userData.facebookId;
      if (userData.twitterId && !user.twitterId) updateData.twitterId = userData.twitterId;

      if (Object.keys(updateData).length > 0) {
        return this.updateUser(user.id, updateData);
      }

      return user;
    } else {
      // Create new user
      return this.createUser({
        ...userData,
        isEmailVerified: !!userData.googleId || !!userData.facebookId || !!userData.twitterId,
      });
    }
  }
}