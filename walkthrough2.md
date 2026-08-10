# Walkthrough: Fondasi Keamanan & Autentikasi (OTP & RBAC)

Sistem Autentikasi dan Manajemen Pengguna telah berhasil dikembangkan sesuai dengan pedoman keamanan yang ada di `SECURITY_GUIDELINES.md`. 

Berikut merupakan fitur-fitur yang telah diimplementasikan:

## 1. Integrasi Dependensi Keamanan
Telah dilakukan instalasi library krusial:
- `bcrypt`: Digunakan untuk memverifikasi kecocokan *password hash* pada login Admin.
- `@nestjs/jwt` & `passport-jwt`: Dikonfigurasi untuk menerbitkan (*issue*) dan memvalidasi JSON Web Token.
- `@nestjs/throttler`: Menangani mekanisme *Rate Limiting*.

## 2. Manajemen Pengguna (UsersModule)
- Telah dibuat entitas TypeORM untuk `User` dan `Role` beserta relasinya (`ManyToOne`), yang merujuk pada tabel `users` dan `roles`.
- Service pendukung telah dibuat di `UsersService` untuk kebutuhan agregasi (contoh: pencarian berdasarkan Email untuk Admin dan Nomor HP untuk masyarakat).

## 3. Autentikasi OTP & Admin (AuthModule)
- **Modul Redis untuk OTP:** Layanan memori Redis (melalui `@nestjs/cache-manager`) digunakan secara langsung untuk menyimpan OTP. Parameter TTL (waktu kedaluwarsa) disetel secara konstan ke **5 menit** (300000ms).
- **Layanan Autentikasi:** Tiga fitur utama ditambahkan pada `AuthService`:
  - `requestOtp(phoneNumber)`: Menghasilkan 6-digit OTP dan menyimpannya di Redis.
  - `verifyOtp(phoneNumber, otp)`: Memverifikasi kode. Jika valid, pengguna dicari di database lalu menerbitkan token JWT.
  - `loginAdmin(email, password)`: Memvalidasi kredensial `bcrypt` untuk Admin, kemudian mengembalikan JWT.

## 4. Rate Limiting pada OTP
- Endpoint API `POST /auth/otp/request` pada [AuthController](file:///home/dhonaldduck/Documents/Dispora-projects/dispora-backend/src/modules/auth/auth.controller.ts) telah dilindungi oleh `ThrottlerGuard` dan parameter `@Throttle()` lokal, dengan batasan ketat **5 request per menit** untuk entitas IP yang terhubung, guna menghindari mitigasi serangan bruteforce SMS/WhatsApp gateway.

## 5. Role-Based Access Control (RBAC)
- **RolesGuard**: Custom Guard `RolesGuard` diciptakan untuk memeriksa *role* pengguna berdasarkan payload token JWT (yang disuntikkan via `JwtAuthGuard`).
- **Decorator Khusus**: Dekorator `@Roles('Super Admin')` dapat dipasang dengan praktis pada Endpoint di Controller apapun untuk membatasi akses layanannya di tingkat modul HTTP.

## Struktur Rute Tersedia:
- `POST /auth/otp/request` 
- `POST /auth/otp/verify`
- `POST /auth/admin/login`

> [!TIP]
> Saat ini, seluruh Modul (Database, Cache, Users, dan Auth) sudah resmi didaftarkan di dalam *Root Application* pada [app.module.ts](file:///home/dhonaldduck/Documents/Dispora-projects/dispora-backend/src/app.module.ts). Anda dapat mengeksekusi `npm run start:dev` untuk menguji cobanya melalui Postman atau cURL.
