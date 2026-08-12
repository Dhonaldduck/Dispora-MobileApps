import { Repository } from 'typeorm';
import { YouthService } from './entities/youth-service.entity';
import { CreateYouthServiceDto } from './dto/create-youth-service.dto';
import { UpdateYouthServiceDto } from './dto/update-youth-service.dto';
export declare class YouthServicesService {
    private readonly youthServicesRepository;
    constructor(youthServicesRepository: Repository<YouthService>);
    private generateSlug;
    create(createYouthServiceDto: CreateYouthServiceDto, authorId: string): Promise<YouthService>;
    findAll(isPublic: boolean): Promise<YouthService[]>;
    findBySlug(slug: string): Promise<YouthService>;
    findOne(id: string): Promise<YouthService>;
    update(id: string, updateYouthServiceDto: UpdateYouthServiceDto): Promise<YouthService>;
    remove(id: string): Promise<void>;
}
