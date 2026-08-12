import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { Role } from './entities/role.entity';
export declare class UsersService {
    private readonly usersRepository;
    private readonly rolesRepository;
    constructor(usersRepository: Repository<User>, rolesRepository: Repository<Role>);
    findByEmail(email: string): Promise<User | null>;
    findByPhone(phoneNumber: string): Promise<User | null>;
    createUser(data: Partial<User>): Promise<User>;
}
