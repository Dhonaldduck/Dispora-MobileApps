import { YouthServicesService } from './youth-services.service';
import { CreateYouthServiceDto } from './dto/create-youth-service.dto';
import { UpdateYouthServiceDto } from './dto/update-youth-service.dto';
export declare class YouthServicesController {
    private readonly youthServicesService;
    constructor(youthServicesService: YouthServicesService);
    findAll(): Promise<import("./entities/youth-service.entity").YouthService[]>;
    findBySlug(slug: string): Promise<import("./entities/youth-service.entity").YouthService>;
    create(createYouthServiceDto: CreateYouthServiceDto, req: any): Promise<import("./entities/youth-service.entity").YouthService>;
    update(id: string, updateYouthServiceDto: UpdateYouthServiceDto): Promise<import("./entities/youth-service.entity").YouthService>;
    remove(id: string): Promise<void>;
}
