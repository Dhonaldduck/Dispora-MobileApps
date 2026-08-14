import { Injectable, UnauthorizedException, Inject } from '@nestjs/common';
import { UsersService } from '../users/users.service';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import type { Cache } from 'cache-manager';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
    @Inject(CACHE_MANAGER) private cacheManager: Cache,
  ) { }

  async requestOtp(phoneNumber: string): Promise<{ message: string; otp?: string }> {
    // Generate 6 digit OTP
    const otp = Math.floor(100000 + Math.random() * 900000).toString();

    // Store in Redis with 5 minutes TTL (300000 ms)
    await this.cacheManager.set(`otp:${phoneNumber}`, otp, 300000);

    // In a real scenario, we send this OTP via WhatsApp/SMS
    return { message: 'OTP sent successfully', otp }; // Return OTP for testing purposes
  }

  async verifyOtp(phoneNumber: string, otp: string): Promise<any> {
    const storedOtp = await this.cacheManager.get<string>(`otp:${phoneNumber}`);
    if (!storedOtp || storedOtp !== otp) {
      throw new UnauthorizedException('Invalid or expired OTP');
    }

    // OTP valid, remove from cache
    await this.cacheManager.del(`otp:${phoneNumber}`);

    // Check if user exists
    let user = await this.usersService.findByPhone(phoneNumber);
    if (!user) {
      // Auto register for citizens (Masyarakat) could be implemented here
      throw new UnauthorizedException('User not found');
    }

    return this.generateTokens(user);
  }

  async loginAdmin(email: string, pass: string): Promise<any> {
    const user = await this.usersService.findByEmail(email);
    if (!user || !user.password) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const isMatch = await bcrypt.compare(pass, user.password);
    if (!isMatch) {
      throw new UnauthorizedException('Invalid credentials');
    }

    return this.generateTokens(user);
  }

  async generateTokens(user: any) {
    const payload = { sub: user.id, email: user.email, role: user.role?.name || 'Masyarakat' };
    return {
      access_token: this.jwtService.sign(payload),
    };
  }
}
