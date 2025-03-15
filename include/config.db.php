<?php
defined('_VALID') or die('Restricted Access!');
$config['db_type'] = 'mysqli';
$config['db_host'] = 'database';
$config['db_user'] = getenv('MYSQL_USER') ?: '';
$config['db_pass'] = getenv('MYSQL_PASSWORD') ?: '';
$config['db_name'] = getenv('MYSQL_DATABASE') ?: '';
?>
