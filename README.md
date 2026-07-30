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
