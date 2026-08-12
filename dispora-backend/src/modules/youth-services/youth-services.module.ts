import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { YouthServicesService } from './youth-services.service';
import { YouthServicesController } from './youth-services.controller';
import { YouthService } from './entities/youth-service.entity';

@Module({
  imports: [TypeOrmModule.forFeature([YouthService])],
  controllers: [YouthServicesController],
  providers: [YouthServicesService],
})
export class YouthServicesModule {}
