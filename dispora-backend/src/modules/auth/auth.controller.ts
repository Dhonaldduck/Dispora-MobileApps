import { Controller, Post, Body, UseGuards, HttpCode, HttpStatus } from '@nestjs/common';
import { AuthService } from './auth.service';
import { ThrottlerGuard, Throttle } from '@nestjs/throttler';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  // Apply Rate Limiting (5 requests per 60 seconds)
  @UseGuards(ThrottlerGuard)
  @Throttle({ default: { limit: 5, ttl: 60000 } })
  @Post('otp/request')
  @HttpCode(HttpStatus.OK)
  async requestOtp(@Body('phoneNumber') phoneNumber: string) {
    return this.authService.requestOtp(phoneNumber);
  }

  @Post('otp/verify')
  @HttpCode(HttpStatus.OK)
  async verifyOtp(@Body() body: { phoneNumber: string; otp: string }) {
    return this.authService.verifyOtp(body.phoneNumber, body.otp);
  }

  @Post('admin/login')
  @HttpCode(HttpStatus.OK)
  async adminLogin(@Body() body: { email: string; password: string }) {
    return this.authService.loginAdmin(body.email, body.password);
  }
}
