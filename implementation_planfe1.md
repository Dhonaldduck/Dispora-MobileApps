# Implementasi Aplikasi Mobile Flutter untuk Portal Informasi Dispora

Berdasarkan permintaan Anda, kita akan membangun struktur awal untuk aplikasi mobile Dispora menggunakan Flutter. Karena ini adalah tahap awal (Fase 1), kita akan fokus pada struktur folder, integrasi API, dan tampilan utama (HomeScreen).

## Proposed Changes

Kita akan membuat direktori baru bernama `dispora-mobile` yang akan berisi struktur aplikasi Flutter. Meskipun perintah `flutter` mungkin tidak tersedia di environment saat ini, saya akan membuatkan struktur file Dart yang dibutuhkan sehingga Anda dapat langsung menjalankannya di mesin lokal Anda setelah menjalankan `flutter create .` dan `flutter pub get`.

### Struktur Folder yang Direkomendasikan
Akan digunakan arsitektur berbasis *feature* yang umum dan mudah dikelola (Feature-first architecture), digabungkan dengan Riverpod untuk State Management.

```
dispora-mobile/
├── pubspec.yaml
└── lib/
    ├── main.dart
    ├── core/
    │   └── network/
    │       └── api_client.dart       # Konfigurasi Dio
    ├── features/
    │   ├── news/
    │   │   ├── models/
    │   │   │   └── news.dart
    │   │   ├── repositories/
    │   │   │   └── news_repository.dart
    │   │   └── providers/
    │   │       └── news_provider.dart
    │   ├── agenda/
    │   │   ├── models/
    │   │   │   └── agenda.dart
    │   │   ├── repositories/
    │   │   │   └── agenda_repository.dart
    │   │   └── providers/
    │   │       └── agenda_provider.dart
    │   └── youth_services/
    │       ├── models/
    │       │   └── youth_service.dart
    │       ├── repositories/
    │       │   └── youth_service_repository.dart
    │       └── providers/
    │           └── youth_service_provider.dart
    └── ui/
        └── screens/
            └── home_screen.dart      # HomeScreen dengan 3 tab/bagian
```

### File yang akan dibuat:

#### [NEW] `dispora-mobile/pubspec.yaml`
Berisi dependensi utama: `dio`, `flutter_riverpod`, `json_annotation` (jika diperlukan untuk code generation), dan `intl` (untuk format tanggal).

#### [NEW] `dispora-mobile/lib/core/network/api_client.dart`
Konfigurasi dasar `Dio` menggunakan base URL lokal, mendukung iOS simulator (`127.0.0.1`) dan Android emulator (`10.0.2.2`).

#### [NEW] `dispora-mobile/lib/features/news/models/news.dart`
Model `News` lengkap dengan fungsi `fromJson`.

#### [NEW] `dispora-mobile/lib/features/agenda/models/agenda.dart`
Model `Agenda` lengkap dengan fungsi `fromJson`.

#### [NEW] `dispora-mobile/lib/features/youth_services/models/youth_service.dart`
Model `YouthService` lengkap dengan fungsi `fromJson`.

#### [NEW] `dispora-mobile/lib/features/news/repositories/news_repository.dart`
Fungsi `getNews()` melakukan `GET /news`.

#### [NEW] `dispora-mobile/lib/features/agenda/repositories/agenda_repository.dart`
Fungsi `getAgendas()` melakukan `GET /agendas`.

#### [NEW] `dispora-mobile/lib/features/youth_services/repositories/youth_service_repository.dart`
Fungsi `getYouthServices()` melakukan `GET /youth-services`.

#### Providers
Kita juga akan membuat providers dasar untuk Riverpod agar bisa langsung digunakan di UI.

#### [NEW] `dispora-mobile/lib/ui/screens/home_screen.dart`
Layar utama yang memuat:
1. Daftar Berita Terbaru dalam bentuk Card horizontal.
2. Jadwal Agenda Terdekat menggunakan ListTile.
3. Katalog Layanan Kepemudaan dengan Card grid atau list.

## User Review Required
> [!IMPORTANT]
> Harap setujui rencana ini untuk melanjutkan pembuatan file-file Dart dan struktur proyek ke dalam folder `dispora-mobile`. Setelah saya selesai, Anda perlu memastikan Flutter SDK terpasang di komputer Anda untuk menjalankan aplikasinya.

## Open Questions
- Apakah Anda ingin menggunakan `freezed` dan `json_serializable` untuk Model, atau cukup class biasa dengan manual `fromJson` mapping agar lebih sederhana tanpa *code generation* di awal ini? (Saya akan membuat class biasa dengan manual mapping terlebih dahulu jika tidak ada arahan khusus).
- Apakah Anda ingin menggunakan pola tampilan Scroll yang menyatu (semua bagian di-scroll ke bawah dalam satu halaman) atau menggunakan navigasi *BottomNavigationBar* (3 Tab terpisah)? (Saya akan berasumsi menggunakan satu halaman `ListView/SingleChildScrollView` dengan 3 section vertikal karena ini HomeScreen, kecuali Anda meminta Tab bar).
