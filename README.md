# 🧠 LogiLand - Game Puzzle Edukatif

*LogiLand* adalah game puzzle edukatif berbasis **Flutter** yang dirancang untuk mengasah **logika**, **kemampuan berhitung**, dan **pemecahan pola**. Game ini cocok dimainkan oleh pelajar, guru, maupun pecinta teka-teki logika dari berbagai usia.

---

## 🎮 Mode Permainan Saat Ini

### 1. 🔢 TekaSkor

Tebak angka rahasia 4 digit tanpa angka yang berulang berdasarkan petunjuk:

* ✅ Angka dan posisi benar
* 🔁 Angka benar tapi posisi salah
* ❌ Angka tidak ada di kode

Mirip dengan permainan *Wordle* versi angka.

### 2. 🧮 MathMaze

Selesaikan puzzle matematika dengan memilih **jalur yang tepat** di dalam grid:

* Setiap ubin memiliki angka atau operator
* Tujuanmu adalah mencapai hasil target
* Melatih penjumlahan, perkalian, dan logika urutan

### 3. 🔤 Cryptarithm

Tantangan **huruf jadi angka** klasik:

* Huruf mewakili digit angka (contoh: `AB + AB = CBB`)
* Pemain harus mencari nilai digit yang tepat agar persamaan valid
* Meningkatkan kemampuan berpikir abstrak dan numerik

---

## 🧱 Struktur Proyek

```
lib/
├── core/               # Routing, tema, dan utilitas umum
├── features/
│   ├── teka_skor/      # Mode 1: Tebak angka
│   ├── math_maze/      # Mode 2: Jalur matematika
│   └── cryptarithm/    # Mode 3: Puzzle huruf ke angka
├── widgets/            # Widget UI yang bisa digunakan ulang
└── main.dart           # Titik masuk aplikasi
```

---

## 🔮 Rencana Pengembangan

* [x] Mode: TekaSkor
* [x] Mode: MathMaze
* [x] Mode: Cryptarithm
* [ ] Mode: NeuroLink (hubungkan simpul warna)
* [ ] Mode: BalanceIt (logika timbangan)
* [ ] Mode: Circuit Logic (AND, OR, NOT)
* [ ] Mode: Slide Puzzle (puzzle geser 15 ubin)
* [ ] Sistem skor global & progres
* [ ] Sistem pencapaian dan profil pengguna

---

## 🛠️ Teknologi yang Digunakan

* 🚀 **Flutter 3.22**
* 🧩 **Riverpod** - Manajemen state
* 🧭 **GoRouter** - Navigasi antar halaman
* 🎨 **Google Fonts** - Konsistensi tampilan

---

## 👨‍💻 Developer

Dibuat dengan semangat dan logika oleh [@rafifauzan](https://github.com/rafifauzan29)

---

## 📄 Lisensi

MIT License - Bebas digunakan, dimodifikasi, dan didistribusikan.