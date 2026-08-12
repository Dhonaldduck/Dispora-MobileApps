# Walkthrough: Arsitektur Flutter Portal Dispora (Fase 1)

Pembuatan arsitektur dan kode dasar untuk aplikasi *mobile* Portal Informasi Dispora (Fase 1) telah selesai dilakukan. Aplikasi ini menggunakan `dio` untuk menangani *HTTP request* ke *backend*, dan `flutter_riverpod` untuk manajemen status (State Management).

Direktori proyek dibuat di: `dispora-mobile/`.

## Struktur Direktori yang Dibuat

Struktur menggunakan pendekatan *Feature-first* agar proyek dapat diukur (scalable) secara rapi seiring penambahan fitur.

```
dispora-mobile/
├── pubspec.yaml
└── lib/
    ├── main.dart
    ├── core/
    │   └── network/
    │       └── api_client.dart
    ├── features/
    │   ├── agenda/
    │   ├── news/
    │   └── youth_services/
    └── ui/
        └── screens/
            └── home_screen.dart
```

## Komponen Utama yang Telah Dibuat

### 1. File Konfigurasi (pubspec.yaml)
Saya membuat [pubspec.yaml](file:///home/dhonaldduck/Documents/Dispora-projects/dispora-mobile/pubspec.yaml) untuk mendefinisikan *package* eksternal yang esensial, yaitu `dio`, `flutter_riverpod`, dan `intl`.

### 2. Network Layer
Konfigurasi Dio berada pada [api_client.dart](file:///home/dhonaldduck/Documents/Dispora-projects/dispora-mobile/lib/core/network/api_client.dart).
- File ini mengatur *base URL* dinamis berdasarkan *platform* (menggunakan `10.0.2.2` untuk Android Emulator dan `127.0.0.1` untuk iOS Simulator).
- Mendefinisikan *Timeout* dan *Headers* default.

### 3. Models
Telah dibuat tiga Model *data class* utama yang masing-masing memiliki fungsi `fromJson` untuk pemetaan respons JSON:
- [news.dart](file:///home/dhonaldduck/Documents/Dispora-projects/dispora-mobile/lib/features/news/models/news.dart): Model `News` berisi `id`, `title`, `content`, `thumbnailUrl`, `slug`, dan `createdAt`.
- [agenda.dart](file:///home/dhonaldduck/Documents/Dispora-projects/dispora-mobile/lib/features/agenda/models/agenda.dart): Model `Agenda` berisi `id`, `title`, `description`, `location`, `startDate`, `endDate`, dan `thumbnailUrl`.
- [youth_service.dart](file:///home/dhonaldduck/Documents/Dispora-projects/dispora-mobile/lib/features/youth_services/models/youth_service.dart): Model `YouthService` berisi `id`, `title`, `description`, `category`, `registrationLink`, dan `thumbnailUrl`.

### 4. Repositories
*Repository pattern* digunakan untuk membungkus panggilan API dari aplikasi.
- [news_repository.dart](file:///home/dhonaldduck/Documents/Dispora-projects/dispora-mobile/lib/features/news/repositories/news_repository.dart) melakukan `GET /news` dan memetakan datanya menjadi `List<News>`.
- [agenda_repository.dart](file:///home/dhonaldduck/Documents/Dispora-projects/dispora-mobile/lib/features/agenda/repositories/agenda_repository.dart) melakukan `GET /agendas` dan memetakan datanya menjadi `List<Agenda>`.
- [youth_service_repository.dart](file:///home/dhonaldduck/Documents/Dispora-projects/dispora-mobile/lib/features/youth_services/repositories/youth_service_repository.dart) melakukan `GET /youth-services` dan memetakan datanya menjadi `List<YouthService>`.

### 5. Riverpod Providers
Agar UI dapat mengakses Repository dan datanya secara asinkron, dibuatkan file Provider yang membungkus *Repository*:
- [news_provider.dart](file:///home/dhonaldduck/Documents/Dispora-projects/dispora-mobile/lib/features/news/providers/news_provider.dart)
- [agenda_provider.dart](file:///home/dhonaldduck/Documents/Dispora-projects/dispora-mobile/lib/features/agenda/providers/agenda_provider.dart)
- [youth_service_provider.dart](file:///home/dhonaldduck/Documents/Dispora-projects/dispora-mobile/lib/features/youth_services/providers/youth_service_provider.dart)
Masing-masing provider menggunakan tipe `FutureProvider` untuk memudahkan penanganan *loading* dan *error* pada UI.

### 6. UI: Home Screen
Tampilan layar utama berada di [home_screen.dart](file:///home/dhonaldduck/Documents/Dispora-projects/dispora-mobile/lib/ui/screens/home_screen.dart).
Halaman ini adalah komponen `ConsumerWidget` yang me-*render* keseluruhan tampilan menggunakan `SingleChildScrollView` dan mencakup tiga bagian:
1. **Daftar Berita Terbaru:** Disajikan dengan daftar kartu (Card UI) secara *horizontal scroll*.
2. **Jadwal Agenda Terdekat:** Ditampilkan secara rapi dalam daftar vertikal dengan `ListTile`, memuat informasi nama, lokasi, dan tanggal.
3. **Katalog Layanan Kepemudaan:** Disajikan menggunakan *Grid View* (Card Grid) untuk layanan kepemudaan yang ada.

Titik masuk utama aplikasi, `main.dart`, juga telah diperbarui dengan *ProviderScope* dan konfigurasi Material3 di [main.dart](file:///home/dhonaldduck/Documents/Dispora-projects/dispora-mobile/lib/main.dart).

> [!TIP]
> **Cara Menjalankan**
> Mengingat *Flutter SDK* tidak terinstal di environment saat ini, Anda dapat mengunduh direktori `dispora-mobile` atau membukanya di komputer lokal Anda, lalu jalankan perintah:
> ```bash
> flutter create .
> flutter pub get
> flutter run
> ```
> (Jika menggunakan `flutter create .`, pastikan ia tidak menimpa `pubspec.yaml` atau `lib/main.dart` buatan saya secara utuh. Sebaiknya inisiasi struktur asli Flutter dan copy folder `lib` dan isi `pubspec.yaml` yang baru saja kita buat).
