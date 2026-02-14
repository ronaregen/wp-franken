<?php
// 1. Proxy Fix
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
	$_SERVER['HTTPS'] = 'on';
}

// 2. Logic Hybrid Database (Gaya Paling Galak)
$raw_env = getenv('DB_TYPE');
if (empty($raw_env)) {
	$db_type = 'sqlite'; // Paksa default kalau kosong
} else {
	$db_type = trim(strtolower($raw_env));
}

if ($db_type == 'sqlite') {
	define('DB_ENGINE', 'sqlite');
	define('DB_NAME', 'wp_sqlite');
	define('DB_USER', 'root');
	define('DB_PASSWORD', 'root');
	define('DB_HOST', 'localhost');
} else {
	define('DB_NAME', getenv('DB_NAME') ?: 'wp_db');
	define('DB_USER', getenv('DB_USER') ?: 'wp_user');
	define('DB_PASSWORD', getenv('DB_PASSWORD') ?: '');
	define('DB_HOST', getenv('DB_HOST') ?: 'db');
}

// 3. Salts (Require dari file otomatis)
if (file_exists(__DIR__ . '/wp-content/wp-salts.php')) {
	require_once __DIR__ . '/wp-content/wp-salts.php';
}

$table_prefix = 'wp_';
define('WP_DEBUG', true);
define('WP_DEBUG_DISPLAY', true);

if (!defined('ABSPATH')) {
	define('ABSPATH', __DIR__ . '/');
}
require_once ABSPATH . 'wp-settings.php';