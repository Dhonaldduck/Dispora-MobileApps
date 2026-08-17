import { AgendasService } from './agendas.service';
import { CreateAgendaDto } from './dto/create-agenda.dto';
import { UpdateAgendaDto } from './dto/update-agenda.dto';
export declare class AgendasController {
    private readonly agendasService;
    constructor(agendasService: AgendasService);
    findAll(): Promise<import("./entities/agenda.entity").Agenda[]>;
    findBySlug(slug: string): Promise<import("./entities/agenda.entity").Agenda>;
    create(createAgendaDto: CreateAgendaDto, req: any): Promise<import("./entities/agenda.entity").Agenda>;
    update(id: string, updateAgendaDto: UpdateAgendaDto): Promise<import("./entities/agenda.entity").Agenda>;
    remove(id: string): Promise<void>;
    uploadFile(file: Express.Multer.File): {
        message: string;
        filePath: string;
    };
}
