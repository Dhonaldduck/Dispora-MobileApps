import { PartialType } from '@nestjs/mapped-types';
import { CreateYouthServiceDto } from './create-youth-service.dto';

export class UpdateYouthServiceDto extends PartialType(CreateYouthServiceDto) {}
