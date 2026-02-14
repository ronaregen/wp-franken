#!/bin/bash
set -e

# 1. Setup SQLite Translator (db.php)
if [ "$DB_TYPE" = "sqlite" ]; then
    echo "Mode: SQLite detected."
    
    # Pastiin folder database ada
    mkdir -p /var/www/html/wp-content/database

    if [ ! -f "/var/www/html/wp-content/db.php" ]; then
        echo "Installing SQLite translator..."
        # Download plugin
        curl -L https://downloads.wordpress.org/plugin/sqlite-database-integration.latest-stable.zip -o /tmp/sqlite-plugin.zip
        
        # Unzip ke folder sementara
        unzip /tmp/sqlite-plugin.zip -d /tmp/
        
        # Copy file sakti db.copy jadi db.php
        cp /tmp/sqlite-database-integration/db.copy /var/www/html/wp-content/db.php
        
        # Bersihin sampah
        rm -rf /tmp/sqlite-plugin.zip /tmp/sqlite-database-integration
        echo "SQLite translator installed successfully."
    fi
else
    echo "Mode: MariaDB/MySQL detected."
    # Hapus db.php kalau ada biar gak bentrok sama MySQL
    if [ -f "/var/www/html/wp-content/db.php" ]; then
        echo "Removing SQLite translator..."
        rm "/var/www/html/wp-content/db.php"
    fi
fi

# 2. Setup Salts (Logic yang kemarin)
SALT_FILE="/var/www/html/wp-content/wp-salts.php"
if [ ! -f "$SALT_FILE" ]; then
    echo "Generating new WordPress salts..."
    curl -s https://api.wordpress.org/secret-key/1.1/salt/ > "$SALT_FILE"
    # Tambahin tag PHP di baris pertama
    sed -i '1i <?php' "$SALT_FILE"
fi

# 3. Fix Permissions (Wajib biar gak error 'Database is locked')
echo "Setting permissions for www-data..."
chown -R www-data:www-data /var/www/html/wp-content

exec "$@"