import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { YouthService } from './entities/youth-service.entity';
import { CreateYouthServiceDto } from './dto/create-youth-service.dto';
import { UpdateYouthServiceDto } from './dto/update-youth-service.dto';

@Injectable()
export class YouthServicesService {
  constructor(
    @InjectRepository(YouthService)
    private readonly youthServicesRepository: Repository<YouthService>,
  ) {}

  private generateSlug(title: string): string {
    return title.toLowerCase().replace(/[^a-z0-9]+/g, '-') + '-' + Date.now();
  }

  async create(createYouthServiceDto: CreateYouthServiceDto, authorId: string): Promise<YouthService> {
    const slug = this.generateSlug(createYouthServiceDto.title);
    const youthService = this.youthServicesRepository.create({
      ...createYouthServiceDto,
      slug,
      authorId,
    });
    return this.youthServicesRepository.save(youthService);
  }

  async findAll(isPublic: boolean): Promise<YouthService[]> {
    const whereCondition = isPublic ? { isPublished: true } : {};
    return this.youthServicesRepository.find({
      where: whereCondition,
      relations: { author: true },
      order: { createdAt: 'DESC' }, // Menampilkan data terbaru di awal
    });
  }

  async findBySlug(slug: string): Promise<YouthService> {
    const youthService = await this.youthServicesRepository.findOne({ where: { slug }, relations: { author: true } });
    if (!youthService) throw new NotFoundException('Youth Service not found');
    return youthService;
  }

  async findOne(id: string): Promise<YouthService> {
    const youthService = await this.youthServicesRepository.findOne({ where: { id } });
    if (!youthService) throw new NotFoundException('Youth Service not found');
    return youthService;
  }

  async update(id: string, updateYouthServiceDto: UpdateYouthServiceDto): Promise<YouthService> {
    const youthService = await this.findOne(id);
    let slug = youthService.slug;
    if (updateYouthServiceDto.title && updateYouthServiceDto.title !== youthService.title) {
      slug = this.generateSlug(updateYouthServiceDto.title);
    }
    
    Object.assign(youthService, { ...updateYouthServiceDto, slug });
    return this.youthServicesRepository.save(youthService);
  }

  async remove(id: string): Promise<void> {
    const youthService = await this.findOne(id);
    await this.youthServicesRepository.remove(youthService);
  }
}
