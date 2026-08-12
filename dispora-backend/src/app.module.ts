import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CacheModule } from '@nestjs/cache-manager';
import { databaseConfig } from './config/database.config';
import { redisConfig } from './config/redis.config';
import { UsersModule } from './modules/users/users.module';
import { AuthModule } from './modules/auth/auth.module';
import { NewsModule } from './modules/news/news.module';
import { AgendasModule } from './modules/agendas/agendas.module';
import { YouthServicesModule } from './modules/youth-services/youth-services.module';

@Module({
  imports: [
    TypeOrmModule.forRoot(databaseConfig),
    CacheModule.register(redisConfig),
    UsersModule,
    AuthModule,
    NewsModule,
    AgendasModule,
    YouthServicesModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
