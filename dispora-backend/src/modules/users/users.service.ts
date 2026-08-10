import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepository: Repository<User>,
  ) { }

  async findByEmail(email: string): Promise<User | null> {
    return this.usersRepository.findOne({ where: { email }, relations: { role: true } });
  }

  async findByPhone(phoneNumber: string): Promise<User | null> {
    return this.usersRepository.findOne({ where: { phoneNumber }, relations: { role: true } });
  }

  async createUser(data: Partial<User>): Promise<User> {
    const newUser = this.usersRepository.create(data);
    return this.usersRepository.save(newUser);
  }
}
