#!/bin/bash
set -e

# 1. Setup SQLite Translator (db.php)
if [ "$DB_TYPE" = "sqlite" ]; then
    echo "Mode: SQLite"
    # 1. Pastiin db.php ada buat SQLite
    if [ ! -f "/var/www/html/wp-content/db.php" ]; then
        echo "Installing SQLite translator..."
        # (Proses download plugin & copy db.copy jadi db.php seperti sebelumnya)
    fi
else
    echo "Mode: MariaDB/MySQL"
    # 2. Hapus db.php kalau ada, biar gak ganggu koneksi MariaDB
    if [ -f "/var/www/html/wp-content/db.php" ]; then
        echo "Removing SQLite translator to use native MariaDB engine..."
        rm "/var/www/html/wp-content/db.php"
    fi
fi

# 2. Setup Salts (Logic yang kemarin)
SALT_FILE="/var/www/html/wp-content/wp-salts.php"
if [ ! -f "$SALT_FILE" ]; then
    echo "Generating new WordPress salts..."
    curl -s https://api.wordpress.org/secret-key/1.1/salt/ > "$SALT_FILE"
    sed -i '1i <?php' "$SALT_FILE"
fi

# 3. Fix Permissions (Biar gak 'Database is locked')
chown -R www-data:www-data /var/www/html/wp-content

exec "$@"