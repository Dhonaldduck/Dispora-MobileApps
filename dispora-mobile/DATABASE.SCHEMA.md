# DATABASE SCHEMA & CONSTRAINTS GUIDELINES

## Aturan Umum
* Semua tabel wajib menggunakan penamaan *snake_case*.
* Tabel yang menyimpan kata sandi harus dipastikan menyimpan dalam bentuk hash (bcrypt/Argon2)[cite: 1].

## Entitas Fase 1 (Portal & Kepemudaan)
* **Users & Roles:** Menyimpan data pengguna, role admin, dan integrasi OTP log[cite: 1].
* **News & Events:** Menyimpan berita, pengumuman, regulasi, hibah olahraga, dan agenda kegiatan (memuat waktu, lokasi, dan penyelenggara)[cite: 1].
* **Sports_Database:** Entitas untuk Cabang Olahraga, KONI, KORMI, NPCI, profil atlet, pelatih, dan prestasi[cite: 1].
* **Youth_Services:** Formulir pendaftaran pelatihan, pengajuan izin, dan dokumen unggahan dengan status (Diajukan, Diverifikasi, Disetujui/Ditolak)[cite: 1].

## Entitas Fase 2 (Booking Engine)
* **Venues:** Menyimpan profil lapangan/venue, tarif, spesifikasi, dan *wajib* menggunakan tipe spasial (PostGIS) untuk lokasi Google Maps[cite: 1].
* **Venue_Slots & Bookings:** 
  * Wajib ada constraint unik pada basis data (misalnya `UNIQUE(venue_id, date, time_slot)`) untuk memastikan integritas pemesanan dan 0 kasus *double booking*[cite: 1].
  * Transaksi pemesanan (booking) harus bersifat atomik[cite: 1].
* **Payments:** Menyimpan log integrasi Midtrans dan status pembayaran[cite: 1].
* **Tickets:** Menyimpan data QR Code e-ticket dengan validasi *signed token* untuk pemindaian saat *check-in*[cite: 1].

## Entitas Fase 3 (Smart Sports)
* **Facility_Reports:** Menyimpan data pelaporan kerusakan fasilitas berupa foto dan lokasi GPS, serta status penanganan (Diterima, Diproses, Selesai/Ditolak)[cite: 1].