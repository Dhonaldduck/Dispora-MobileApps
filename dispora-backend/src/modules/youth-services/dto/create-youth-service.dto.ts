import { IsNotEmpty, IsString, IsBoolean, IsOptional, IsUrl } from 'class-validator';

export class CreateYouthServiceDto {
  @IsNotEmpty()
  @IsString()
  title: string;

  @IsNotEmpty()
  @IsString()
  description: string;

  @IsNotEmpty()
  @IsString()
  category: string;

  @IsOptional()
  @IsString()
  thumbnailUrl?: string;

  @IsOptional()
  @IsUrl()
  registrationLink?: string;

  @IsOptional()
  @IsBoolean()
  isPublished?: boolean;
}
