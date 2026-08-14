# BOOKING STATE MACHINE & WORKFLOW

## Alur Utama Pemesanan (End-to-End)
1. **Pencarian:** Pengguna mencari dan memilih venue dari Katalog Fasilitas[cite: 1].
2. **Ketersediaan:** Menampilkan kalender ketersediaan slot real-time[cite: 1].
3. **Penguncian (Redis Lock):** Pengguna mengisi data dan memilih durasi[cite: 1]. Slot *dikunci sementara maksimal 15 menit* selama proses pembayaran agar tidak dapat dipesan pengguna lain[cite: 1].
4. **Pembayaran:** Sistem mengarahkan ke pembayaran digital (QRIS / Virtual Account / E-Wallet)[cite: 1].
5. **Konfirmasi & E-Ticket:** Jika pembayaran berhasil, status diperbarui menjadi Terbayar/Terkonfirmasi, dan QR Code E-Ticket diterbitkan[cite: 1].
6. **Batal Otomatis:** Jika pembayaran tidak diselesaikan dalam batas waktu 15 menit, status menjadi Dibatalkan Otomatis, dan slot dilepas kembali ke publik[cite: 1].
7. **Check-in:** Pengguna memindai QR Code di lokasi venue, mengubah status menjadi Selesai[cite: 1].

## Definisi Status Booking
* **Draft / Menunggu Pembayaran:** Proses inisiasi, slot sedang dikunci Redis[cite: 1].
* **Terbayar:** Transaksi Midtrans sukses[cite: 1].
* **Terkonfirmasi / Terverifikasi:** Admin Dispora melakukan verifikasi pemesanan[cite: 1].
* **Kedaluwarsa:** Pembayaran melewati batas 15 menit[cite: 1].
* **Dibatalkan:** Dibatalkan oleh pengguna atau Admin Dispora mengikuti kebijakan *refund*[cite: 1].
* **Reschedule:** Perubahan jadwal ke slot yang tersedia[cite: 1].
* **Ditolak:** Venue tidak dapat digunakan (misal: perbaikan), disertai pengembalian dana[cite: 1].
* **Selesai:** Pengguna telah melakukan *check-in* di venue[cite: 1].