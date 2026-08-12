import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { Role } from './entities/role.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepository: Repository<User>,
    @InjectRepository(Role)
    private readonly rolesRepository: Repository<Role>,
  ) { }

  async findByEmail(email: string): Promise<User | null> {
    return this.usersRepository.findOne({ where: { email }, relations: { role: true } });
  }

  async findByPhone(phoneNumber: string): Promise<User | null> {
    return this.usersRepository.findOne({ where: { phoneNumber }, relations: { role: true } });
  }

  async createUser(data: Partial<User>): Promise<User> {
    if (!data.roleId) {
      let masyarakatRole = await this.rolesRepository.findOne({ where: { name: 'Masyarakat' } });
      if (!masyarakatRole) {
        masyarakatRole = this.rolesRepository.create({ name: 'Masyarakat' });
        await this.rolesRepository.save(masyarakatRole);
      }
      data.roleId = masyarakatRole.id;
    }

    const newUser = this.usersRepository.create(data);
    return this.usersRepository.save(newUser);
  }
}
