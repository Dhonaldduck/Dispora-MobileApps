"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.InitialSchema1700000000000 = void 0;
const typeorm_1 = require("typeorm");
class InitialSchema1700000000000 {
    async up(queryRunner) {
        await queryRunner.query(`CREATE EXTENSION IF NOT EXISTS postgis`);
        await queryRunner.createTable(new typeorm_1.Table({
            name: 'roles',
            columns: [
                { name: 'id', type: 'uuid', isPrimary: true, generationStrategy: 'uuid', default: 'uuid_generate_v4()' },
                { name: 'name', type: 'varchar', isUnique: true },
                { name: 'created_at', type: 'timestamp', default: 'now()' },
                { name: 'updated_at', type: 'timestamp', default: 'now()' }
            ]
        }), true);
        await queryRunner.createTable(new typeorm_1.Table({
            name: 'users',
            columns: [
                { name: 'id', type: 'uuid', isPrimary: true, generationStrategy: 'uuid', default: 'uuid_generate_v4()' },
                { name: 'role_id', type: 'uuid' },
                { name: 'email', type: 'varchar', isUnique: true },
                { name: 'phone_number', type: 'varchar', isUnique: true, isNullable: true },
                { name: 'password', type: 'varchar' },
                { name: 'full_name', type: 'varchar' },
                { name: 'created_at', type: 'timestamp', default: 'now()' },
                { name: 'updated_at', type: 'timestamp', default: 'now()' }
            ]
        }), true);
        await queryRunner.createForeignKey('users', new typeorm_1.TableForeignKey({
            columnNames: ['role_id'],
            referencedColumnNames: ['id'],
            referencedTableName: 'roles',
            onDelete: 'RESTRICT'
        }));
        await queryRunner.createTable(new typeorm_1.Table({
            name: 'venues',
            columns: [
                { name: 'id', type: 'uuid', isPrimary: true, generationStrategy: 'uuid', default: 'uuid_generate_v4()' },
                { name: 'name', type: 'varchar' },
                { name: 'description', type: 'text', isNullable: true },
                { name: 'specifications', type: 'jsonb', isNullable: true },
                { name: 'price_per_slot', type: 'numeric', precision: 10, scale: 2 },
                { name: 'location', type: 'geometry', spatialFeatureType: 'Point', srid: 4326 },
                { name: 'created_at', type: 'timestamp', default: 'now()' },
                { name: 'updated_at', type: 'timestamp', default: 'now()' }
            ]
        }), true);
        await queryRunner.createTable(new typeorm_1.Table({
            name: 'bookings',
            columns: [
                { name: 'id', type: 'uuid', isPrimary: true, generationStrategy: 'uuid', default: 'uuid_generate_v4()' },
                { name: 'user_id', type: 'uuid' },
                { name: 'venue_id', type: 'uuid' },
                { name: 'booking_date', type: 'date' },
                { name: 'time_slot', type: 'varchar' },
                { name: 'status', type: 'varchar', default: "'PENDING'" },
                { name: 'created_at', type: 'timestamp', default: 'now()' },
                { name: 'updated_at', type: 'timestamp', default: 'now()' }
            ]
        }), true);
        await queryRunner.createForeignKey('bookings', new typeorm_1.TableForeignKey({
            columnNames: ['user_id'],
            referencedColumnNames: ['id'],
            referencedTableName: 'users',
            onDelete: 'CASCADE'
        }));
        await queryRunner.createForeignKey('bookings', new typeorm_1.TableForeignKey({
            columnNames: ['venue_id'],
            referencedColumnNames: ['id'],
            referencedTableName: 'venues',
            onDelete: 'CASCADE'
        }));
        await queryRunner.createIndex('bookings', new typeorm_1.TableIndex({
            name: 'IDX_UNIQUE_VENUE_BOOKING',
            columnNames: ['venue_id', 'booking_date', 'time_slot'],
            isUnique: true
        }));
    }
    async down(queryRunner) {
        await queryRunner.dropTable('bookings');
        await queryRunner.dropTable('venues');
        await queryRunner.dropTable('users');
        await queryRunner.dropTable('roles');
    }
}
exports.InitialSchema1700000000000 = InitialSchema1700000000000;
//# sourceMappingURL=1700000000000-InitialSchema.js.map