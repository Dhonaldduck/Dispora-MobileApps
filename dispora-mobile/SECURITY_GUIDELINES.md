# SECURITY GUIDELINES & BEST PRACTICES
Acuan ini mengikat seluruh proses pengembangan aplikasi Dispora Semarang (Smart Sports & Youth Services Platform), baik pada Mobile App, Web Dashboard, maupun Backend API. Seluruh baris kode yang dihasilkan wajib mematuhi standar keamanan ini guna persiapan Penetration Testing.

## 1. Autentikasi & Otorisasi
*   **Kata Sandi (Password):** Dilarang menyimpan kata sandi dalam bentuk *plain text*. Semua kata sandi wajib di-*hash* menggunakan algoritma bcrypt atau Argon2.
*   **Otentikasi OTP:** Pengiriman OTP (Email/WhatsApp) memiliki masa berlaku maksimal 5 menit.
*   **Hak Akses (RBAC):** Gunakan Role-Based Access Control pada backend untuk membatasi akses: `Super Admin`, `Admin Konten`, dan `Admin Layanan`. Verifikasi peran (*role verification*) harus dilakukan di level *middleware*.
*   **Audit Log:** Setiap aksi modifikasi data (Create, Update, Delete) oleh Admin maupun pengguna harus dicatat (*logged*) mencakup `user_id`, `action`, `timestamp`, dan `IP address`.

## 2. Keamanan Komunikasi & Data
*   **Transport Layer:** Seluruh komunikasi antara Client dan Server harus dienkripsi menggunakan HTTPS/TLS 1.3. Dilarang keras menggunakan HTTP biasa.
*   **Enkripsi At-Rest:** Data pribadi (seperti NIK, nomor telepon) dan dokumen unggahan sensitif harus dienkripsi saat disimpan (at-rest) menggunakan standar AES-256.
*   **Data Pembayaran:** Aplikasi sama sekali **tidak menyimpan** data kartu kredit/debit. Semua transaksi harus diarahkan dan diproses sepenuhnya melalui Payment Gateway tersertifikasi (Midtrans).

## 3. Mitigasi Serangan & Validasi Input
*   **SQL Injection & XSS:** Gunakan ORM/Query Builder (seperti Prisma atau TypeORM) untuk mencegah SQL Injection. Seluruh input dari pengguna harus disanitasi untuk mencegah serangan Cross-Site Scripting (XSS).
*   **Rate Limiting:** Terapkan pembatasan permintaan (rate limiting) pada *endpoint* publik, khususnya pada fitur login/OTP: maksimal 5 permintaan OTP per menit per nomor, dan 100 *request* per menit per alamat IP.
*   **File Upload Validation:** Pada setiap fitur unggah (misal: dokumen kepemudaan atau foto laporan), wajib dilakukan validasi tipe berkas (hanya PDF/JPG) dan batasan ukuran berkas (maksimal 5 MB). Dilarang mengandalkan validasi hanya pada sisi *frontend*.

## 4. Perlindungan Endpoint API & State
*   **Token & Sesi:** Gunakan JWT (*JSON Web Tokens*) dengan masa kedaluwarsa yang wajar dan mekanisme *refresh token*. Jangan letakkan JWT di *local storage* untuk Web Dashboard; gunakan *HttpOnly cookies*.
*   **Slot Locking Integrity:** Penguncian slot venue selama 15 menit menggunakan Redis harus bersifat atomik dan mengunci kunci spesifik (misal: `lock:venue_id:date:slot`) untuk mencegah eksploitasi *race condition*.
*   **Ticket Validation:** QR Code E-ticket harus berisi data yang di-*sign* secara kriptografis (signed token) oleh backend agar tidak dapat dipalsukan.