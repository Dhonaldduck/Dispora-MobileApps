import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Agenda } from './entities/agenda.entity';
import { CreateAgendaDto } from './dto/create-agenda.dto';
import { UpdateAgendaDto } from './dto/update-agenda.dto';

@Injectable()
export class AgendasService {
  constructor(
    @InjectRepository(Agenda)
    private readonly agendasRepository: Repository<Agenda>,
  ) {}

  private generateSlug(title: string): string {
    return title.toLowerCase().replace(/[^a-z0-9]+/g, '-') + '-' + Date.now();
  }

  async create(createAgendaDto: CreateAgendaDto, authorId: string): Promise<Agenda> {
    const slug = this.generateSlug(createAgendaDto.title);
    const agenda = this.agendasRepository.create({
      ...createAgendaDto,
      slug,
      authorId,
    });
    return this.agendasRepository.save(agenda);
  }

  async findAll(isPublic: boolean): Promise<Agenda[]> {
    const whereCondition = isPublic ? { isPublished: true } : {};
    return this.agendasRepository.find({
      where: whereCondition,
      relations: { author: true },
      order: { startDate: 'ASC' }, // Agenda terdekat berada di paling atas
    });
  }

  async findBySlug(slug: string): Promise<Agenda> {
    const agenda = await this.agendasRepository.findOne({ where: { slug }, relations: { author: true } });
    if (!agenda) throw new NotFoundException('Agenda not found');
    return agenda;
  }

  async findOne(id: string): Promise<Agenda> {
    const agenda = await this.agendasRepository.findOne({ where: { id } });
    if (!agenda) throw new NotFoundException('Agenda not found');
    return agenda;
  }

  async update(id: string, updateAgendaDto: UpdateAgendaDto): Promise<Agenda> {
    const agenda = await this.findOne(id);
    let slug = agenda.slug;
    if (updateAgendaDto.title && updateAgendaDto.title !== agenda.title) {
      slug = this.generateSlug(updateAgendaDto.title);
    }
    
    Object.assign(agenda, { ...updateAgendaDto, slug });
    return this.agendasRepository.save(agenda);
  }

  async remove(id: string): Promise<void> {
    const agenda = await this.findOne(id);
    await this.agendasRepository.remove(agenda);
  }
}
