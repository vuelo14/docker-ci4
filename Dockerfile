# Gunakan image dasar PHP 7.4 dengan Apache
FROM php:7.4-apache

# Update paket dan instal ekstensi PHP yang umum dibutuhkan oleh CodeIgniter 4
# dan aplikasi web modern lainnya.
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libonig-dev \
    libpng-dev \
    libjpeg-dev \
    libwebp-dev \
    libfreetype6-dev \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Install ekstensi PHP yang dibutuhkan:
# pdo_mysql: Untuk koneksi database MySQL/MariaDB
# mbstring: Untuk manipulasi string multibyte (penting untuk UTF-8)
# gd: Untuk manipulasi gambar (sering digunakan di CI4)
# intl: Untuk fitur internasionalisasi (digunakan oleh CI4)
# zip: Untuk bekerja dengan file ZIP (misalnya composer atau upload file)
# exif: Untuk membaca metadata gambar (opsional, tapi berguna)
RUN docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    mbstring \
    gd \
    intl \
    zip \
    exif

# Aktifkan Apache mod_rewrite
# Ini penting agar routing URL di CodeIgniter 4 bisa berfungsi dengan baik
RUN a2enmod rewrite

# Salin file konfigurasi virtual host Apache kustom
# Ini akan mengarahkan DocumentRoot ke folder 'public' CodeIgniter 4
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Setel Work Directory default ke root dokumen web
# Ini adalah tempat di mana proyek CodeIgniter Anda akan dimount nanti
WORKDIR /var/www/html

# Ekspos port 80 untuk akses web
EXPOSE 80

# Anda juga bisa menambahkan konfigurasi PHP kustom jika diperlukan,
# misalnya untuk meningkatkan memory_limit atau max_execution_time
# COPY php.ini /usr/local/etc/php/php.ini
