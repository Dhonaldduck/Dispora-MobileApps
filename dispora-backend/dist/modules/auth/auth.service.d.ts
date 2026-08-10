import { UsersService } from '../users/users.service';
import { JwtService } from '@nestjs/jwt';
import type { Cache } from 'cache-manager';
export declare class AuthService {
    private usersService;
    private jwtService;
    private cacheManager;
    constructor(usersService: UsersService, jwtService: JwtService, cacheManager: Cache);
    requestOtp(phoneNumber: string): Promise<{
        message: string;
        otp?: string;
    }>;
    verifyOtp(phoneNumber: string, otp: string): Promise<any>;
    loginAdmin(email: string, pass: string): Promise<any>;
    generateTokens(user: any): Promise<{
        access_token: string;
    }>;
}
