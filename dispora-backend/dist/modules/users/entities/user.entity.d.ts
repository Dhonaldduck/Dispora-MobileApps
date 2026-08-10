import { Role } from './role.entity';
export declare class User {
    id: string;
    roleId: string;
    role: Role;
    email: string;
    phoneNumber: string;
    password?: string;
    fullName: string;
    createdAt: Date;
    updatedAt: Date;
}
