import { AuthService } from './auth.service';
export declare class AuthController {
    private readonly authService;
    constructor(authService: AuthService);
    requestOtp(phoneNumber: string): Promise<{
        message: string;
        otp?: string;
    }>;
    verifyOtp(body: {
        phoneNumber: string;
        otp: string;
    }): Promise<any>;
    adminLogin(body: {
        email: string;
        password: string;
    }): Promise<any>;
}
