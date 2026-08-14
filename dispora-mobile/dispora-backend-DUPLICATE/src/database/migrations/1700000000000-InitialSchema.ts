import { MigrationInterface, QueryRunner, Table, TableForeignKey, TableIndex } from 'typeorm';

export class InitialSchema1700000000000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    // Aktifkan ekstensi PostGIS
    await queryRunner.query(`CREATE EXTENSION IF NOT EXISTS postgis`);

    // 1. Table ROLES
    await queryRunner.createTable(new Table({
      name: 'roles',
      columns: [
        { name: 'id', type: 'uuid', isPrimary: true, generationStrategy: 'uuid', default: 'uuid_generate_v4()' },
        { name: 'name', type: 'varchar', isUnique: true }, // 'Super Admin', 'Admin Konten', 'Admin Layanan'
        { name: 'created_at', type: 'timestamp', default: 'now()' },
        { name: 'updated_at', type: 'timestamp', default: 'now()' }
      ]
    }), true);

    // 2. Table USERS
    await queryRunner.createTable(new Table({
      name: 'users',
      columns: [
        { name: 'id', type: 'uuid', isPrimary: true, generationStrategy: 'uuid', default: 'uuid_generate_v4()' },
        { name: 'role_id', type: 'uuid' },
        { name: 'email', type: 'varchar', isUnique: true },
        { name: 'phone_number', type: 'varchar', isUnique: true, isNullable: true },
        { name: 'password', type: 'varchar' }, // Hashed with bcrypt/Argon2
        { name: 'full_name', type: 'varchar' },
        { name: 'created_at', type: 'timestamp', default: 'now()' },
        { name: 'updated_at', type: 'timestamp', default: 'now()' }
      ]
    }), true);

    await queryRunner.createForeignKey('users', new TableForeignKey({
      columnNames: ['role_id'],
      referencedColumnNames: ['id'],
      referencedTableName: 'roles',
      onDelete: 'RESTRICT'
    }));

    // 3. Table VENUES
    await queryRunner.createTable(new Table({
      name: 'venues',
      columns: [
        { name: 'id', type: 'uuid', isPrimary: true, generationStrategy: 'uuid', default: 'uuid_generate_v4()' },
        { name: 'name', type: 'varchar' },
        { name: 'description', type: 'text', isNullable: true },
        { name: 'specifications', type: 'jsonb', isNullable: true },
        { name: 'price_per_slot', type: 'numeric', precision: 10, scale: 2 },
        { name: 'location', type: 'geometry', spatialFeatureType: 'Point', srid: 4326 }, // PostGIS GPS coordinate
        { name: 'created_at', type: 'timestamp', default: 'now()' },
        { name: 'updated_at', type: 'timestamp', default: 'now()' }
      ]
    }), true);

    // 4. Table BOOKINGS
    await queryRunner.createTable(new Table({
      name: 'bookings',
      columns: [
        { name: 'id', type: 'uuid', isPrimary: true, generationStrategy: 'uuid', default: 'uuid_generate_v4()' },
        { name: 'user_id', type: 'uuid' },
        { name: 'venue_id', type: 'uuid' },
        { name: 'booking_date', type: 'date' },
        { name: 'time_slot', type: 'varchar' }, // e.g., '08:00-10:00'
        { name: 'status', type: 'varchar', default: "'PENDING'" },
        { name: 'created_at', type: 'timestamp', default: 'now()' },
        { name: 'updated_at', type: 'timestamp', default: 'now()' }
      ]
    }), true);

    await queryRunner.createForeignKey('bookings', new TableForeignKey({
      columnNames: ['user_id'],
      referencedColumnNames: ['id'],
      referencedTableName: 'users',
      onDelete: 'CASCADE'
    }));

    await queryRunner.createForeignKey('bookings', new TableForeignKey({
      columnNames: ['venue_id'],
      referencedColumnNames: ['id'],
      referencedTableName: 'venues',
      onDelete: 'CASCADE'
    }));

    // CONSTRAINT: Mencegah double booking (venue yang sama, tanggal yang sama, slot yang sama)
    await queryRunner.createIndex('bookings', new TableIndex({
      name: 'IDX_UNIQUE_VENUE_BOOKING',
      columnNames: ['venue_id', 'booking_date', 'time_slot'],
      isUnique: true
    }));
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('bookings');
    await queryRunner.dropTable('venues');
    await queryRunner.dropTable('users');
    await queryRunner.dropTable('roles');
  }
}
