import { Repository } from 'typeorm';
import { Agenda } from './entities/agenda.entity';
import { CreateAgendaDto } from './dto/create-agenda.dto';
import { UpdateAgendaDto } from './dto/update-agenda.dto';
export declare class AgendasService {
    private readonly agendasRepository;
    constructor(agendasRepository: Repository<Agenda>);
    private generateSlug;
    create(createAgendaDto: CreateAgendaDto, authorId: string): Promise<Agenda>;
    findAll(isPublic: boolean): Promise<Agenda[]>;
    findBySlug(slug: string): Promise<Agenda>;
    findOne(id: string): Promise<Agenda>;
    update(id: string, updateAgendaDto: UpdateAgendaDto): Promise<Agenda>;
    remove(id: string): Promise<void>;
}
