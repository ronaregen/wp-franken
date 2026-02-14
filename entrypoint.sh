#!/bin/bash
set -e

# Lokasi file salt di volume persistent
SALT_FILE="/var/www/html/wp-content/wp-salts.php"

if [ ! -f "$SALT_FILE" ]; then
    echo "Generating new WordPress salts..."
    # Ambil salt random dari API resmi WordPress dan bungkus jadi file PHP
    curl -s https://api.wordpress.org/secret-key/1.1/salt/ > "$SALT_FILE"
    # Tambahin tag PHP di awal file biar bisa di-require
    sed -i '1i <?php' "$SALT_FILE"
    chown www-data:www-data "$SALT_FILE"
fi

# Jalankan perintah utama (FrankenPHP)
exec "$@"