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
exports.AgendasService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const agenda_entity_1 = require("./entities/agenda.entity");
let AgendasService = class AgendasService {
    agendasRepository;
    constructor(agendasRepository) {
        this.agendasRepository = agendasRepository;
    }
    generateSlug(title) {
        return title.toLowerCase().replace(/[^a-z0-9]+/g, '-') + '-' + Date.now();
    }
    async create(createAgendaDto, authorId) {
        const slug = this.generateSlug(createAgendaDto.title);
        const agenda = this.agendasRepository.create({
            ...createAgendaDto,
            slug,
            authorId,
        });
        return this.agendasRepository.save(agenda);
    }
    async findAll(isPublic) {
        const whereCondition = isPublic ? { isPublished: true } : {};
        return this.agendasRepository.find({
            where: whereCondition,
            relations: { author: true },
            order: { startDate: 'ASC' },
        });
    }
    async findBySlug(slug) {
        const agenda = await this.agendasRepository.findOne({ where: { slug }, relations: { author: true } });
        if (!agenda)
            throw new common_1.NotFoundException('Agenda not found');
        return agenda;
    }
    async findOne(id) {
        const agenda = await this.agendasRepository.findOne({ where: { id } });
        if (!agenda)
            throw new common_1.NotFoundException('Agenda not found');
        return agenda;
    }
    async update(id, updateAgendaDto) {
        const agenda = await this.findOne(id);
        let slug = agenda.slug;
        if (updateAgendaDto.title && updateAgendaDto.title !== agenda.title) {
            slug = this.generateSlug(updateAgendaDto.title);
        }
        Object.assign(agenda, { ...updateAgendaDto, slug });
        return this.agendasRepository.save(agenda);
    }
    async remove(id) {
        const agenda = await this.findOne(id);
        await this.agendasRepository.remove(agenda);
    }
};
exports.AgendasService = AgendasService;
exports.AgendasService = AgendasService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(agenda_entity_1.Agenda)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], AgendasService);
//# sourceMappingURL=agendas.service.js.map