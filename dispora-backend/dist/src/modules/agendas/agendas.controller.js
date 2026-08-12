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
exports.AgendasController = void 0;
const common_1 = require("@nestjs/common");
const agendas_service_1 = require("./agendas.service");
const create_agenda_dto_1 = require("./dto/create-agenda.dto");
const update_agenda_dto_1 = require("./dto/update-agenda.dto");
const jwt_auth_guard_1 = require("../auth/guards/jwt-auth.guard");
const roles_guard_1 = require("../auth/guards/roles.guard");
const roles_decorator_1 = require("../auth/decorators/roles.decorator");
let AgendasController = class AgendasController {
    agendasService;
    constructor(agendasService) {
        this.agendasService = agendasService;
    }
    findAll() {
        return this.agendasService.findAll(true);
    }
    findBySlug(slug) {
        return this.agendasService.findBySlug(slug);
    }
    create(createAgendaDto, req) {
        return this.agendasService.create(createAgendaDto, req.user.id);
    }
    update(id, updateAgendaDto) {
        return this.agendasService.update(id, updateAgendaDto);
    }
    remove(id) {
        return this.agendasService.remove(id);
    }
};
exports.AgendasController = AgendasController;
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], AgendasController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)(':slug'),
    __param(0, (0, common_1.Param)('slug')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], AgendasController.prototype, "findBySlug", null);
__decorate([
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    (0, roles_decorator_1.Roles)('Admin Konten', 'Super Admin'),
    (0, common_1.Post)(),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_agenda_dto_1.CreateAgendaDto, Object]),
    __metadata("design:returntype", void 0)
], AgendasController.prototype, "create", null);
__decorate([
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    (0, roles_decorator_1.Roles)('Admin Konten', 'Super Admin'),
    (0, common_1.Patch)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, update_agenda_dto_1.UpdateAgendaDto]),
    __metadata("design:returntype", void 0)
], AgendasController.prototype, "update", null);
__decorate([
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    (0, roles_decorator_1.Roles)('Admin Konten', 'Super Admin'),
    (0, common_1.Delete)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], AgendasController.prototype, "remove", null);
exports.AgendasController = AgendasController = __decorate([
    (0, common_1.Controller)('agendas'),
    __metadata("design:paramtypes", [agendas_service_1.AgendasService])
], AgendasController);
//# sourceMappingURL=agendas.controller.js.map