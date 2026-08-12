import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Request } from '@nestjs/common';
import { AgendasService } from './agendas.service';
import { CreateAgendaDto } from './dto/create-agenda.dto';
import { UpdateAgendaDto } from './dto/update-agenda.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';

@Controller('agendas')
export class AgendasController {
  constructor(private readonly agendasService: AgendasService) {}

  @Get()
  findAll() {
    return this.agendasService.findAll(true);
  }

  @Get(':slug')
  findBySlug(@Param('slug') slug: string) {
    return this.agendasService.findBySlug(slug);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('Admin Konten', 'Super Admin')
  @Post()
  create(@Body() createAgendaDto: CreateAgendaDto, @Request() req) {
    return this.agendasService.create(createAgendaDto, req.user.id);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('Admin Konten', 'Super Admin')
  @Patch(':id')
  update(@Param('id') id: string, @Body() updateAgendaDto: UpdateAgendaDto) {
    return this.agendasService.update(id, updateAgendaDto);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('Admin Konten', 'Super Admin')
  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.agendasService.remove(id);
  }
}
