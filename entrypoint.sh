#!/bin/bash
set -e

# 1. Setup SQLite Translator (Hybrid Mode)
if [ "$DB_TYPE" = "sqlite" ]; then
    echo "Mode: SQLite"
    mkdir -p /var/www/html/wp-content/database
    mkdir -p /var/www/html/wp-content/plugins

    if [ ! -f "/var/www/html/wp-content/db.php" ]; then
        echo "Installing SQLite translator & plugin..."
        curl -L https://downloads.wordpress.org/plugin/sqlite-database-integration.latest-stable.zip -o /tmp/sqlite-plugin.zip
        unzip /tmp/sqlite-plugin.zip -d /tmp/
        
        # PINDAHKAN SELURUH FOLDER PLUGIN (Ini yang tadi kurang!)
        cp -r /tmp/sqlite-database-integration /var/www/html/wp-content/plugins/
        
        # COPY DROP-IN KE WP-CONTENT
        cp /var/www/html/wp-content/plugins/sqlite-database-integration/db.copy /var/www/html/wp-content/db.php
        
        rm -rf /tmp/sqlite-plugin.zip /tmp/sqlite-database-integration
        echo "SQLite system is ready!"
    fi
else
    echo "Mode: MariaDB/MySQL"
    if [ -f "/var/www/html/wp-content/db.php" ]; then
        rm "/var/www/html/wp-content/db.php"
    fi
fi

# 2. Setup Salts
SALT_FILE="/var/www/html/wp-content/wp-salts.php"
if [ ! -f "$SALT_FILE" ]; then
    echo "Generating salts..."
    curl -s https://api.wordpress.org/secret-key/1.1/salt/ > "$SALT_FILE"
    sed -i '1i <?php' "$SALT_FILE"
fi

# 3. Fix Permissions
chown -R www-data:www-data /var/www/html/wp-content

exec "$@"