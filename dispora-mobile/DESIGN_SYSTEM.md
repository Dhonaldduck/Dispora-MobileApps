# DESIGN SYSTEM & UI/UX GUIDELINES
Acuan ini digunakan untuk pengembangan antarmuka Aplikasi Dispora Semarang (Smart Sports & Youth Services Platform)[cite: 1]. Dokumen ini berlaku untuk Mobile App (Flutter) maupun Web Dashboard Admin (Next.js & Tailwind CSS)[cite: 1].

## 1. Color Palette (Tema Warna Utama)
Menggunakan tema "The Active Authority" yang menggabungkan profesionalisme pemerintah dan energi olahraga. Tema ini menggabungkan profesionalisme pemerintah (Biru), energi olahraga (Merah), serta pertumbuhan dan kesehatan (Hijau). Aksen Hijau sekarang digunakan lebih pervasive di seluruh rencana layout. Gunakan *hex code* berikut secara konsisten:

*   **Primary (Biru):** `#1D4ED8` 
    *   *Fungsi:* Warna dominan untuk Header, Sidebar Admin, Ikon Navigasi Bawah, dan Tombol Aksi Utama (Call to Action seperti "Booking Sekarang").
*   **Secondary (Merah):** `#DC2626` 
    *   *Fungsi:* Warna aksen untuk elemen olahraga, tombol pembatalan, *badge* notifikasi penting, atau elemen interaktif sekunder.
*   **Tertiary (Hijau Health & Growth):** `#10B981` (Sama dengan Semantic Success, tetapi deployment lebih pervasive).
    *   *Fungsi:* Warna untuk aksen visual umum, ikon sekunder, garis pemisah, teks highlight, dan status berhasil. Memberikan nuansa sehat dan pertumbuhan.
*   **Background (Abu-abu Terang):** `#F3F4F6` 
    *   *Fungsi:* Latar belakang (canvas) utama untuk halaman aplikasi dan dashboard agar mata pengguna tidak cepat lelah.
*   **Surface/Card (Putih):** `#FFFFFF` 
    *   *Fungsi:* Latar belakang untuk *Card* Katalog Fasilitas, kontainer form, dan tabel data.
*   **Text Primary (Abu-abu Gelap):** `#1F2937` 
    *   *Fungsi:* Warna teks utama untuk judul, deskripsi, dan isi berita. (Hindari hitam pekat `#000000`).
*   **Text Secondary (Abu-abu Medium):** `#6B7280` 
    *   *Fungsi:* Warna untuk teks penjelas (subtitle), *placeholder* form, dan keterangan waktu.

## 2. Semantic/Status Colors (Warna Status & Indikator)
*   **Success (Hijau):** `#10B981` 
    *   *Fungsi:* Status "Selesai", "Terkonfirmasi", "Terbayar", dan notifikasi berhasil[cite: 1].
*   **Warning (Kuning/Oranye):** `#F59E0B` 
    *   *Fungsi:* Status "Menunggu Pembayaran", "Draft", atau lencana highlight untuk event khusus[cite: 1].
*   **Danger/Error (Merah Terang):** `#EF4444` 
    *   *Fungsi:* Status "Dibatalkan", "Kedaluwarsa", validasi *error* pada *form*, atau aksi destruktif (Hapus Data)[cite: 1].

## 3. Typography (Jenis Huruf)
*   **Mobile App (Flutter):** Gunakan font `Poppins` (via `google_fonts` package) untuk seluruh antarmuka agar terlihat modern, ramah, dan *sporty*.
*   **Web Dashboard (Next.js):** Gunakan font `Inter` (bawaan dari Tailwind CSS) untuk memastikan keterbacaan (*readability*) yang maksimal pada tabel dan data administratif.

## 4. Assets & Iconography
*   **Logo Aplikasi:**
    *   Mobile App: `assets/images/logo_dispora.png`
    *   Web Admin: `/public/assets/logo_dispora.svg`
*   **Icons (Mobile - Flutter):** Gunakan `phosphor_flutter` atau `CupertinoIcons` untuk tampilan ikon yang *clean*.
*   **Icons (Web - Next.js):** Gunakan `lucide-react` atau `react-icons/fi` (Feather Icons).

## 5. Component Styling Rules (Aturan Visual Komponen)
*   **Buttons (Tombol):** Wajib menggunakan *border-radius* `8px` (`rounded-lg` di Tailwind). Berikan efek sedikit perubahan warna (hover/ripple) saat ditekan.
*   **Cards (Kartu):** Wajib menggunakan *border-radius* `12px` (`rounded-xl` di Tailwind), latar belakang putih murni (`#FFFFFF`), dan *shadow* (bayangan) ringan `box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1)` agar terlihat elegan.
*   **Input / TextFields:** Harus memiliki *border* abu-abu terang yang berubah menjadi Biru (`#1D4ED8`) saat statusnya aktif (*focused*).
*   **Loading State:** Gunakan *Skeleton Loader* (efek *shimmer* warna abu-abu memudar) saat memuat Katalog Fasilitas atau Daftar Berita, jangan menggunakan animasi *loading spinner* sederhana.

## 6. Layout & Responsiveness
*   **Web Dashboard:** Wajib *fully responsive* menggunakan utilitas Tailwind (`sm:`, `md:`, `lg:`, `xl:`). Sidebar admin di sebelah kiri harus disembunyikan dan diubah menjadi *hamburger menu* pada resolusi layar di bawah `md` (tablet/mobile).
*   **Mobile App:** Hindari penggunaan tinggi atau lebar statis (*hardcode*). Gunakan *widget* `Expanded`, `Flexible`, atau `MediaQuery` agar UI beradaptasi mulus di berbagai resolusi layar *smartphone*.