import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
export declare class UsersService {
    private readonly usersRepository;
    constructor(usersRepository: Repository<User>);
    findByEmail(email: string): Promise<User | null>;
    findByPhone(phoneNumber: string): Promise<User | null>;
    createUser(data: Partial<User>): Promise<User>;
}
