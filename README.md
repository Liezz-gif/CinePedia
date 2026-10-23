# 🎬 CinePedia - Movie Catalog App

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)

**CinePedia** adalah aplikasi katalog film modern berbasis mobile yang dikembangkan menggunakan framework **Flutter** dan bahasa pemrograman **Dart**. Aplikasi ini dibangun untuk memenuhi tugas **UTS Praktikum Pemrograman Mobile**, menyajikan antarmuka bertema bioskop gelap (*Dark Cinema Theme*) dengan aksen emas (*amber*), navigasi yang intuitif, serta manajemen penyimpanan lokal yang persisten.

---

## 📱 Tangkapan Layar (Screenshots)

| Login & Register | Halaman Utama (Beranda) | Katalog & Pencarian |
| :---: | :---: | :---: |
| *(Tampilkan Screenshot 1)* | *(Tampilkan Screenshot 2)* | *(Tampilkan Screenshot 3)* |

| Detail Film & Ulasan | Daftar Favorit | Profil & Pengaturan |
| :---: | :---: | :---: |
| *(Tampilkan Screenshot 4)* | *(Tampilkan Screenshot 5)* | *(Tampilkan Screenshot 6)* |

---

## ✨ Fitur Utama

- 🔐 **Autentikasi Pengguna (Login & Register):**
  - Form validasi input (email, panjang password minimal 6 karakter, konfirmasi password).
  - Toggle visibilitas kata sandi (*obscure text*).
  - Penyimpanan sesi pengguna aktif menggunakan `SharedPreferences`.

- 🏠 **Halaman Beranda Dinamis (Home View):**
  - Search bar interaktif yang terhubung langsung ke katalog pencarian.
  - Pilihan kategori genre interaktif (Action, Drama, Sci-Fi, Animation, Semua).
  - Carousel film populer bergulir horizontal (*Horizontal Scroll*).
  - Daftar rekomendasi film vertikal lengkap dengan tombol bookmark cepat.

- 🔍 **Katalog & Pencarian Real-Time (Movie List):**
  - Filter genre berbasis chip horizontal.
  - Pencarian judul film secara langsung (*real-time query*) dengan tombol pembersih (*clear search*).

- 📖 **Detail Film & Review Interaktif (Movie Detail):**
  - Banner poster resolusi tinggi dengan gradien bayangan sinematik.
  - Informasi detail: genre badge, durasi film, sinopsis cerita, dan skor rating.
  - Sistem penilaian interaktif (bintang 1–5).
  - Formulir penulisan ulasan dan daftar ulasan pengguna sebelumnya.

- ❤️ **Daftar Film Favorit (Watchlist):**
  - Fitur simpan/hapus film favorit secara persisten.
  - Tampilan *empty state* yang interaktif saat belum ada film yang disimpan.

- 🌐 **Pengaturan & Multi-Bahasa (Profile & Settings):**
  - Menampilkan profil akun pengguna aktif.
  - Dukungan dua bahasa: **Bahasa Indonesia** dan **English**.
  - Switch pengaturan notifikasi dan tombol Logout.

---

## 🛠️ Teknologi & Arsitektur

- **Framework:** Flutter (Channel stable)
- **Language:** Dart
- **Design System:** Material 3 Dark Theme (`#121212` & `Colors.amber`)
- **State Management:** Reactive State Management via `ValueNotifier` & `ValueListenableBuilder`
- **Local Storage:** `shared_preferences` untuk persistensi sesi login, bookmark favorit, ulasan, dan bahasa aplikasi.
- **Data Source:** Dataset lokal berbasis file JSON (`assets/data/movies.json`)

---

## 📁 Struktur Direktori

```text
lib/
├── main.dart                  # Titik masuk aplikasi, tema global, & kontrol BottomNavigationBar
├── models/
│   └── movie.dart             # Model data Movie & parser JSON
├── screens/
│   ├── auth_screen.dart       # Layar Login dan Registrasi
│   ├── movie_detail.dart      # Layar Detail Film, Rating & Komentar
│   └── movie_list.dart        # Layar Katalog Film dengan Filter & Search
├── services/
│   ├── auth_service.dart      # Manajemen sesi login & registrasi lokal
│   ├── favorite_service.dart  # Manajemen penyimpanan film favorit
│   ├── language_service.dart  # Layanan lokalisasi bahasa (ID / EN)
│   └── review_service.dart    # Manajemen ulasan dan rating pengguna
└── widgets/
    └── movie_poster.dart      # Reusable widget gambar poster & error fallback
```

---

## 🚀 Panduan Menjalankan Proyek

### Prasyarat
- Pastikan sudah menginstal [Flutter SDK](https://docs.flutter.dev/get-started/install) versi terbaru.
- Editor kode seperti VS Code atau Android Studio.
- Emulator Android/iOS atau perangkat fisik yang terhubung.

### Langkah Instalasi

1. **Clone repositori ini:**
   ```bash
   git clone https://github.com/Liezz-gif/CinePedia.git
   cd CinePedia
   ```

2. **Unduh dependensi proyek:**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi:**
   ```bash
   flutter run
   ```

---

## 👨‍💻 Pengembang

- **Nama:** *(Ahmad Kholishun Ni'am)*
- **NIM:** *(240605110208)*
- **Program Studi:** *(Teknik Informatika)*
- **Mata Kuliah:** Praktikum Pemrograman Mobile (UTS)
