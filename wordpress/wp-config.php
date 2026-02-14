<?php
// 1. Fix Redirect Loop buat Easypanel
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
	$_SERVER['HTTPS'] = 'on';
}

// 2. Logic Hybrid Database (SQLite / MariaDB)
$db_type = getenv('DB_TYPE') ?: 'sqlite';

if ($db_type === 'sqlite') {
	define('DB_ENGINE', 'sqlite');
	// WordPress Core butuh ini tetap ada supaya gak error duluan
	define('DB_NAME', 'sqlite_db');
	define('DB_USER', 'sqlite');
	define('DB_PASSWORD', 'sqlite');
	define('DB_HOST', 'localhost');
} else {
	define('DB_NAME', getenv('DB_NAME') ?: 'wp_db');
	define('DB_USER', getenv('DB_USER') ?: 'wp_user');
	define('DB_PASSWORD', getenv('DB_PASSWORD') ?: '');
	define('DB_HOST', getenv('DB_HOST') ?: 'db');
}

// 3. PANGGIL SALT OTOMATIS
// File ini digenerate sama entrypoint.sh di folder wp-content
if (file_exists(__DIR__ . '/wp-content/wp-salts.php')) {
	require_once __DIR__ . '/wp-content/wp-salts.php';
}

$table_prefix = 'wp_';
define('WP_DEBUG', false);

if (!defined('ABSPATH')) {
	define('ABSPATH', __DIR__ . '/');
}
require_once ABSPATH . 'wp-settings.php';