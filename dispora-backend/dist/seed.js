"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
const typeorm_1 = require("typeorm");
const bcrypt = __importStar(require("bcrypt"));
const user_entity_1 = require("./src/modules/users/entities/user.entity");
const role_entity_1 = require("./src/modules/users/entities/role.entity");
const dotenv = __importStar(require("dotenv"));
dotenv.config();
const AppDataSource = new typeorm_1.DataSource({
    type: 'postgres',
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '5432', 10),
    username: process.env.DB_USERNAME || 'postgres',
    password: process.env.DB_PASSWORD || 'password',
    database: process.env.DB_NAME || 'dispora_db',
    entities: [user_entity_1.User, role_entity_1.Role],
    synchronize: false,
});
async function run() {
    await AppDataSource.initialize();
    console.log('Database connected.');
    const roleRepo = AppDataSource.getRepository(role_entity_1.Role);
    const userRepo = AppDataSource.getRepository(user_entity_1.User);
    let adminRole = await roleRepo.findOneBy({ name: 'Super Admin' });
    if (!adminRole) {
        adminRole = roleRepo.create({ name: 'Super Admin' });
        await roleRepo.save(adminRole);
        console.log('Role "Super Admin" created.');
    }
    const email = 'admin@dispora.semarangkota.go.id';
    let adminUser = await userRepo.findOneBy({ email });
    const hashedPassword = await bcrypt.hash('admin123', 10);
    if (!adminUser) {
        adminUser = userRepo.create({
            email,
            password: hashedPassword,
            fullName: 'Super Admin',
            roleId: adminRole.id,
        });
        await userRepo.save(adminUser);
        console.log(`User created. Email: ${email}, Password: admin123`);
    }
    else {
        adminUser.password = hashedPassword;
        await userRepo.save(adminUser);
        console.log(`User password updated. Email: ${email}, Password: admin123`);
    }
    await AppDataSource.destroy();
}
run().catch(console.error);
//# sourceMappingURL=seed.js.map