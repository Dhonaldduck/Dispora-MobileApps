"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.YouthServicesService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const youth_service_entity_1 = require("./entities/youth-service.entity");
let YouthServicesService = class YouthServicesService {
    youthServicesRepository;
    constructor(youthServicesRepository) {
        this.youthServicesRepository = youthServicesRepository;
    }
    generateSlug(title) {
        return title.toLowerCase().replace(/[^a-z0-9]+/g, '-') + '-' + Date.now();
    }
    async create(createYouthServiceDto, authorId) {
        const slug = this.generateSlug(createYouthServiceDto.title);
        const youthService = this.youthServicesRepository.create({
            ...createYouthServiceDto,
            slug,
            authorId,
        });
        return this.youthServicesRepository.save(youthService);
    }
    async findAll(isPublic) {
        const whereCondition = isPublic ? { isPublished: true } : {};
        return this.youthServicesRepository.find({
            where: whereCondition,
            relations: { author: true },
            order: { createdAt: 'DESC' },
        });
    }
    async findBySlug(slug) {
        const youthService = await this.youthServicesRepository.findOne({ where: { slug }, relations: { author: true } });
        if (!youthService)
            throw new common_1.NotFoundException('Youth Service not found');
        return youthService;
    }
    async findOne(id) {
        const youthService = await this.youthServicesRepository.findOne({ where: { id } });
        if (!youthService)
            throw new common_1.NotFoundException('Youth Service not found');
        return youthService;
    }
    async update(id, updateYouthServiceDto) {
        const youthService = await this.findOne(id);
        let slug = youthService.slug;
        if (updateYouthServiceDto.title && updateYouthServiceDto.title !== youthService.title) {
            slug = this.generateSlug(updateYouthServiceDto.title);
        }
        Object.assign(youthService, { ...updateYouthServiceDto, slug });
        return this.youthServicesRepository.save(youthService);
    }
    async remove(id) {
        const youthService = await this.findOne(id);
        await this.youthServicesRepository.remove(youthService);
    }
};
exports.YouthServicesService = YouthServicesService;
exports.YouthServicesService = YouthServicesService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(youth_service_entity_1.YouthService)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], YouthServicesService);
//# sourceMappingURL=youth-services.service.js.map