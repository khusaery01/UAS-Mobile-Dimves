# DIMVES

DIMVES adalah aplikasi e-commerce untuk pemesanan dimsum yang dibuat sebagai proyek Ujian Akhir Semester Mata Kuliah Mobile Programming.

## Teknologi
- Flutter
- Laravel
- MySQL
- REST API

## Fitur
- Login & Register
- Melihat daftar menu
- Detail produk
- Keranjang belanja
- Checkout
- Riwayat pesanan

## Cara Menjalankan

### Backend
```bash
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve
```

### Frontend
```bash
flutter pub get
flutter run
```

## Akses Admin

Jalankan backend Laravel:

```bash
php artisan serve
```

Kemudian buka panel admin melalui:

```
http://127.0.0.1:8000/admin
```
