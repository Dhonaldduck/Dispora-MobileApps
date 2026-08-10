import { CacheModuleOptions } from '@nestjs/cache-manager';
import * as redisStore from 'cache-manager-redis-store';
import * as dotenv from 'dotenv';
dotenv.config();

export const redisConfig: CacheModuleOptions = {
  isGlobal: true,
  store: redisStore,
  host: process.env.REDIS_HOST || 'localhost',
  port: parseInt(process.env.REDIS_PORT || '6379', 10),
  password: process.env.REDIS_PASSWORD || '',
  ttl: 60 * 15, // Default TTL (misal untuk booking lock 15 menit)
};
