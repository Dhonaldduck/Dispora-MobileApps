import { DataSource } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User } from './src/modules/users/entities/user.entity';
import { Role } from './src/modules/users/entities/role.entity';
import * as dotenv from 'dotenv';
dotenv.config();

const AppDataSource = new DataSource({
  type: 'postgres',
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432', 10),
  username: process.env.DB_USERNAME || 'postgres',
  password: process.env.DB_PASSWORD || 'password',
  database: process.env.DB_NAME || 'dispora_db',
  entities: [User, Role],
  synchronize: false,
});

async function run() {
  await AppDataSource.initialize();
  console.log('Database connected.');

  const roleRepo = AppDataSource.getRepository(Role);
  const userRepo = AppDataSource.getRepository(User);

  let adminRole = await roleRepo.findOneBy({ name: 'Super Admin' });
  if (!adminRole) {
    adminRole = roleRepo.create({ name: 'Super Admin' });
    await roleRepo.save(adminRole);
    console.log('Role "Super Admin" created.');
  }

  const email = 'admin@dispora.semarangkota.go.id';
  let adminUser = await userRepo.findOneBy({ email });
  const hashedPassword = await bcrypt.hash('admin123', 10);
  
  if (!adminUser) {
    adminUser = userRepo.create({
      email,
      password: hashedPassword,
      fullName: 'Super Admin',
      roleId: adminRole.id,
    });
    await userRepo.save(adminUser);
    console.log(`User created. Email: ${email}, Password: admin123`);
  } else {
    adminUser.password = hashedPassword;
    await userRepo.save(adminUser);
    console.log(`User password updated. Email: ${email}, Password: admin123`);
  }

  await AppDataSource.destroy();
}

run().catch(console.error);
