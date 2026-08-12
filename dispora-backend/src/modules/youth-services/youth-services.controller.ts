import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Request } from '@nestjs/common';
import { YouthServicesService } from './youth-services.service';
import { CreateYouthServiceDto } from './dto/create-youth-service.dto';
import { UpdateYouthServiceDto } from './dto/update-youth-service.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';

@Controller('youth-services')
export class YouthServicesController {
  constructor(private readonly youthServicesService: YouthServicesService) {}

  @Get()
  findAll() {
    return this.youthServicesService.findAll(true);
  }

  @Get(':slug')
  findBySlug(@Param('slug') slug: string) {
    return this.youthServicesService.findBySlug(slug);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('Admin Konten', 'Super Admin')
  @Post()
  create(@Body() createYouthServiceDto: CreateYouthServiceDto, @Request() req) {
    return this.youthServicesService.create(createYouthServiceDto, req.user.id);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('Admin Konten', 'Super Admin')
  @Patch(':id')
  update(@Param('id') id: string, @Body() updateYouthServiceDto: UpdateYouthServiceDto) {
    return this.youthServicesService.update(id, updateYouthServiceDto);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('Admin Konten', 'Super Admin')
  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.youthServicesService.remove(id);
  }
}
