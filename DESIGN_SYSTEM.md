# 🎨 DISPORA Semarang - UI/UX Design System

Dokumen ini adalah *Single Source of Truth* (SSOT) untuk implementasi antarmuka aplikasi DISPORA Semarang. Seluruh pengembangan komponen di Flutter wajib mengacu pada token warna dan tipografi di bawah ini.

## 1. Global Typography & Theme
*   **Font Family Utama:** Poppins (Alternatif: Montserrat)
*   **Karakteristik Visual:** Bersih, geometris, hangat, dan profesional.
*   **Radius (Sudut Melengkung):**
    *   Card Utama / Hero: `24px`
    *   Card Standar (Agenda/Statistik): `16px`
    *   Button: Pill-shape (Radius penuh / `99px`)
    *   Icon Container: `12px` atau Lingkaran Penuh

---

## 2. Color Palette — Light Mode

### A. Background & Surface
| Nama Token | HEX | Penggunaan (Widget Flutter) |
| :--- | :--- | :--- |
| `putihHangat` | `#FBF7F2` | `Scaffold` background, Splash screen |
| `putihBersih` | `#FFFFFF` | Background `Card`, Bottom Nav Bar, elemen kontras |
| `softCream` | `#F4EFEB` | Muted surface, background elemen sekunder |
| `blushCream` | `#F4E6DF` | Secondary button, badge tanggal, filter aktif |
| `creamPeach` | `#F5E6D0` | Background agenda, ikon notifikasi |
| `paleRed` | `#FCE9E5` | Background quick access, error ringan |

### B. Primary & Brand Colors
| Nama Token | HEX | Penggunaan (Widget Flutter) |
| :--- | :--- | :--- |
| `merahBata` | `#A33A32` | Primary `ElevatedButton`, Hero Banner, Tab Aktif |
| `merahBataGelap`| `#7F2925` | Teks di atas warna sekunder, status booking |
| `terracotta` | `#C07A49` | Aksen venue, kategori olahraga |
| `cokelatMerah` | `#7B4A3D` | Aksen outdoor, kartu fasilitas |
| `cokelatBatu` | `#8B5745` | Berita olahraga, aksen pendukung |

### C. Text & Typography Colors
| Nama Token | HEX | Penggunaan (Widget Flutter) |
| :--- | :--- | :--- |
| `cokelatTua` | `#3A2420` | Teks utama (`bodyLarge`, `titleLarge`), Ikon utama |
| `cokelatPekat` | `#4E2B1F` | Teks kontras tinggi di atas aksen amber/terang |
| `mutedBrown` | `#806B64` | Teks deskripsi (`bodyMedium`), metadata, placeholder |
| `ivoryWhite` | `#FFF8F0` | Teks utama di atas background gelap/merah bata |
| `softBlush` | `#F8DED6` | Teks sekunder di Hero Banner, Profile Card |
| `pureWhite` | `#FFFFFF` | Teks pada tombol utama, ikon kontras tinggi |

### D. Accents, Borders & States
| Nama Token | HEX | Penggunaan (Widget Flutter) |
| :--- | :--- | :--- |
| `warmGold` | `#D99A57` | Accent utama, badge status, angka statistik |
| `softGold` | `#E2B071` | Avatar profil, highlight |
| `paleGold` | `#F5D4A2` | Status terverifikasi |
| `borderCream` | `#E7D9D0` | `BorderSide` pada Card, Divider, Input outline |
| `inputBrown` | `#D8C4B8` | Outline TextField fokus |
| `warningBrown` | `#B77A14` | Ikon peringatan |
| `destructiveRed`| `#B54B42` | Error state, tombol hapus/batal |

---

## 3. Color Palette — Dark Mode

Jika aplikasi mendukung tema gelap, gunakan pemetaan berikut:

| Nama Token | HEX | Penggunaan (Widget Flutter) |
| :--- | :--- | :--- |
| `darkBackground`| `#281B1A` | `Scaffold` background utama |
| `darkCard` | `#3A2724` | `Card` surface |
| `darkMuted` | `#432C28` | Surface sekunder |
| `darkPrimary` | `#E07B6E` | Tombol utama, accent aktif |
| `darkPrimaryText`| `#281B1A` | Teks di atas tombol utama (`darkPrimary`) |
| `darkSecondary` | `#57352F` | Button/surface sekunder |
| `darkSecText` | `#F3C0B7` | Teks sekunder |
| `darkMutedText` | `#C9ABA1` | Metadata, teks deksripsi |
| `darkAccent` | `#E2B071` | Highlight, badge |
| `darkAccentText`| `#352015` | Teks di atas warna accent |
| `darkDestructive`| `#F08B7C` | Error state |
| `darkBorder` | `#64443C` | Divider, Card border |
| `darkInput` | `#7A574D` | Outline input field |

---

## 4. Transparencies & Overlays (Opacity)

Gunakan `Color.withOpacity()` atau kode ARGB untuk efek berikut:

| Nilai Alpha / Opacity | Penggunaan Spesifik |
| :--- | :--- |
| `0.88` (88%) | Ikon besar pada visual venue |
| `0.82` (82%) | Caption pada visual venue |
| `0.72` (72%) | Tanggal pada kartu berita utama |
| `0.32` (32%) | Ikon pada banner laporan |
| `0.18` (18%) | Badge "Open", elemen overlay dekorasi Hero |
| `0.16` (16%) | Label berita, dekorasi transparan |
| `0.15` (15%) | Tombol interaktif sekunder (misal: Edit profil) |
| `0.08` (8%) | Ornamen lingkaran dekoratif (Watermark Hero) |
| `rgba(0,0,0, 0.50)` | Overlay modal/dialog (Barrier color), fallback error |

---

## 5. Component Blueprints

Panduan merakit *widget* berdasarkan layout utama (HomeScreen).

### A. App Header (AppBar/Top Bar)
*   **Background:** `putihHangat`
*   **Subtitle (DISPORA SEMARANG):** `merahBata`, TextTyle: Uppercase, SemiBold, 10-12px, Letter Spacing > 0.
*   **Title (Selamat pagi):** `cokelatTua`, TextStyle: Bold, 24-28px.
*   **Notification Button:** Container `putihBersih`, Border `borderCream`, Ikon `cokelatTua`.

### B. Hero Banner Card
*   **Container Background:** `merahBata` (Solid).
*   **Dekorasi Ornamen:** Gunakan `putihBersih` dengan opacity `0.08` diposisikan absolut (Positioned) di sudut kanan bawah.
*   **Badge (KOTA SEMARANG):** Teks & Ikon `softBlush`, ukuran sangat kecil.
*   **Headline:** `pureWhite`, Bold, 22-26px.
*   **Deskripsi:** `softBlush` / `ivoryWhite`, Regular, 12-14px.
*   **CTA Button:** Background `blushCream`, Teks & Ikon `merahBata`, Radius pill.

### C. Stats Summary Card (Fasilitas, Agenda, Layanan)
*   **Container:** Background `putihBersih`, Border `borderCream` (1px), Radius `16px`, Elevation `0`.
*   **Angka (Value):** `merahBata`, Bold, 20-24px.
*   **Label Kategori:** `mutedBrown`, Regular, 10-12px.
*   **Divider Vertikal:** `borderCream`.

### D. Akses Cepat (Quick Access Grid)
*   **Section Title:** `cokelatTua`, Bold, 18px.
*   **Icon Container:** Background `paleRed` atau `blushCream`, Radius melengkung/lingkaran.
*   **Icon Color:** `cokelatTua` atau `merahBata` (Outline style).
*   **Label Teks:** `cokelatTua`, SemiBold, 12px.

### E. Agenda Terdekat (List Tile)
*   **Card Container:** Background `putihBersih`, Border `borderCream`, Radius `16px`.
*   **Date Badge (Kiri):** Background `blushCream`. Angka tanggal `merahBata` (Bold), Bulan uppercase (SemiBold).
*   **Title Agenda:** `cokelatTua`, Bold.
*   **Subtitle (Lokasi/Waktu):** `mutedBrown`, Regular.
*   **Chevron Icon:** `mutedBrown`.

### F. Bottom Navigation Bar
*   **Background:** `putihBersih`.
*   **Top Border:** `borderCream` (1px solid di sisi atas).
*   **Tab Aktif:** Ikon & Teks `merahBata`.
*   **Tab Inaktif:** Ikon & Teks `mutedBrown`.