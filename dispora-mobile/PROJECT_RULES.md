# PROJECT RULES: Aplikasi Dispora Semarang (Smart Sports & Youth Services Platform)

## Visi & Metrik Kesuksesan
* Platform digital terpadu ini menjadi pusat layanan kepemudaan dan olahraga Kota Semarang[cite: 1].
* Target Rilis MVP adalah Oktober 2026, dengan durasi eksekusi 3 bulan[cite: 1].
* Metrik kesuksesan MVP: Downtime bulan pertama < 1%, 100% layanan tersedia di aplikasi, >90% booking online, 0 kasus double booking, dan >70% pengurangan proses manual[cite: 1].

## Ruang Lingkup per Fase
* **Fase 1:** Portal Informasi & Layanan Kepemudaan (Berita, Agenda, Database Keolahragaan, Layanan Kepemudaan, Profil Dispora)[cite: 1].
* **Fase 2:** Sports Venue Booking & Event Management (Katalog Fasilitas, Ketersediaan Slot Real-time, Booking & Pembayaran, QR Code E-Ticket)[cite: 1].
* **Fase 3:** Smart Sports Innovation (Lapor Fasilitas, Dashboard Analitik Admin)[cite: 1].

## Standar Keamanan & Pengujian
* Seluruh komunikasi harus berjalan melalui HTTPS/TLS 1.3[cite: 1].
* Kata sandi wajib di-hash menggunakan algoritma bcrypt atau Argon2[cite: 1].
* Hak akses menggunakan sistem Role-Based Access Control (RBAC) dengan tingkatan Super Admin, Admin Konten, dan Admin Layanan, serta setiap perubahan data wajib dicatat pada audit log[cite: 1].
* Harus diimplementasikan *Rate limiting* pada level Backend: maksimal 5 permintaan OTP per menit per nomor dan 100 request per menit per alamat IP[cite: 1].
* Data pribadi dan dokumen unggahan dienkripsi secara *at-rest* (AES-256)[cite: 1].
* Mitigasi SQL Injection dan XSS, serta wajib ada validasi tipe dan ukuran berkas (maksimal 5 MB, PDF/JPG) pada fitur unggah[cite: 1].
* Modul pembayaran, autentikasi, dan fitur unggah berkas harus dipersiapkan dan diarsitekturkan secara tangguh untuk menghadapi *penetration testing* sebelum *hard launch*, guna meminimalisir kerentanan sejak tahap awal *intelligence gathering* dan deteksi kelemahan sistem[cite: 1].